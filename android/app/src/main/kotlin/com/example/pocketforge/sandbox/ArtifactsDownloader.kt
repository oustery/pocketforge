package com.example.pocketforge.sandbox

import java.io.File
import java.io.FileOutputStream
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import java.security.MessageDigest

/// Скачивание артефактов (opencode, rootfs) с докачкой и проверкой sha256.
///
/// Устойчивость на мобильных сетях: 5 попыток с паузами, докачка через
/// `.part` + Range, готовый `.part` проверяется sha256 до обращения к сети
/// (переживает перезапуск сервиса), HTTP 416 трактуется как «уже скачано».
object ArtifactsDownloader {

    class ChecksumMismatchException(message: String) : IOException(message)

    /// Не-ретраиBLE ошибка (HTTP 404/403 и т.п. — повторы бессмысленны).
    class FatalDownloadException(message: String) : IOException(message)

    fun download(
        url: String,
        dest: File,
        expectedSha256: String,
        onProgress: (bytes: Long, total: Long) -> Unit = { _, _ -> },
        shouldStop: () -> Boolean = { false },
    ): File {
        dest.parentFile?.mkdirs()
        val part = File(dest.parentFile, dest.name + ".part")

        // Готовый кеш с прошлого запуска — в дело только если он ЦЕЛ: битый
        // кеш (обрыв записи на ФС) иначе навсегда выдаёт порченый артефакт.
        if (dest.exists() && dest.length() > 0) {
            if (sha256(dest).equals(expectedSha256, ignoreCase = true)) return dest
            SandboxLogger.w("кеш $dest бит (sha256 не совпал) — перекачка")
            dest.delete()
        }

        // Полный .part с прошлого запуска — сразу в дело, без сети.
        if (isComplete(part, expectedSha256)) return promote(part, dest)

        var attempt = 0
        while (true) {
            if (shouldStop()) throw IOException("Загрузка остановлена")
            attempt++
            try {
                val code = downloadOnce(url, part, onProgress, shouldStop)
                if (code == 416) {
                    // Range за пределами файла: .part уже полного размера
                    // (прошлая попытка упала между записью и rename).
                    if (isComplete(part, expectedSha256)) return promote(part, dest)
                    part.delete()
                    throw IOException("HTTP 416 для $url: .part некорректен, начинаю заново")
                }
                val actual = sha256(part)
                if (!actual.equals(expectedSha256, ignoreCase = true)) {
                    part.delete()
                    // Несовпадение детерминировано — ретраи бессмысленны.
                    throw ChecksumMismatchException(
                        "sha256 не совпал для $url: ожидалось $expectedSha256, получено $actual",
                    )
                }
                return promote(part, dest)
            } catch (e: ChecksumMismatchException) {
                throw e
            } catch (e: FatalDownloadException) {
                throw e
            } catch (e: IOException) {
                if (shouldStop()) throw IOException("Загрузка остановлена", e)
                if (attempt >= 5) throw e
                try {
                    Thread.sleep(2000L * attempt)
                } catch (_: InterruptedException) {
                    Thread.currentThread().interrupt()
                    throw e
                }
            }
        }
    }

    /// sha256 существующего .part совпадает с ожидаемым — скачан целиком.
    private fun isComplete(part: File, expectedSha256: String): Boolean =
        part.exists() && part.length() > 0 && sha256(part).equals(expectedSha256, ignoreCase = true)

    /// Атомарная подмена .part → конечное имя.
    private fun promote(part: File, dest: File): File {
        if (dest.exists()) dest.delete()
        if (!part.renameTo(dest)) throw IOException("Не удалось переименовать $part → $dest")
        return dest
    }

    /// Возвращает HTTP-код финального ответа (200/206; 416 решает вызывающий).
    private fun downloadOnce(
        url: String,
        dest: File,
        onProgress: (Long, Long) -> Unit,
        shouldStop: () -> Boolean,
    ): Int {
        val already = if (dest.exists()) dest.length() else 0L
        val conn = URL(url).openConnection() as HttpURLConnection
        conn.connectTimeout = 30_000
        conn.readTimeout = 60_000
        conn.instanceFollowRedirects = true
        if (already > 0) conn.setRequestProperty("Range", "bytes=$already-")

        val code = conn.responseCode
        try {
            when {
                code == 206 -> resumed(conn, dest, already, onProgress, shouldStop)
                code == 200 -> fresh(conn, dest, onProgress, shouldStop)
                code == 416 -> Unit // решает вызывающий (проверка .part)
                code in 400..499 -> throw FatalDownloadException(
                    "HTTP $code для $url (не ретраится)",
                )
                else -> throw IOException("HTTP $code для $url")
            }
        } finally {
            // Раньше disconnect достигался только на 200/206/416: при
            // обрыве/фатальной ошибке keep-alive-сокеты висели до 5 ретраев.
            conn.disconnect()
        }
        return code
    }

    private fun fresh(
        conn: HttpURLConnection,
        dest: File,
        onProgress: (Long, Long) -> Unit,
        shouldStop: () -> Boolean,
    ) {
        val total = conn.contentLengthLong
        dest.outputStream().use { out ->
            conn.inputStream.use { input ->
                var written = 0L
                val buf = ByteArray(64 * 1024)
                while (true) {
                    if (shouldStop()) throw IOException("Загрузка остановлена")
                    val n = input.read(buf)
                    if (n <= 0) break
                    out.write(buf, 0, n)
                    written += n
                    if (total > 0) onProgress(written, total)
                }
                if (total > 0 && written != total) throw IOException("Обрыв: $written из $total")
            }
        }
    }

    private fun resumed(
        conn: HttpURLConnection,
        dest: File,
        already: Long,
        onProgress: (Long, Long) -> Unit,
        shouldStop: () -> Boolean,
    ) {
        val rangeTotal = conn.contentLengthLong
        val total = if (rangeTotal > 0) rangeTotal + already else -1L
        FileOutputStream(dest, true).use { out ->
            conn.inputStream.use { input ->
                var written = already
                val buf = ByteArray(64 * 1024)
                while (true) {
                    if (shouldStop()) throw IOException("Загрузка остановлена")
                    val n = input.read(buf)
                    if (n <= 0) break
                    out.write(buf, 0, n)
                    written += n
                    if (total > 0) onProgress(written, total)
                }
                // Обрыв докачки: без проверки .part уходит в sha256 и молча
                // перезакачивается с нуля (теряется смысл Range).
                if (total > 0 && written != total) {
                    throw IOException("Обрыв докачки: $written из $total")
                }
            }
        }
    }

    fun sha256(file: File): String {
        val md = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buf = ByteArray(64 * 1024)
            while (true) {
                val n = input.read(buf)
                if (n <= 0) break
                md.update(buf, 0, n)
            }
        }
        return md.digest().joinToString("") { "%02x".format(it) }
    }
}
