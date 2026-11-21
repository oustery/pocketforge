package com.example.pocketforge.sandbox

import android.util.Log
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.nio.file.Files
import java.nio.file.Paths
import java.util.zip.GZIPInputStream

/**
 * Минимальный распаковщик tar.gz для rootfs/opencode.
 *
 * Формат gzip — и для opencode, и для Debian rootfs: OCI-слой
 * debuerreotype распространяется как tar.gz, xz не используется.
 *
 * Два прохода по архиву: (1) каталоги и регулярные файлы, (2) симлинки и
 * хардлинки — цели ссылок гарантированно уже на диске.
 *
 * Симлинк — критический элемент rootfs: /bin/sh (через usrmerge-симлинки
 * Debian /bin → /usr/bin → dash) без ссылок не резолвится, proot не может
 * execve и умирает молча с кодом 255 (реальный случай на устройстве:
 * apt.log пуст, «завершение с кодом 255»). Поэтому ссылка создаётся любой
 * ценой: symlink → hardlink → копия цели. Молчаливых пропусков нет: каждая
 * неудача попадает в лог, критические отсутствия ловит RootfsInstaller.
 */
object TarExtractor {

    private const val TAG = "PocketForge.Tar"

    fun extract(tarGz: File, destDir: File): File {
        val issues = mutableListOf<String>()
        var fallbacks = 0
        destDir.mkdirs()
        pass(tarGz, destDir, linksToo = false, issues, { fallbacks++ })
        pass(tarGz, destDir, linksToo = true, issues, { fallbacks++ })
        if (fallbacks > 0) Log.i(TAG, "ссылок создано заменами (hardlink/копия): $fallbacks")
        if (issues.isNotEmpty()) Log.w(TAG, "проблемы распаковки: $issues")
        return destDir
    }

    private fun pass(
        tarGz: File,
        destDir: File,
        linksToo: Boolean,
        issues: MutableList<String>,
        onFallback: () -> Unit,
    ) {
        FileInputStream(tarGz).use { fin ->
            GZIPInputStream(fin).use { gz ->
                val header = ByteArray(512)
                var paxPath: String? = null

                while (true) {
                    if (!readFully(gz, header)) break
                    if (header.all { it.toInt() == 0 }) break // конец архива

                    val nameField = cString(header, 0, 100)
                    val size = octal(header, 124, 12)
                    val typeflag = header[156].toInt().toChar()
                    val linkName = cString(header, 157, 100)
                    val prefix = cString(header, 345, 155)
                    val mode = octal(header, 100, 8)

                    val entryName: String
                    when (typeflag) {
                        'L' -> { // GNU longname: тело записи — путь следующего элемента
                            val buf = ByteArray(size.toInt())
                            readFully(gz, buf)
                            skipPadding(gz, size)
                            paxPath = cString(buf, 0, buf.size)
                            continue
                        }
                        'x' -> { // PAX: "длина key=value\n" — берём path
                            val buf = ByteArray(size.toInt())
                            readFully(gz, buf)
                            skipPadding(gz, size)
                            paxPath = paxValue(buf, "path") ?: paxPath
                            continue
                        }
                        'g' -> { // глобальный PAX — пропускаем
                            skip(gz, size)
                            skipPadding(gz, size)
                            continue
                        }
                        else -> {
                            entryName = (paxPath ?: if (prefix.isEmpty()) nameField else "$prefix/$nameField")
                                .trim('/')
                            paxPath = null
                        }
                    }

                    if (entryName.isEmpty()) {
                        skip(gz, size)
                        skipPadding(gz, size)
                        continue
                    }

                    val isLink = typeflag == '2' || typeflag == '1'
                    if (isLink != linksToo) {
                        skip(gz, size)
                        skipPadding(gz, size)
                        continue
                    }

                    val target = File(destDir, entryName)
                    check(target.canonicalPath.startsWith(destDir.canonicalPath + File.separator) ||
                        target.canonicalPath == destDir.canonicalPath) {
                        "tar-элемент выходит за пределы каталога: $entryName"
                    }

                    when (typeflag) {
                        '5' -> target.mkdirs()
                        '2' -> {
                            skip(gz, size)
                            createSymlinkEntry(destDir, target, linkName, entryName, issues, onFallback)
                        }
                        '1' -> {
                            skip(gz, size)
                            createHardlinkEntry(target, destDir, linkName, entryName, issues, onFallback)
                        }
                        else -> { // регулярный файл ('0' или '\0')
                            target.parentFile?.mkdirs()
                            FileOutputStream(target).use { out ->
                                var remaining = size
                                val buf = ByteArray(64 * 1024)
                                while (remaining > 0) {
                                    val chunk = gz.read(buf, 0, minOf(buf.size.toLong(), remaining).toInt())
                                    if (chunk <= 0) break
                                    out.write(buf, 0, chunk)
                                    remaining -= chunk
                                }
                                // Недочитка = битый файл в rootfs, который потом
                                // умирает МОЛЧА при exec (реальный случай на
                                // устройстве: «symbol not found» в госте). Падаем
                                // сразу с фактом вместо тихой порчи.
                                if (remaining > 0) {
                                    throw IOException(
                                        "tar: файл $entryName недочитан: " +
                                            "${size - remaining} из $size байт",
                                    )
                                }
                            }
                            if (mode and 0b000111L != 0L) target.setExecutable(true, false)
                        }
                    }
                    skipPadding(gz, size)
                }
            }
        }
    }

