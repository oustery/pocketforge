package com.example.pocketforge.sandbox

import android.content.Context
import android.util.Log
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

/// Единый журнал загрузки песочницы (logs/boot.log) с таймштампами.
///
/// Мотивация: разрозненные логи (apt.log, serve.log, proot-check.log) не
/// отвечали на вопрос «на каком именно шаге и почему упал запуск» — на
/// устройстве три раза подряд получали одну и ту же ошибку без деталей.
/// Теперь каждый шаг boot пишется в boot.log, при ошибке в карточку идёт
/// его хвост, а кнопка «Экспорт логов» (settings) шарит все файлы разом.
object SandboxLogger {

    private const val TAG = "PocketForge.Boot"
    private const val MAX_BYTES = 512 * 1024

    @Volatile
    private var logFile: File? = null
    private val fmt = SimpleDateFormat("MM-dd HH:mm:ss.SSS", Locale.US)

    fun init(ctx: Context) {
        val dir = SandboxPaths.logs(ctx)
        dir.mkdirs()
        logFile = File(dir, "boot.log")
    }

    fun i(msg: String) = write("INFO", msg)

    fun w(msg: String) = write("WARN", msg)

    fun e(msg: String, err: Throwable? = null) {
        write("ERROR", msg + (err?.let { ": ${it.javaClass.simpleName}: ${it.message}" } ?: ""))
        Log.e(TAG, msg, err)
    }

    private fun write(level: String, msg: String) {
        val f = logFile ?: return
        try {
            synchronized(this) {
                // Ротация: журнал не должен расти бесконечно (2 половины).
                if (f.exists() && f.length() > MAX_BYTES) {
                    val half = File(f.parentFile, "boot.log.1")
                    f.copyTo(half, overwrite = true)
                    f.writeText("")
                }
                FileOutputStream(f, true).use { out ->
                    out.write("${fmt.format(Date())} [$level] $msg\n".toByteArray())
                }
            }
        } catch (_: Exception) {
            // логирование не должно ломать запуск
        }
    }

    /// Хвост журнала для карточки ошибки / панели лога.
    fun tail(maxBytes: Int = 4096): String = logFile?.let { HealthCheck.tail(it, maxBytes) } ?: ""
}
