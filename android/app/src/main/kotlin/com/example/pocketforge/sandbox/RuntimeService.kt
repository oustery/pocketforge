package com.example.pocketforge.sandbox

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.util.concurrent.Executors
import java.util.concurrent.atomic.AtomicInteger

enum class Phase { UNINITIALIZED, INSTALLING_ROOTFS, DOWNLOADING_OPENCODE, BOOTSTRAPPING_APK, STARTING, READY, STOPPED, ERROR }

/// Foreground-сервис: держит proot+opencode живым, watchdog перезапускает
/// песочницу после kill'ов (в т.ч. phantom process killer на Android 12+).
class RuntimeService : Service() {

    companion object {
        private const val TAG = "PocketForge.Runtime"
        private const val CHANNEL_ID = "pocketforge_sandbox"
        private const val NOTIFICATION_ID = 1
        const val ACTION_START = "com.example.pocketforge.sandbox.START"
        const val ACTION_STOP = "com.example.pocketforge.sandbox.STOP"
        const val ACTION_RESET = "com.example.pocketforge.sandbox.RESET"

        @Volatile
        private var phase: Phase = Phase.UNINITIALIZED

        // message/progress/lastError читаются из чужих потоков (3-секундный
        // poll из Dart идёт через main/binder) — записи и снимок состояния
        // под stateLock, иначе UI ловит разорванное состояние: фаза ERROR
        // со старым сообщением шага («Загрузка opencode…») вместо ошибки.
        private val stateLock = Any()
        private var message: String = ""
        private var progress: Double? = null
        private var lastError: String? = null
        private var lastProgressPercent = -1

        @Volatile
        private var serviceInstance: RuntimeService? = null
        var methodChannel: MethodChannel? = null

        fun currentStateMap(): Map<String, Any?> = synchronized(stateLock) {
            val svc = serviceInstance
            // В панели лога показываем и загрузочный лог: до READY serve.log
            // пуст, а именно тогда падает установка — apk.log обязан быть виден.
            val logTail = svc?.let {
                val apkTail = HealthCheck.tail(File(SandboxPaths.logs(it), "apk.log"), 4096).trim()
                val serveTail = HealthCheck.tail(File(SandboxPaths.logs(it), "serve.log"), 4096).trim()
                buildString {
                    if (apkTail.isNotEmpty()) append("── apk.log ──\n$apkTail\n")
                    if (serveTail.isNotEmpty()) append("── serve.log ──\n$serveTail")
                }
            } ?: ""
            mapOf(
                "phase" to phase.name.lowercase(),
                "message" to message,
                "progress" to progress,
                "port" to svc?.manager?.port?.takeIf { it > 0 },
                "healthy" to (phase == Phase.READY && svc?.healthy == true),
                "logTail" to logTail,
                "lastError" to lastError,
            )
        }

        fun stopSandbox(ctx: Context) {
            val intent = Intent(ctx, RuntimeService::class.java).setAction(ACTION_STOP)
            ctx.startService(intent)
        }

        fun resetSandbox(ctx: Context) {
            val intent = Intent(ctx, RuntimeService::class.java).setAction(ACTION_RESET)
            ctx.startService(intent)
        }

        /// Команда в песочнице с захватом вывода (M7 терминал).
        /// Блокирующая — вызывающий обязан держать её вне main-thread
        /// (MainActivity выполняет exec на собственном executor).
        fun execInSandbox(command: String, timeoutMs: Long): Map<String, Any?> {
            val svc = serviceInstance
                ?: throw java.io.IOException("Сервис песочницы не запущен")
            if (phase != Phase.READY) {
                throw java.io.IOException(
                    "Песочница не готова (фаза: ${phase.name.lowercase()})",
                )
            }
            return svc.manager.exec(command, timeoutMs)
        }

        private fun setState(p: Phase, msg: String = "", prog: Double? = null) {
            val push: Boolean
            synchronized(stateLock) {
                phase = p
                message = msg
                progress = prog
                // Прогресс шлём при смене целого процента, а не на каждый чанк
                // (на 80 МБ это тысячи invokeMethod в main-поток).
                val pct = prog?.let { (it * 100).toInt() } ?: -1
                push = if (p == Phase.DOWNLOADING_OPENCODE || p == Phase.INSTALLING_ROOTFS) {
                    val changed = pct != lastProgressPercent
                    lastProgressPercent = pct
                    changed
                } else {
                    lastProgressPercent = -1
                    true
                }
            }
            if (push) pushToFlutter()
        }

        private fun pushToFlutter() {
            val handler = Handler(Looper.getMainLooper())
            handler.post {
                methodChannel?.invokeMethod("onState", currentStateMap())
            }
        }
    }

