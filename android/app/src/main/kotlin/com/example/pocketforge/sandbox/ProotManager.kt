package com.example.pocketforge.sandbox

import android.content.Context
import android.util.Log
import java.io.File
import java.io.IOException
import java.util.concurrent.atomic.AtomicReference

/// Запуск/остановка proot-процесса с opencode serve внутри.
class ProotManager(private val ctx: Context) {

    private val processRef = AtomicReference<Process?>(null)

    var port: Int = 0
        private set
    var password: String = ""
        private set

    fun isAlive(): Boolean = processRef.get()?.isAlive == true

    /// [muslPrefix] — префикс команды: если на устройстве прямой exec
    /// динамических бинарей под proot молча умирает (код 255, вывод пуст —
    /// см. boot.log preflight), а явный запуск через ld-musl работает,
    /// передаётся «/lib/ld-musl-aarch64.so.1 » — другой execve-путь.
    fun startServe(logFile: File, muslPrefix: String = "") {
        val rootfs = SandboxPaths.rootfs(ctx)
        val workspace = SandboxPaths.workspace(ctx)
        workspace.mkdirs()
        port = SandboxSecurity.freePort()
        password = SandboxSecurity.randomPassword()

        val proot = File(ctx.applicationInfo.nativeLibraryDir, "libproot.so")
        if (!proot.exists()) throw IOException("libproot.so не найден в nativeLibraryDir")

        val args = mutableListOf(
            proot.absolutePath,
            "-r", rootfs.absolutePath,
            "-b", "/proc",
            "-b", "/dev",
            "-b", "${workspace.absolutePath}:/root/workspace",
            "-0",
            "-w", "/root",
            "/bin/sh", "-c",
            // pf-serve-boot в логе ДОКАЗЫВАЕТ, что sh внутри proot выполнился:
            // пустой serve.log после смерти proot неотличим от «sh не стартовал».
            "echo pf-serve-boot && cd /root && exec ${muslPrefix}/usr/local/bin/opencode " +
                "serve --port $port --print-logs --log-level INFO",
        )

        logFile.parentFile?.mkdirs()
        if (logFile.exists()) logFile.writeText("") // свежий лог на каждый старт

        val pb = ProcessBuilder(args).apply {
            redirectErrorStream(true)
            redirectOutput(ProcessBuilder.Redirect.appendTo(logFile))
            environment().apply {
                put("PROOT_NO_SECCOMP", "1")
                put("PROOT_TMP_DIR", SandboxPaths.prootTmp(ctx).absolutePath)
                put("TMPDIR", "/tmp")
                put("HOME", "/root")
                put("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
                put("SHELL", "/bin/sh")
                put("LANG", "C.UTF-8")
                put("OPENCODE_SERVER_PASSWORD", password)
            }
        }
        val p = pb.start()
        processRef.set(p)
        Log.i(TAG, "proot запущен, порт=$port")
    }

    /// Разовая команда внутри песочницы (bootstrap apk-пакетов, preflight).
    /// [timeoutMs] обязателен: без него зависший apk (мертвая сеть) вечно
    /// держал бы boot-фазу — watchdog на не-READY не работает.
    fun runOnce(shellCommand: String, logFile: File, timeoutMs: Long = 600_000L): Int {
        val rootfs = SandboxPaths.rootfs(ctx)
        val proot = File(ctx.applicationInfo.nativeLibraryDir, "libproot.so")
        val args = mutableListOf(
            proot.absolutePath,
            "-r", rootfs.absolutePath,
            "-b", "/proc",
            "-b", "/dev",
            "-b", "${SandboxPaths.workspace(ctx).absolutePath}:/root/workspace",
            "-0",
            "-w", "/root",
            "/bin/sh", "-c", shellCommand,
        )
        logFile.parentFile?.mkdirs()
        val pb = ProcessBuilder(args).apply {
            redirectErrorStream(true)
            redirectOutput(ProcessBuilder.Redirect.appendTo(logFile))
            environment().apply {
                put("PROOT_NO_SECCOMP", "1")
                put("PROOT_TMP_DIR", SandboxPaths.prootTmp(ctx).absolutePath)
                put("HOME", "/root")
                put("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
                put("LANG", "C.UTF-8")
            }
        }
        val p = pb.start()
        val finished = p.waitFor(timeoutMs, java.util.concurrent.TimeUnit.MILLISECONDS)
        if (!finished) {
            p.destroyForcibly()
            throw IOException(
                "Команда не завершилась за $timeoutMs мс и была убита: $shellCommand",
            )
        }
        return p.exitValue()
    }

    /// Разовая команда с захватом stdout/stderr по отдельности (M7 терминал).
    /// Возвращает map для MethodChannel: code/stdout/stderr.
    /// Бросает [IOException] по таймауту (процесс убивается принудительно).
    fun exec(shellCommand: String, timeoutMs: Long = 30_000L): Map<String, Any?> {
        val rootfs = SandboxPaths.rootfs(ctx)
        val proot = File(ctx.applicationInfo.nativeLibraryDir, "libproot.so")
        val args = mutableListOf(
            proot.absolutePath,
            "-r", rootfs.absolutePath,
            "-b", "/proc",
            "-b", "/dev",
            "-b", "${SandboxPaths.workspace(ctx).absolutePath}:/root/workspace",
            "-0",
            "-w", "/root",
            "/bin/sh", "-c", shellCommand,
        )
        val pb = ProcessBuilder(args).apply {
            redirectErrorStream(false)
            environment().apply {
                put("PROOT_NO_SECCOMP", "1")
                put("PROOT_TMP_DIR", SandboxPaths.prootTmp(ctx).absolutePath)
                put("HOME", "/root")
                put("PATH", "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin")
                put("SHELL", "/bin/sh")
                put("LANG", "C.UTF-8")
            }
        }
        val p = pb.start()
        val stdout = StringBuilder()
        val stderr = StringBuilder()
        val tOut = Thread {
            p.inputStream.use { r ->
                r.bufferedReader().forEachLine { stdout.appendLine(it) }
            }
        }
        val tErr = Thread {
            p.errorStream.use { r ->
                r.bufferedReader().forEachLine { stderr.appendLine(it) }
            }
        }
        tOut.start()
        tErr.start()
        val finished = p.waitFor(timeoutMs, java.util.concurrent.TimeUnit.MILLISECONDS)
        if (!finished) {
            p.destroyForcibly()
            throw IOException("Таймаут команды ($timeoutMs мс)")
        }
        tOut.join(1_000)
        tErr.join(1_000)
        return mapOf(
            "code" to p.exitValue(),
            "stdout" to stdout.toString(),
            "stderr" to stderr.toString(),
        )
    }

    fun stop() {
        val p = processRef.getAndSet(null) ?: return
        try {
            p.destroy()
            if (!p.waitFor(5, java.util.concurrent.TimeUnit.SECONDS)) {
                p.destroyForcibly()
                p.waitFor(3, java.util.concurrent.TimeUnit.SECONDS)
            }
        } catch (_: InterruptedException) {
            Thread.currentThread().interrupt()
            p.destroyForcibly()
        }
        Log.i(TAG, "proot остановлен")
    }

    companion object {
        private const val TAG = "PocketForge.Proot"
    }
}

/// Healthcheck: GET /api/health с Basic-паролем (200) / без него (401).
object HealthCheck {

    fun check(port: Int, password: String): Int {
        val url = java.net.URL("http://127.0.0.1:$port/api/health")
        val conn = url.openConnection() as java.net.HttpURLConnection
        try {
            conn.connectTimeout = 3_000
            conn.readTimeout = 5_000
            val raw = "opencode:$password".toByteArray(Charsets.UTF_8)
            conn.setRequestProperty(
                "Authorization",
                "Basic " + android.util.Base64.encodeToString(raw, android.util.Base64.NO_WRAP),
            )
            return conn.responseCode
        } finally {
            conn.disconnect()
        }
    }

    fun tail(file: File, maxBytes: Int = 8192): String {
        if (!file.exists()) return ""
        return try {
            val raf = java.io.RandomAccessFile(file, "r")
            val len = raf.length().toInt()
            val start = if (len <= maxBytes) 0 else len - maxBytes
            raf.seek(start.toLong())
            val buf = ByteArray(len - start)
            raf.readFully(buf)
            raf.close()
            String(buf, Charsets.UTF_8)
        } catch (_: IOException) {
            ""
        }
    }
}
