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
import java.io.IOException
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

        /// Явный динамический загрузчик musl: обход молчаливого отказа
        /// execve динамических бинарей под proot (см. detectExecMode).
        const val MUSL_LOADER = "/lib/ld-musl-aarch64.so.1"
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

        /// Флаг немедленной остановки: выставляется в onStartCommand ДО
        /// постановки в executor (single-thread) — иначе stop ждал бы конца
        /// boot-секции (сеть до 5 попыток). Проверяется в циклах boot.
        @Volatile
        var stopRequested: Boolean = false
            private set

        @Volatile
        private var destroyed: Boolean = false

        fun lastErrorSet(value: String?) = synchronized(stateLock) {
            lastError = value
        }

        fun currentStateMap(): Map<String, Any?> = synchronized(stateLock) {
            val svc = serviceInstance
            // В панели лога показываем и загрузочный лог: до READY serve.log
            // пуст, а именно тогда падает установка — apk.log обязан быть виден.
            val logTail = svc?.let {
                val apkTail = HealthCheck.tail(File(SandboxPaths.logs(it), "apk.log"), 4096).trim()
                val serveTail = HealthCheck.tail(File(SandboxPaths.logs(it), "serve.log"), 4096).trim()
                val bootTail = SandboxLogger.tail(2048).trim()
                buildString {
                    if (bootTail.isNotEmpty()) append("── boot.log ──\n$bootTail\n")
                    if (apkTail.isNotEmpty()) append("\n── apk.log ──\n$apkTail\n")
                    if (serveTail.isNotEmpty()) append("\n── serve.log ──\n$serveTail")
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
        SandboxLogger.init(this)
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
                // Немедленно: флаг до executor (boot прервётся в ближайшей
                /// проверке), proot гасим сразу — waitFor вернёт управление.
                stopRequested = true
                manager.stop()
                executor.execute { shutdown() }
            }
            ACTION_RESET -> {
                stopRequested = true
                manager.stop()
                executor.execute {
                    shutdown()
                    SandboxPaths.wipe(this)
                    setState(Phase.UNINITIALIZED, "Песочница удалена")
                }
            }
            else -> {
                stopRequested = false
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

    // Режим исполнения внутри proot (определяется пробами на каждый boot):
    // на устройстве пользователя прямой exec динамических бинарей (apk,
    // opencode — у обоих NEEDED помимо libc) умирает молча с 255 при пустом
    // выводе, тогда как busybox (единственный NEEDED — интерпретатор-симлинк
    // libc.musl→ld-musl) и sh работают. Явный запуск через загрузчик
    // (/lib/ld-musl-aarch64.so.1 <bin>) — другой execve-путь; если он даёт
    // код 0, serve и apk получают соответствующий префикс.
    private var muslServePrefix: String = ""
    private var muslApkPrefix: String = ""
    private var echoCode = -1
    private var shCode = -1
    private var apkDirectCode = -1
    private var apkMuslCode = -1
    private var ocDirectCode = -1
    private var ocMuslCode = -1

    private fun bootSequence() {
        val t0 = System.currentTimeMillis()
        try {
            lastErrorSet(null)
            SandboxLogger.i("=== boot: старт (v0.3.7) ===")

            checkStop()
            setState(Phase.INSTALLING_ROOTFS, "Распаковка Alpine rootfs")
            val rootfs = installer.ensureRootfs(
                { bytes, total ->
                    if (total > 0) {
                        setState(Phase.INSTALLING_ROOTFS, "Распаковка Alpine rootfs", bytes / total.toDouble())
                    }
                },
                { stopRequested },
            )
            val sh = File(rootfs, "bin/sh")
            val shOk = java.nio.file.Files.isSymbolicLink(sh.toPath()) || sh.exists()
            SandboxLogger.i(
                "rootfs готов (${installer.rootfsVersion}, bin/sh=${shOk}, " +
                    "busybox=${File(rootfs, "bin/busybox").exists()})",
            )

            checkStop()
            installer.writeResolvConf(rootfs)
            installer.ensureRepositories(rootfs)
            SandboxLogger.i("resolv.conf/repositories обновлены")

            checkStop()
            setState(Phase.DOWNLOADING_OPENCODE, "Загрузка opencode ${installer.opencodeVersion}")
            installer.ensureOpencode(
                rootfs,
                { bytes, total ->
                    if (total > 0) {
                        setState(
                            Phase.DOWNLOADING_OPENCODE,
                            "Загрузка opencode ${installer.opencodeVersion}",
                            bytes / total.toDouble(),
                        )
                    }
                },
                { stopRequested },
            )
            SandboxLogger.i("opencode ${installer.opencodeVersion} готов")

            checkStop()
            detectExecMode(rootfs)

            val apkMarker = File(rootfs, ".pf-apk-bootstrap")
            if (!apkMarker.exists()) {
                bootstrapApkPackages(rootfs)
                apkMarker.writeText(installer.opencodeVersion)
                SandboxLogger.i("apk-маркер поставлен")
            } else {
                SandboxLogger.i("apk-пакеты уже установлены (маркер есть)")
            }

            checkStop()
            setState(Phase.STARTING, "Запуск opencode serve")
            val logFile = File(SandboxPaths.logs(this), "serve.log")
            manager.startServe(logFile, muslServePrefix)
            healthy = false
            SandboxLogger.i("proot запущен, порт=${manager.port}, префикс='${muslServePrefix.trim()}'")

            val deadline = System.currentTimeMillis() + 90_000
            while (System.currentTimeMillis() < deadline) {
                checkStop()
                if (!manager.isAlive()) {
                    val served = logFile.let { HealthCheck.tail(it, 400).trim() }
                    val detail = when {
                        served.isEmpty() -> "(пусто — sh внутри proot не стартовал)"
                        served.contains("pf-serve-boot") && served.length < 60 ->
                            "(sh выполнился, но opencode не напечатал ничего — отказ exec)"
                        else -> served
                    }
                    throw java.io.IOException("proot завершился до успешного healthcheck; serve.log: $detail")
                }
                val code = try {
                    HealthCheck.check(manager.port, manager.password)
                } catch (_: java.io.IOException) {
                    -1
                }
                if (code == 200) {
                    healthy = true
                    SandboxLogger.i("healthcheck 200, boot завершён за ${System.currentTimeMillis() - t0} мс")
                    setState(Phase.READY, "Готово: 127.0.0.1:${manager.port}")
                    return
                }
                Thread.sleep(1000)
            }
            throw java.io.IOException(
                "healthcheck не прошёл за 90 секунд; " +
                    "serve.log: ${HealthCheck.tail(logFile, 400).trim().ifEmpty { "(пусто)" }}",
            )
        } catch (e: Exception) {
            SandboxLogger.e("boot failed", e)
            healthy = false
            val msg = e.message?.takeIf { it.isNotBlank() } ?: e.javaClass.simpleName
            lastErrorSet(msg)
            manager.stop()
            if (stopRequested) {
                setState(Phase.STOPPED, "Песочница остановлена")
            } else {
                val bootTail = SandboxLogger.tail(600).trim()
                setState(Phase.ERROR, "Ошибка запуска: $msg${if (bootTail.isEmpty()) "" else "\nЛог: $bootTail"}")
            }
        }
    }

    private fun checkStop() {
        if (stopRequested) throw java.io.IOException("Песочница остановлена")
    }

    /// Матрица проб исполнения внутри proot — на каждый boot (пробы дешёвые,
    /// ~0.5 с суммарно; сеть/Wi-Fi между запусками не влияет). Результаты
    /// пишутся в boot.log целиком — следующий экспорт логов будет содержать
    /// полный расклад даже если serve снова умрёт.
    private fun detectExecMode(rootfs: File) {
        val checkLog = File(SandboxPaths.logs(this), "proot-check.log")

        fun probe(name: String, cmd: String): Int {
            checkLog.writeText("")
            val code = try {
                manager.runOnce(cmd, checkLog, 30_000)
            } catch (e: IOException) {
                SandboxLogger.w("probe $name: ${e.message}")
                return -1
            }
            val out = HealthCheck.tail(checkLog, 200).trim().replace("\n", " | ")
            SandboxLogger.i(
                "probe $name: код $code${if (out.isEmpty()) if (code == 0) "" else " (молчаливый отказ)" else ", вывод: $out"}",
            )
            return code
        }

        setState(Phase.STARTING, "Проверка режима исполнения песочницы")
        echoCode = probe("echo", "/bin/echo pf-proot-ok")
        shCode = probe("sh", "/bin/sh -c 'echo pf-sh-ok'")
        apkDirectCode = probe("apk-direct", "/sbin/apk --version")
        apkMuslCode = probe("apk-ldmusl", "/lib/ld-musl-aarch64.so.1 /sbin/apk --version")
        ocDirectCode = probe("opencode-direct", "/usr/local/bin/opencode --version")
        ocMuslCode = probe("opencode-ldmusl", "/lib/ld-musl-aarch64.so.1 /usr/local/bin/opencode --version")

        muslServePrefix =
            if (ocDirectCode == 0) "" else if (ocMuslCode == 0) MUSL_LOADER + " " else ""
        muslApkPrefix =
            if (apkDirectCode == 0) "" else if (apkMuslCode == 0) MUSL_LOADER + " " else ""
        SandboxLogger.i(
            "режим исполнения: serve-префикс='${muslServePrefix.trim().ifEmpty { "прямой" }}', " +
                "apk-префикс='${muslApkPrefix.trim().ifEmpty { "прямой" }}'",
        )
        if (muslServePrefix.isEmpty() && ocDirectCode != 0) {
            SandboxLogger.w(
                "opencode не исполняется ни напрямую ($ocDirectCode), ни через ld-musl ($ocMuslCode) — serve, вероятно, упадёт; нужен экспорт логов",
            )
        }
    }

    /// Установка apk-пакетов: apk внутри proot (с префиксом по пробам) либо
    /// прямой bootstrap через Android-сеть (без исполнения под proot).
    private fun bootstrapApkPackages(rootfs: File) {
        if (echoCode != 0) {
            // sh внутри proot не исполняется — и serve не заведётся; fail fast.
            throw java.io.IOException(
                "proot не смог выполнить /bin/echo (код $echoCode) — проверьте экспорт логов",
            )
        }

        val apkUsable = apkDirectCode == 0 || apkMuslCode == 0
        if (apkUsable) {
            val pkgs = installer.apkPackages.joinToString(" ")
            val logFile = File(SandboxPaths.logs(this), "apk.log")
            logFile.writeText("")
            for (attempt in 1..2) {
                checkStop()
                setState(Phase.BOOTSTRAPPING_APK, "Установка: apk add $pkgs (попытка $attempt из 2)")
                val code = manager.runOnce(
                    "${muslApkPrefix}apk update && ${muslApkPrefix}apk add --no-cache $pkgs",
                    logFile,
                    600_000,
                )
                SandboxLogger.i("apk add попытка $attempt: код $code")
                if (code == 0) return
                if (attempt == 1) {
                    try {
                        Thread.sleep(3000)
                    } catch (_: InterruptedException) {
                        Thread.currentThread().interrupt()
                        break
                    }
                }
            }
            val tail = HealthCheck.tail(logFile, 600).trim()
            SandboxLogger.w("apk-путь не удался, переключаюсь на прямой bootstrap; apk.log: $tail")
        } else {
            SandboxLogger.w(
                "apk не исполняется в proot (direct=$apkDirectCode, ldmusl=$apkMuslCode) — прямой bootstrap",
            )
        }

        // Прямой bootstrap: скачивание через Android-стек, распаковка в rootfs.
        setState(Phase.BOOTSTRAPPING_APK, "Установка пакетов через сеть Android (без proot)")
        val nb = NativeBootstrap(this) { pkg, done, total ->
            val pct = if (total > 0) done * 100 / total else -1
            setState(
                Phase.BOOTSTRAPPING_APK,
                "Установка пакетов: $pkg (${pct.takeIf { it >= 0 } ?: "…"}%)",
            )
        }
        nb.bootstrapPackages(rootfs, installer.apkPackages)
        SandboxLogger.i("прямой bootstrap завершён")
    }

    private fun startWatchdog() {
        watchdogHandler.postDelayed(object : Runnable {
            override fun run() {
                // executor.shutdownNow() в onDestroy гонит RejectedExecutionException
                // в handler-поток — крэш приложения; глушим и не перепланируем.
                if (destroyed) return
                try {
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
                } catch (_: java.util.concurrent.RejectedExecutionException) {
                    return
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
        destroyed = true
        watchdogHandler.removeCallbacksAndMessages(null)
        executor.shutdownNow()
        manager.stop()
        serviceInstance = null
        Log.i(TAG, "RuntimeService destroyed")
        super.onDestroy()
    }

    override fun onBind(intent: Intent?): IBinder? = null
}