    lateinit var manager: ProotManager
    private lateinit var installer: RootfsInstaller
    private lateinit var executor: java.util.concurrent.ExecutorService
    private lateinit var watchdogHandler: Handler
    private val healthFailures = AtomicInteger(0)
    @Volatile
    var healthy: Boolean = false
        private set

    override fun onCreate() {
        super.onCreate()
        SandboxPaths.ensureAll(this)
        manager = ProotManager(this)
        installer = RootfsInstaller(this)
        executor = Executors.newSingleThreadExecutor()
        watchdogHandler = Handler(Looper.getMainLooper())
        serviceInstance = this
        startWatchdog()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundCompat()
        when (intent?.action) {
            ACTION_STOP -> {
                executor.execute { shutdown() }
            }
            ACTION_RESET -> {
                executor.execute {
                    shutdown()
                    SandboxPaths.wipe(this)
                    setState(Phase.UNINITIALIZED, "Песочница удалена")
                }
            }
            else -> {
                if (phase == Phase.READY || phase == Phase.STARTING ||
                    phase == Phase.INSTALLING_ROOTFS || phase == Phase.DOWNLOADING_OPENCODE ||
                    phase == Phase.BOOTSTRAPPING_APK
                ) {
                    // уже запускается/работает
                } else {
                    healthFailures.set(0)
                    executor.execute { bootSequence() }
                }
            }
        }
        return START_STICKY
    }

    private fun bootSequence() {
        try {
            lastError = null

            setState(Phase.INSTALLING_ROOTFS, "Распаковка Alpine rootfs")
            val rootfs = installer.ensureRootfs { bytes, total ->
                if (total > 0) {
                    setState(Phase.INSTALLING_ROOTFS, "Распаковка Alpine rootfs", bytes / total.toDouble())
                }
            }

            // DNS/репозитории обновляем на каждый запуск: сеть (и DNS оператора)
            // могла смениться с прошлой установки (Wi-Fi ↔ мобильная).
            installer.writeResolvConf(rootfs)
            installer.ensureRepositories(rootfs)

            setState(Phase.DOWNLOADING_OPENCODE, "Загрузка opencode ${installer.opencodeVersion}")
            installer.ensureOpencode(rootfs) { bytes, total ->
                if (total > 0) {
                    setState(
                        Phase.DOWNLOADING_OPENCODE,
                        "Загрузка opencode ${installer.opencodeVersion}",
                        bytes / total.toDouble(),
                    )
                }
            }

            val apkMarker = File(rootfs, ".pf-apk-bootstrap")
            val pkgs = installer.apkPackages.joinToString(" ")
            if (!apkMarker.exists()) {
                // Самотест proot ДО apk: отделяем «не запускается /bin/sh в
                // proot» (молчаливый 255, вывод пуст — см. TarExtractor) от
                // «apk не смог скачать пакеты» (в apk.log есть строки).
                val checkLog = File(SandboxPaths.logs(this), "proot-check.log")
                val checkCode = manager.runOnce("/bin/echo pf-proot-ok", checkLog)
                if (checkCode != 0) {
                    val tail = HealthCheck.tail(checkLog, 400).trim()
                    throw java.io.IOException(
                        "proot не смог выполнить /bin/echo в песочнице (код $checkCode); " +
                            "вывод: ${if (tail.isEmpty()) "(пусто)" else tail}",
                    )
                }
                val logFile = File(SandboxPaths.logs(this), "apk.log")
                var code = -1
                var attempts = 0
                // 2 попытки: одиночный сбой DNS/обрыв канала на мобильной сети
                // не должен валить всю установку.
                while (attempts < 2) {
                    attempts++
                    setState(Phase.BOOTSTRAPPING_APK, "Установка: apk add $pkgs (попытка $attempts из 2)")
                    code = manager.runOnce("apk update && apk add --no-cache $pkgs", logFile)
                    if (code == 0) break
                    if (attempts < 2) {
                        try {
                            Thread.sleep(3000)
                        } catch (_: InterruptedException) {
                            Thread.currentThread().interrupt()
                            throw java.io.IOException("Bootstrap прерван")
                        }
                    }
                }
                if (code != 0) {
                    // Показываем реальный вывод apk в карточке ошибки — иначе
                    // «(нет сети?)» остаётся догадкой (проверено на устройстве).
                    val tail = HealthCheck.tail(logFile, 600).trim()
                    val cause = if (tail.isEmpty()) {
                        " (вывод apk пуст — обычно это отказ execve внутри proot)"
                    } else {
                        ". Хвост apk.log:\n$tail"
                    }
                    throw java.io.IOException("apk add завершился с кодом $code$cause")
                }
                apkMarker.writeText(installer.opencodeVersion)
            }

            setState(Phase.STARTING, "Запуск opencode serve")
            val logFile = File(SandboxPaths.logs(this), "serve.log")
            manager.startServe(logFile)
            healthy = false

            val deadline = System.currentTimeMillis() + 90_000
            while (System.currentTimeMillis() < deadline) {
                if (!manager.isAlive()) {
                    throw java.io.IOException("proot завершился до успешного healthcheck")
                }
                val code = try {
                    HealthCheck.check(manager.port, manager.password)
                } catch (_: java.io.IOException) {
                    -1
                }
                if (code == 200) {
                    healthy = true
                    setState(Phase.READY, "Готово: 127.0.0.1:${manager.port}")
                    return
                }
                Thread.sleep(1000)
            }
            throw java.io.IOException("healthcheck не прошёл за 90 секунд")
        } catch (e: Exception) {
            Log.e(TAG, "bootSequence failed", e)
            healthy = false
            lastError = e.message ?: e.javaClass.simpleName
            manager.stop()
            setState(Phase.ERROR, "Ошибка запуска: ${lastError}")
        }
    }

