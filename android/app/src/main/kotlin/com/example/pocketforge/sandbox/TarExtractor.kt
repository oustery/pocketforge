package com.example.pocketforge.sandbox

import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.nio.file.Files
import java.nio.file.Paths
import java.util.zip.GZIPInputStream

/**
 * Минимальный распаковщик .tar.gz для rootfs/opencode.
 * Поддерживает ustar, GNU longname ('L'), PAX-заголовки ('x'),
 * симлинки ('2') и хардлинки ('1') — ровно то, что дают tarball'ы
 * Alpine minirootfs и Go-сборки opencode.
 */
object TarExtractor {

    fun extract(tarGz: File, destDir: File): File {
        destDir.mkdirs()
        GZIPInputStream(FileInputStream(tarGz)).use { gz ->
            val header = ByteArray(512)
            var paxPath: String? = null

            while (true) {
                if (!readFully(gz, header)) break
                if (header.all { it.toInt() == 0 }) break // конец архива

                val nameField = cString(header, 0, 100)
                val size = octal(header, 124, 12)
                val typeflag = header[156].toInt().toChar()
                var linkName = cString(header, 157, 100)
                val prefix = cString(header, 345, 155)
                val mode = octal(header, 100, 8)

                val entryName: String
                var dataSize: Long = size
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
                        skip(gz, dataSize)
                        skipPadding(gz, size)
                        continue
                    }
                    else -> {
                        entryName = (paxPath ?: if (prefix.isEmpty()) nameField else "$prefix/$nameField")
                            .trim('/')
                        paxPath = null
                        linkName = paxOverrideLink ?: linkName
                        paxOverrideLink = null
                    }
                }

                if (entryName.isEmpty()) {
                    skip(gz, dataSize)
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
                        target.parentFile?.mkdirs()
                        if (target.exists()) target.delete()
                        try {
                            Files.createSymbolicLink(
                                Paths.get(target.absolutePath),
                                Paths.get(linkName),
                            )
                        } catch (_: java.io.IOException) {
                            // некоторые файловые системы не дают симлинки —
                            // оставляем пропуск, busybox-пути восстановим apk-комплектом
                        }
                        skip(gz, dataSize)
                    }
                    '1' -> {
                        target.parentFile?.mkdirs()
                        if (target.exists()) target.delete()
                        val linkTarget = File(destDir, linkName)
                        if (linkTarget.exists()) {
                            Files.createLink(Paths.get(target.absolutePath), Paths.get(linkTarget.absolutePath))
                        }
                        skip(gz, dataSize)
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
                        }
                        if (mode and 0b000111L != 0L) target.setExecutable(true, false)
                    }
                }
                skipPadding(gz, size)
            }
        }
        return destDir
    }

    private var paxOverrideLink: String? = null

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