    /// Симлинк: сначала честный symlink, затем hardlink на цель, затем копия.
    private fun createSymlinkEntry(
        destDir: File,
        target: File,
        linkName: String,
        entryName: String,
        issues: MutableList<String>,
        onFallback: () -> Unit,
    ) {
        target.parentFile?.mkdirs()
        if (target.exists()) target.delete()

        val symlinked = runCatching {
            Files.createSymbolicLink(Paths.get(target.absolutePath), Paths.get(linkName))
        }.isSuccess
        if (symlinked) return

        val resolved = resolveTarget(destDir, target, linkName)
        if (resolved != null && runCatching {
                Files.createLink(Paths.get(target.absolutePath), Paths.get(resolved.absolutePath))
            }.isSuccess
        ) {
            Log.i(TAG, "symlink $entryName заменён hardlink → $resolved")
            onFallback()
            return
        }
        if (resolved != null && resolved.isFile) {
            if (runCatching { resolved.copyTo(target, overwrite = true) }.isSuccess) {
                Log.i(TAG, "symlink $entryName заменён копией → $resolved")
                onFallback()
                return
            }
        }
        // dir-симлинки Debian (usrmerge: bin/lib/sbin → usr/*) критичны для
        // запуска — обычный путь (symlink) их создаёт честными ссылками;
        // fallback-каталог оставляем только для устройств, где создать
        // симлинк нельзя (там brokenRootfsParts поймает отсутствие bin/sh).
        if (resolved != null && resolved.isDirectory) {
            target.mkdirs()
            Log.i(TAG, "dir-симлинк $entryName заменён каталогом → $resolved")
            onFallback()
            return
        }
        issues += "симлинк $entryName -> $linkName не создан"
    }

    /// Хардлинк: честный link, затем копия цели.
    private fun createHardlinkEntry(
        target: File,
        destDir: File,
        linkName: String,
        entryName: String,
        issues: MutableList<String>,
        onFallback: () -> Unit,
    ) {
        target.parentFile?.mkdirs()
        if (target.exists()) target.delete()

        val resolved = resolveTarget(destDir, target, linkName)
        if (resolved != null && runCatching {
                Files.createLink(Paths.get(target.absolutePath), Paths.get(resolved.absolutePath))
            }.isSuccess
        ) return
        if (resolved != null && resolved.isFile) {
            if (runCatching { resolved.copyTo(target, overwrite = true) }.isSuccess) {
                Log.i(TAG, "hardlink $entryName заменён копией → $resolved")
                onFallback()
                return
            }
        }
        issues += "хардлинк $entryName -> $linkName не создан"
    }

    /// Цель ссылки: абсолютная — от корня destDir, относительная — от каталога
    /// записи (так в rootfs лежат sh -> dash и парные библиотеки libX.so.1
    /// -> libX.so.1.N.N).
    private fun resolveTarget(destDir: File, entry: File, linkName: String): File? {
        val f = if (linkName.startsWith("/")) {
            File(destDir, linkName.drop(1))
        } else {
            File(entry.parentFile, linkName)
        }
        return f.takeIf { it.exists() }
    }

    private fun readFully(input: java.io.InputStream, buf: ByteArray): Boolean {
        var off = 0
        while (off < buf.size) {
            val n = input.read(buf, off, buf.size - off)
            if (n <= 0) return off > 0
            off += n
        }
        return true
    }

    private fun cString(buf: ByteArray, off: Int, maxLen: Int): String {
        var end = off
        val limit = minOf(off + maxLen, buf.size)
        while (end < limit && buf[end].toInt() != 0) end++
        return String(buf, off, end - off, Charsets.UTF_8)
    }

    private fun octal(buf: ByteArray, off: Int, len: Int): Long {
        val s = cString(buf, off, len).trim(' ', '\u0000')
        if (s.isEmpty()) return 0
        return if (s.startsWith("0x") || s.startsWith("0X")) {
            s.substring(2).toLong(16)
        } else {
            s.toLongOrNull(8) ?: 0
        }
    }

    private fun skip(input: java.io.InputStream, n: Long) {
        var remaining = n
        while (remaining > 0) {
            val s = input.skip(remaining)
            if (s <= 0) break
            remaining -= s
        }
    }

    private fun skipPadding(input: java.io.InputStream, size: Long) {
        val rem = size % 512
        if (rem > 0) skip(input, 512 - rem)
    }

    private fun paxValue(buf: ByteArray, key: String): String? {
        val text = String(buf, Charsets.UTF_8)
        val regex = Regex("""\d+ $key=([^\n]+)\n""")
        return regex.find(text)?.groupValues?.get(1)
    }
}
