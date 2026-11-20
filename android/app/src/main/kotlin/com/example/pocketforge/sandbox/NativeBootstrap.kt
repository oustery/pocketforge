package com.example.pocketforge.sandbox

import android.content.Context
import android.util.Log
import java.io.File
import java.io.IOException
import java.net.HttpURLConnection
import java.net.URL
import java.util.zip.GZIPInputStream

/// Прямая установка apk-пакетов в rootfs БЕЗ proot (фоллбэк bootstrap).
///
/// Почему это нужно: на устройстве пользователя apk-процесс внутри proot
/// умирал молча с кодом 255 даже после починки симлинков (preflight-echo
/// проходит, apk — нет), то есть исполнение apk под proot-трассировкой на
/// некоторых ROM ломается. Этот путь скачивает пакеты через Android-стек
/// (системный DNS — без resolv.conf внутри песочницы) и распаковывает их
/// прямо в rootfs: исполнение aarch64-кода под proot для bootstrap больше
/// не требуется вообще.
///
/// Формат apk-пакета (проверен на реальных файлах v3.24): файл из ПОДРЯД
/// идущих gzip-потоков; внутри — tar-записи: контрольные (.SIGN.*, .PKGINFO,
/// .pre-*/.post-* скрипты) затем данные (usr/, bin/…). Java GZIPInputStream
/// поддерживает concatenated members, поэтому читаем tar-записи подряд и
/// пропускаем контрольные по именам.
class NativeBootstrap(
    private val ctx: Context,
    private val onProgress: (String, Long, Long) -> Unit = { _, _, _ -> },
) {

    class Pkg(
        val name: String,
        val version: String,
        val size: Long,
        val repo: String,
        val depends: List<String>,
        val provides: List<String>,
    )

    private val cacheDir: File
        get() = File(SandboxPaths.artifacts(ctx), "apkcache")

    /// Устанавливает [packages] (с транзитивными зависимостями) в [rootfs].
    fun bootstrapPackages(rootfs: File, packages: List<String>) {
        val branch = apkBranch()
        cacheDir.mkdirs()
        val index = loadIndex(branch)
        val resolved = resolveAll(index, packages)
        SandboxLogger.i(
            "native bootstrap: резолв ${packages} → ${resolved.size} пакетов",
        )
        var done = 0L
        var total = 0L
        for (p in resolved) total += p.size
        for (p in resolved) {
            installPkg(p, rootfs)
            done += p.size
            onProgress("${p.name}-${p.version}", done, total)
        }
        SandboxLogger.i("native bootstrap: установлено ${resolved.size} пакетов")
    }

    /// Ветку Alpine берём из URL rootfs в манифесте (/alpine/v3.24/releases/…).
    private fun apkBranch(): String {
        val url = try {
            val text = ctx.assets.open("artifacts.json").bufferedReader().use { it.readText() }
            Regex("""alpine/(v[^/]+)/""").find(text)?.groupValues?.get(1)
        } catch (_: Exception) {
            null
        }
        return url ?: "v3.24"
    }

    private fun loadIndex(branch: String): List<Pkg> {
        val byName = LinkedHashMap<String, Pkg>()
        for (repo in listOf("main", "community")) {
            val url = "$CDN/$branch/$repo/aarch64/APKINDEX.tar.gz"
            val raw = download(url, "APKINDEX-$repo.tar.gz", expectedSize = -1)
            val count = TarExtractor.parseApkIndex(raw) { name, version, size, depends, provides ->
                // main имеет приоритет: первая встреченная запись выигрывает
                byName.getOrPut(name) { Pkg(name, version, size, repo, depends, provides) }
            }
            SandboxLogger.i(
                "APKINDEX $repo: $count пакетов, уникальных всего ${byName.size}",
            )
        }
        return byName.values.toList()
    }

    /// BFS по зависимостям: имя → пакет; so:/cmd:-зависимости — по provides.
    private fun resolveAll(index: List<Pkg>, seed: List<String>): List<Pkg> {
        val byName = index.associateBy { it.name }
        val providers = HashMap<String, MutableList<Pkg>>()
        for (p in index) {
            for (pv in p.provides) {
                providers.getOrPut(pv.substringBefore('=')) { mutableListOf() }.add(p)
            }
        }
        val chosen = LinkedHashMap<String, Pkg>()
        val queue = ArrayDeque<String>()
        queue.addAll(seed)
        var skipped = 0
        while (queue.isNotEmpty()) {
            val dep = queue.removeFirst()
            if (dep == "-" || dep.startsWith("/")) {
                // '-' = нет зависимостей; '/bin/sh' и пути предоставляет busybox
                skipped++
                continue
            }
            val name = dep.substringBefore('=')
            val pkg = byName[name] ?: providers[name]?.minByOrNull { it.name }
            if (pkg == null) {
                SandboxLogger.w("native bootstrap: зависимость $dep не найдена — пропуск")
                skipped++
                continue
            }
            if (chosen.containsKey(pkg.name)) continue
            chosen[pkg.name] = pkg
            queue.addAll(pkg.depends)
        }
        SandboxLogger.i("native bootstrap: пропущено зависимостей: $skipped")
        return chosen.values.toList()
    }

    private fun installPkg(pkg: Pkg, rootfs: File) {
        val fileName = "${pkg.name}-${pkg.version}.apk"
        val apk = download("$CDN/${apkBranch()}/${pkg.repo}/aarch64/$fileName", fileName, pkg.size)
        TarExtractor.extractApkSections(apk, rootfs)
        Log.i(TAG, "установлен пакет $fileName")
    }

    /// Скачивание с кешем и 5 попытками; целостность: размер (S:) + TLS.
    private fun download(url: String, fileName: String, expectedSize: Long): File {
        val dest = File(cacheDir, fileName)
        if (dest.exists() && (expectedSize < 0 || dest.length() == expectedSize)) {
            return dest // готовый кеш с прошлой установки
        }
        var attempt = 0
        while (true) {
            attempt++
            try {
                val part = File(cacheDir, "$fileName.part")
                val conn = URL(url).openConnection() as HttpURLConnection
                conn.connectTimeout = 30_000
                conn.readTimeout = 60_000
                conn.instanceFollowRedirects = true
                if (part.exists() && part.length() > 0) {
                    conn.setRequestProperty("Range", "bytes=${part.length()}-")
                }
                val code = conn.responseCode
                when (code) {
                    206 -> conn.inputStream.use { input ->
                        java.io.FileOutputStream(part, true).use { out ->
                            input.copyTo(out, 64 * 1024)
                        }
                    }
                    200 -> {
                        part.delete()
                        conn.inputStream.use { input ->
                            part.outputStream().use { out ->
                                input.copyTo(out, 64 * 1024)
                            }
                        }
                    }
                    else -> throw IOException("HTTP $code для $url")
                }
                conn.disconnect()
                if (expectedSize > 0 && part.length() != expectedSize) {
                    throw IOException(
                        "размер $fileName: ${part.length()} вместо $expectedSize (обрыв)",
                    )
                }
                if (dest.exists()) dest.delete()
                if (!part.renameTo(dest)) throw IOException("rename $part → $dest")
                return dest
            } catch (e: IOException) {
                SandboxLogger.w("download $fileName попытка $attempt: ${e.message}")
                if (attempt >= 5) throw IOException("не удалось скачать $url: ${e.message}", e)
                try {
                    Thread.sleep(2000L * attempt)
                } catch (_: InterruptedException) {
                    Thread.currentThread().interrupt()
                    throw IOException("загрузка прервана", e)
                }
            }
        }
    }

    companion object {
        private const val TAG = "PocketForge.Native"
        private const val CDN = "https://dl-cdn.alpinelinux.org/alpine"
    }
}
