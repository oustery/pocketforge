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

enum class Phase { UNINITIALIZED, INSTALLING_ROOTFS, DOWNLOADING_OPENCODE, BOOTSTRAPPING_PACKAGES, STARTING, READY, STOPPED, ERROR }

/// Foreground-сервис: держит proot+opencode живым, watchdog перезапускает
/// песочницу после kill'ов (в т.ч. phantom process killer на Android 12+).
class RuntimeService : Service() {

    companion object {
        private const val TAG = "PocketForge.Runtime"
        private const val CHANNEL_ID = "pocketforge_sandbox"
        private const val NOTIFICATION_ID = 1
        const val ACTION_START = "com.example.pocketforge.sandbox.START"

        /// Явный динамический загрузчик glibc: обход молчаливого отказа
        /// execve динамических бинарей под proot (см. detectExecMode).
        /// В Debian путь /lib/ld-linux-aarch64.so.1 резолвится через
        /// usrmerge-симлинк /lib → /usr/lib.
        const val GLIBC_LOADER = "/lib/ld-linux-aarch64.so.1"
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

        // Хвосты логов пересчитываются не чаще раза в секунду: без кеша
        // currentStateMap() (main-поток: status-поллинг и каждый push)
        // читал три файла с диска при каждом обращении.
        private var logTailCache: String = ""

        @Volatile
        private var logTailCacheAt: Long = 0

        fun lastErrorSet(value: String?) = synchronized(stateLock) {
            lastError = value
        }

        fun currentStateMap(): Map<String, Any?> = synchronized(stateLock) {
            val svc = serviceInstance
            // В панели лога показываем и загрузочный лог: до READY serve.log
            // пуст, а именно тогда падает установка — apt.log обязан быть виден.
            val logTail = svc?.let {
                val now = android.os.SystemClock.elapsedRealtime()
                if (now - logTailCacheAt > 1000) {
                    val aptTail = HealthCheck.tail(File(SandboxPaths.logs(it), "apt.log"), 4096).trim()
                    val serveTail = HealthCheck.tail(File(SandboxPaths.logs(it), "serve.log"), 4096).trim()
                    val bootTail = SandboxLogger.tail(2048).trim()
                    logTailCache = buildString {
                        if (bootTail.isNotEmpty()) append("── boot.log ──\n$bootTail\n")
                        if (aptTail.isNotEmpty()) append("\n── apt.log ──\n$aptTail\n")
                        if (serveTail.isNotEmpty()) append("\n── serve.log ──\n$serveTail")
                    }
                    logTailCacheAt = now
                }
                logTailCache
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

        // Только по запросу внутрипроцессного Flutter-канала; не часть статуса и логов.
        fun connectionPassword(port: Int): String? = synchronized(stateLock) {
            val svc = serviceInstance ?: return@synchronized null
            val manager = svc.manager
            manager.password.takeIf {
                phase == Phase.READY && svc.healthy && manager.port == port && it.isNotBlank()
            }
        }

        fun stopSandbox(ctx: Context) {
            val intent = Intent(ctx, RuntimeService::class.java).setAction(ACTION_STOP)
            // O+: startService из фона (Dart-канал при живом FGS) бросает
            // IllegalStateException и stop не срабатывает вовсе.
            if (android.os.Build.VERSION.SDK_INT >= 26) {
                ctx.startForegroundService(intent)
            } else {
                ctx.startService(intent)
            }
        }

        fun resetSandbox(ctx: Context) {
            val intent = Intent(ctx, RuntimeService::class.java).setAction(ACTION_RESET)
            if (android.os.Build.VERSION.SDK_INT >= 26) {
                ctx.startForegroundService(intent)
            } else {
                ctx.startService(intent)
            }
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
        // Сервис может пересоздаваться в том же процессе после
        // shutdown() → onDestroy (destroyed = true): без сброса watchdog
        // навсегда выходил по if (destroyed) return и proot больше не
        // перезапускался.
        destroyed = false
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
                /// проверке). Сам proot гасим внутри shutdown() на executor —
                /// manager.stop() ждёт до ~8 с (destroy + waitFor) и на
                /// main-потоке давал ANR при залипшем proot.
                stopRequested = true
                executor.execute { shutdown() }
            }
            ACTION_RESET -> {
                stopRequested = true
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
                    phase == Phase.BOOTSTRAPPING_PACKAGES
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
    // на устройстве пользователя прямой exec динамических бинарей (apt-get,
    // opencode — у обоих NEEDED помимо libc) умирает молча с 255 при пустом
    // выводе, тогда как sh и статические бинари работают. Явный запуск через
    // загрузчик (/lib/ld-linux-aarch64.so.1 <bin>) — другой execve-путь;
    // если он даёт код 0, serve и apt-get получают соответствующий префикс.
    private var pkgPrefix: String = ""

    /// Полная стратегия запуска opencode для serve: пусто (прямой exec),
    /// «/lib/ld-linux-aarch64.so.1 » (явный загрузчик) или env+загрузчик
    /// («BUN_JSC_useJIT=0 /lib/ld-linux-aarch64.so.1 »). Выбирается пробами;
    /// на устройстве с ROM-спецификой прямой exec тяжёлых бинарей умирает
    /// молча, а другой путь/окружение жив.
    private var serveStrategy: String = ""

    /// native bootstrap уже отработал в ЭТОМ boot — ремонт не повторяет его.
    private var pkgBootstrapDoneThisBoot = false
    private var echoCode = -1
    private var shCode = -1
    private var aptDirectCode = -1
    private var aptLoaderCode = -1
    private var ocDirectCode = -1
    private var ocLoaderCode = -1

    private fun bootSequence() {
        val t0 = System.currentTimeMillis()
        try {
            lastErrorSet(null)
            SandboxLogger.i("=== boot: старт (v0.3.8) ===")

            checkStop()
            setState(Phase.INSTALLING_ROOTFS, "Распаковка Debian rootfs")
            val rootfs = installer.ensureRootfs(
                { bytes, total ->
                    if (total > 0) {
                        setState(Phase.INSTALLING_ROOTFS, "Распаковка Debian rootfs", bytes / total.toDouble())
                    }
                },
                { stopRequested },
            )
            val sh = File(rootfs, "bin/sh")
            val shOk = java.nio.file.Files.isSymbolicLink(sh.toPath()) || sh.exists()
            SandboxLogger.i(
                "rootfs готов (${installer.rootfsVersion}, bin/sh=${shOk}, " +
                    "apt-get=${File(rootfs, "usr/bin/apt-get").exists()})",
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

            val pkgMarker = File(rootfs, ".pf-pkg-bootstrap")
            if (!pkgMarker.exists()) {
                bootstrapPackages(rootfs)
                pkgMarker.writeText(installer.opencodeVersion)
                SandboxLogger.i("маркер пакетов поставлен")
            } else {
                SandboxLogger.i("пакеты уже установлены (маркер есть)")
            }
            pkgBootstrapDoneThisBoot = true

            // opencode не исполняется ни одной пробой — ремонт: переустановка
            // бинаря и библиотек и повторная матрица проб. Если diagOpenCode
            // нашла живую стратегию (например, без JIT) — serve заведётся
            // без ремонта.
            if (ocDirectCode != 0 && ocLoaderCode != 0 && serveStrategy.isEmpty()) {
                repairAndRecheck(rootfs)
            }
            verifyToolchain(rootfs)

            checkStop()
            setState(Phase.STARTING, "Запуск opencode serve")
            val logFile = File(SandboxPaths.logs(this), "serve.log")
            manager.startServe(logFile, serveStrategy)
            healthy = false
            SandboxLogger.i("proot запущен, порт=${manager.port}, стратегия='${serveStrategy.trim().ifEmpty { "прямой" }}'")

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
                    val ec = manager.exitCode()
                    throw java.io.IOException(
                        "proot завершился до успешного healthcheck " +
                            "(код=$ec); serve.log: $detail",
                    )
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
        setState(Phase.STARTING, "Проверка режима исполнения песочницы")
        echoCode = probe("echo", "/bin/echo pf-proot-ok")
        shCode = probe("sh", "/bin/sh -c 'echo pf-sh-ok'")
        aptDirectCode = probe("apt-direct", "/usr/bin/apt-get --version")
        aptLoaderCode = probe("apt-loader", "$GLIBC_LOADER /usr/bin/apt-get --version")
        ocDirectCode = probe("opencode-direct", "/usr/local/bin/opencode --version")
        ocLoaderCode = probe("opencode-loader", "$GLIBC_LOADER /usr/local/bin/opencode --version")

        serveStrategy =
            if (ocDirectCode == 0) "" else if (ocLoaderCode == 0) GLIBC_LOADER + " " else ""
        pkgPrefix =
            if (aptDirectCode == 0) "" else if (aptLoaderCode == 0) GLIBC_LOADER + " " else ""
        SandboxLogger.i(
            "режим исполнения: serve-стратегия='${serveStrategy.trim().ifEmpty { "прямой" }}', " +
                "apt-префикс='${pkgPrefix.trim().ifEmpty { "прямой" }}'",
        )
        if (ocDirectCode != 0 && ocLoaderCode != 0) {
            SandboxLogger.w(
                "opencode не исполняется ни напрямую ($ocDirectCode), ни через ld-linux ($ocLoaderCode) — диагностика",
            )
            diagOpenCode()
        }
        if (ocDirectCode != 0 && ocLoaderCode != 0 && serveStrategy.isNotEmpty()) {
            SandboxLogger.i(
                "живая стратегия serve найдена: '${serveStrategy.trim()}' — ремонт не требуется",
            )
        }
    }

    /// Диагностика отказа opencode: факты МАЛЫМИ чтениями (md5sum/ls на 213 МБ
    /// на устройстве умирают молча — большие операции под proot ненадёжны),
    /// verbose-проба proot (печатает статус/сигнал смерти гостя) и матрица
    /// вариантов запуска: если какой-то жив — он становится serve-стратегией.
    private fun diagOpenCode() {
        // Размеры на устройстве: opencode ~212651000 байт; libstdc++ — из пакета.
        probe(
            "diag-ls",
            "ls -l /usr/local/bin/opencode /usr/local/bin/.pf-opencode-version /usr/lib/aarch64-linux-gnu/libstdc++.so.6*",
            20_000,
        )
        // Память и диск: apt install и md5sum умирали молча — пусть будет факт.
        probe("diag-free-df", "free -m | head -3; df -h /root /tmp | head -4", 20_000)
        // md5 МАЛОЙ библиотеки: целость установленной либы.
        probe("diag-md5-libstdc", "md5sum /usr/lib/aarch64-linux-gnu/libstdc++.so.6.*", 60_000)
        // Внутренняя причина смерти гостя: proot печатает «exited with status N» /
        // «terminated with signal N» — различает exit(255) и сигнал (SIGBUS/SIGKILL).
        probeVerbose("opencode-verbose", "/usr/local/bin/opencode --version", 60_000)
        probeVerbose(
            "opencode-verbose-loader",
            "$GLIBC_LOADER /usr/local/bin/opencode --version",
            60_000,
        )
        // Варианты окружения/загрузчика. BUN_JSC_useJIT=0 отключает JIT —
        // на ROM с запретом RWX-маппинга (execmem) это единственный путь.
        val variants = listOf(
            "opencode-nojit" to
                "BUN_JSC_useJIT=0 BUN_JSC_useFTLJIT=0 /usr/local/bin/opencode --version",
            "opencode-nojit-loader" to
                "BUN_JSC_useJIT=0 BUN_JSC_useFTLJIT=0 $GLIBC_LOADER /usr/local/bin/opencode --version",
        )
        for ((name, cmd) in variants) {
            if (probe(name, cmd, 60_000) == 0) {
                serveStrategy = cmd.substringBefore("/usr/local/bin/opencode").trim() + " "
                return
            }
        }
        // Ни одна стратегия не жива — md5 бинаря на устройстве не получить
        // (md5sum на большом файле умирает молча); целость гарантируется
        // md5-верификацией ПОСЛЕ записи на Android-стороне.
        val refMd5 = installer.opencodeBinaryMd5()
        if (refMd5 != null) {
            SandboxLogger.i(
                "opencode md5-эталон: $refMd5 (целость файла гарантируется верификацией после записи)",
            )
        }
    }

    /// Проба исполнения команды внутри proot с логом результата.
    private fun probe(name: String, cmd: String, timeoutMs: Long = 30_000): Int {
        val checkLog = File(SandboxPaths.logs(this), "proot-check.log")
        checkLog.writeText("")
        val code = try {
            manager.runOnce(cmd, checkLog, timeoutMs)
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

    /// Проба с verbose-печатью proot: различает «exited with status N» и
    /// «terminated with signal N» — без этого молчаливая смерть гостя слепа.
    private fun probeVerbose(name: String, cmd: String, timeoutMs: Long = 60_000): Int {
        val checkLog = File(SandboxPaths.logs(this), "proot-check.log")
        checkLog.writeText("")
        val code = try {
            manager.runOnce(cmd, checkLog, timeoutMs, verbose = true)
        } catch (e: IOException) {
            SandboxLogger.w("probe $name: ${e.message}")
            return -1
        }
        // VERBOSE-строки proot «vpid 1: exited with status N» — самое ценное.
        val out = HealthCheck.tail(checkLog, 400).trim().replace("\n", " | ")
        SandboxLogger.i(
            "probe $name: код $code, вывод: ${out.take(400)}",
        )
        return code
    }

    /// md5 opencode на устройстве больше не снимается пробой (md5sum на
    /// 219 МБ умирает молча под proot на этом ROM); целость гарантируется
    /// верификацией ПОСЛЕ записи на Android-стороне (RootfsInstaller).
    private fun repairAndRecheck(rootfs: File) {
        checkStop()
        setState(Phase.BOOTSTRAPPING_PACKAGES, "Ремонт: переустановка opencode и библиотек")
        SandboxLogger.w(
            "repair: opencode не исполняется ни одной пробой ($ocDirectCode/$ocLoaderCode) — " +
                "переустанавливаю бинарь" + if (pkgBootstrapDoneThisBoot) "" else " и пакеты",
        )
        val refMd5 = installer.opencodeBinaryMd5()
        // Битые файлы: бинарь и его маркер (переустановятся из манифеста);
        // libstdc++ при необходимости перепишет apt-get install --reinstall.
        File(rootfs, "usr/local/bin/opencode").delete()
        File(rootfs, "usr/local/bin/.pf-opencode-version").delete()
        installer.ensureOpencode(rootfs, force = true)
        if (!pkgBootstrapDoneThisBoot) {
            // Пакеты уже ставились в этом boot — повтор только тратит время.
            bootstrapPackages(rootfs, reinstall = true)
        }
        detectExecMode(rootfs)
        if (ocDirectCode != 0 && ocLoaderCode != 0 && serveStrategy.isEmpty()) {
            verifyToolchain(rootfs)
            throw java.io.IOException(
                "opencode не исполняется и после ремонта (direct=$ocDirectCode, loader=$ocLoaderCode, " +
                    "стратегии: прямой/loader/nojit; md5-эталон ${refMd5 ?: "?"}) — пришлите экспорт логов",
            )
        }
        SandboxLogger.i(
            "repair: opencode исполняется после переустановки " +
                "(direct=$ocDirectCode, loader=$ocLoaderCode, стратегия='${serveStrategy.trim().ifEmpty { "прямой" }}')",
        )
    }

    /// Верификация тулчейна: динамические бинари из пакетов должны стартовать —
    /// это факт целости УСТАНОВЛЕННЫХ БИБЛИОТЕК (libstdc++, libpcre2 и т.д.).
    private fun verifyToolchain(rootfs: File) {
        setState(Phase.STARTING, "Проверка инструментов песочницы")
        val rg = probe("rg", "/usr/bin/rg --version", 20_000)
        val bash = probe("bash", "/bin/bash --version", 20_000)
        val git = probe("git", "git --version", 20_000)
        val bad = mutableListOf<String>()
        if (rg != 0) bad.add("rg")
        if (bash != 0) bad.add("bash")
        if (git != 0) bad.add("git")
        if (bad.isNotEmpty()) {
            SandboxLogger.w("инструменты не стартуют: ${bad.joinToString(", ")} — библиотеки установлены битыми?")
        }
    }

    /// Установка apt-пакетов: apt-get внутри proot (с префиксом по пробам).
    /// [reinstall] — путь ремонта: --reinstall перезаписывает файлы уже
    /// установленных пакетов (apt считает их нетронутыми и иначе пропустит).
    private fun bootstrapPackages(rootfs: File, reinstall: Boolean = false) {
        if (echoCode != 0) {
            // sh внутри proot не исполняется — и serve не заведётся; fail fast.
            throw java.io.IOException(
                "proot не смог выполнить /bin/echo (код $echoCode) — проверьте экспорт логов",
            )
        }

        // apt-get --version мог быть 0, а install — умирать (в Alpine-эпоху
        // apk add умирал после успешного apk --version: реальный случай
        // 0.3.7 boot1). Решает РЕАЛЬНАЯ проба: apt-get update требует сеть
        // и запись — то же, что и install.
        val aptUpdate = probe("apt-update", "${pkgPrefix}apt-get update".trim(), 120_000)
        val pkgs = installer.packages.joinToString(" ")
        val logFile = File(SandboxPaths.logs(this), "apt.log")
        logFile.writeText("")
        if (aptUpdate == 0) {
            for (attempt in 1..2) {
                checkStop()
                setState(
                    Phase.BOOTSTRAPPING_PACKAGES,
                    "Установка: apt-get install $pkgs (попытка $attempt из 2)",
                )
                val code = manager.runOnce(
                    "DEBIAN_FRONTEND=noninteractive ${pkgPrefix}apt-get install -y" +
                        "${if (reinstall) " --reinstall" else ""} --no-install-recommends $pkgs",
                    logFile,
                    600_000,
                )
                SandboxLogger.i("apt-get install попытка $attempt: код $code")
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
        } else {
            SandboxLogger.w(
                "apt-get update не исполняется в proot (код $aptUpdate, " +
                    "direct=$aptDirectCode, loader=$aptLoaderCode) — установку не начинаю",
            )
        }
        val tail = HealthCheck.tail(logFile, 600).trim()
        throw java.io.IOException(
            "apt-установка пакетов не удалась (update=$aptUpdate); apt.log: $tail",
        )
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