    private fun startWatchdog() {
        watchdogHandler.postDelayed(object : Runnable {
            override fun run() {
                executor.execute {
                    val p = manager
                    if (phase == Phase.READY) {
                        if (!p.isAlive()) {
                            Log.w(TAG, "watchdog: proot мёртв — перезапуск")
                            healthFailures.set(0)
                            setState(Phase.STARTING, "watchdog: перезапуск песочницы")
                            bootSequence()
                            return@execute
                        }
                        val code = try {
                            HealthCheck.check(p.port, p.password)
                        } catch (_: java.io.IOException) {
                            -1
                        }
                        if (code == 200) {
                            healthFailures.set(0)
                            if (!healthy) {
                                healthy = true
                                pushToFlutter()
                            }
                        } else {
                            val fails = healthFailures.incrementAndGet()
                            Log.w(TAG, "watchdog: health=$code, подряд=$fails")
                            if (fails >= 3) {
                                healthFailures.set(0)
                                setState(Phase.STARTING, "watchdog: serve не отвечает — перезапуск")
                                p.stop()
                                bootSequence()
                            }
                        }
                    }
                }
                watchdogHandler.postDelayed(this, 10_000)
            }
        }, 10_000)
    }

    private fun shutdown() {
        manager.stop()
        healthy = false
        setState(Phase.STOPPED, "Песочница остановлена")
        stopForeground(true)
        stopSelf()
    }

    private fun startForegroundCompat() {
        val nm = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (android.os.Build.VERSION.SDK_INT >= 26) {
            nm.createNotificationChannel(
                NotificationChannel(CHANNEL_ID, "Песочница PocketForge", NotificationManager.IMPORTANCE_LOW),
            )
        }
        val notification: Notification = Notification.Builder(this, CHANNEL_ID)
            .setContentTitle("PocketForge")
            .setContentText("Песочница opencode работает")
            .setSmallIcon(android.R.drawable.stat_notify_sync_noanim)
            .setOngoing(true)
            .build()
        startForeground(NOTIFICATION_ID, notification)
    }

    override fun onDestroy() {
        watchdogHandler.removeCallbacksAndMessages(null)
        executor.shutdownNow()
        manager.stop()
        serviceInstance = null
        Log.i(TAG, "RuntimeService destroyed")
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
