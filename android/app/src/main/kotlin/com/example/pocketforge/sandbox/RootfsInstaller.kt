package com.example.pocketforge.sandbox

import android.content.Context
import java.io.File
import java.io.IOException
import org.json.JSONObject

/// Установка rootfs (скачивание по манифесту) и бинарника opencode (скачивание),
/// с проверкой sha256 по assets/artifacts.json.
class RootfsInstaller(private val ctx: Context) {

    private val artifacts: JSONObject by lazy {
        val text = try {
            ctx.assets.open("artifacts.json").bufferedReader().use { it.readText() }
        } catch (e: IOException) {
            throw IOException(
                "Манифест artifacts.json не найден в assets APK " +
                    "(должен лежать в android/app/src/main/assets)",
                e,
            )
        }
        JSONObject(text)
    }

    val opencodeVersion: String get() = artifacts.getJSONObject("opencode").getString("version")
    val rootfsVersion: String get() = artifacts.getJSONObject("rootfs").getString("version")
    val apkPackages: List<String>
        get() = artifacts.getJSONArray("apkPackages").let { arr ->
            (0 until arr.length()).map { arr.getString(it) }
        }

    /// Критические для запуска proot пути rootfs: без симлинка /bin/sh
    /// proot не может execve и умирает молча с кодом 255 (реальный случай
    /// на устройстве). Возвращает список отсутствующих частей.
    /// ВАЖНО: bin/sh — абсолютный симлинк (/bin/sh → /bin/busybox), он
    /// «битый» снаружи rootfs (резолвится к корню Android, где /bin/busybox
    /// нет), поэтому проверяем наличие ССЫЛКИ без резолва цели — иначе
    /// ensureRootfs переустанавливал бы rootfs при каждом запуске.
    private fun brokenRootfsParts(rootfs: File): List<String> {
        val missing = mutableListOf<String>()
        val sh = File(rootfs, "bin/sh")
        val shOk = try {
            java.nio.file.Files.isSymbolicLink(java.nio.file.Paths.get(sh.absolutePath)) || sh.exists()
        } catch (_: Exception) {
            sh.exists()
        }
        if (!shOk) missing += "bin/sh"
        val busybox = File(rootfs, "bin/busybox")
        if (!busybox.exists() || !busybox.canExecute()) missing += "bin/busybox(x)"
        if (!File(rootfs, "sbin/apk").exists()) missing += "sbin/apk"
        if (!File(rootfs, "lib/ld-musl-aarch64.so.1").exists()) missing += "lib/ld-musl-aarch64.so.1"
        return missing
    }

    fun ensureRootfs(
        onProgress: (Long, Long) -> Unit = { _, _ -> },
        shouldStop: () -> Boolean = { false },
    ): File {
        val rootfs = SandboxPaths.rootfs(ctx)
        val marker = File(rootfs, ".pf-rootfs-version")
        val wanted = artifacts.getJSONObject("rootfs").getString("version")
        val markerOk = marker.exists() && marker.readText().trim() == wanted && File(rootfs, "bin").isDirectory
        // Маркер — не гарантия работоспособности: rootfs, распакованный
        // старым TarExtractor без симлинков (/bin/sh отсутствует), чиним
        // переустановкой, иначе proot молча падает с кодом 255 навсегда.
        if (markerOk && brokenRootfsParts(rootfs).isEmpty()) return rootfs
        // распаковка с нуля (частичная установка недопустима)
        rootfs.deleteRecursively()
        rootfs.mkdirs()
        // rootfs не бандлим в APK (AGP ненадёжно пакует tar.gz в assets) —
        // скачиваем с Alpine CDN и проверяем sha256, как и opencode
        val rootfsCfg = artifacts.getJSONObject("rootfs")
        val tar = ArtifactsDownloader.download(
            url = rootfsCfg.getString("url"),
            dest = File(SandboxPaths.artifacts(ctx), "rootfs-$wanted.tar.gz"),
            expectedSha256 = rootfsCfg.getString("sha256"),
            onProgress = onProgress,
            shouldStop = shouldStop,
        )
        TarExtractor.extract(tar, rootfs)
        tar.delete()

        // Контроль распаковки: критические пути обязаны существовать.
        val broken = brokenRootfsParts(rootfs)
        if (broken.isNotEmpty()) {
            throw IOException(
                "rootfs распакован неполно (нет: ${broken.joinToString(", ")}) — " +
                    "нажмите «Сбросить песочницу» и «Запустить» повторно",
            )
        }

        marker.writeText(wanted)
        return rootfs
    }

    fun ensureOpencode(
        rootfs: File,
        onProgress: (Long, Long) -> Unit = { _, _ -> },
        shouldStop: () -> Boolean = { false },
        force: Boolean = false,
    ): File {
        val oc = artifacts.getJSONObject("opencode")
        val marker = File(rootfs, "usr/local/bin/.pf-opencode-version")
        val binary = File(rootfs, oc.getString("installPath").removePrefix("/"))
        if (!force && marker.exists() && marker.readText().trim() == oc.getString("version") && binary.exists()) {
            // Верифицируем и кешированный по маркеру файл: обрыв записи в
            // прошлом boot иначе переживает все проверки (реальный случай 0.3.8:
            // битый бинарь жил под маркером и ронял ld-musl «symbol not found»).
            val wantMd5 = oc.getJSONObject("binary").optString("md5", "")
            if (wantMd5.isEmpty() || md5(binary).equals(wantMd5, ignoreCase = true)) {
                return binary
            }
            SandboxLogger.w("opencode из прошлого boot бит (md5 не совпал) — переустановка")
        }
        val tar = ArtifactsDownloader.download(
            url = oc.getString("url"),
            dest = File(SandboxPaths.artifacts(ctx), "opencode-${oc.getString("version")}-arm64.tar.gz"),
            expectedSha256 = oc.getString("sha256"),
            onProgress = onProgress,
            shouldStop = shouldStop,
        )
        TarExtractor.extract(tar, SandboxPaths.artifacts(ctx))
        // tar содержит ./opencode
        val extracted = File(SandboxPaths.artifacts(ctx), oc.getString("tarEntry"))
        if (!extracted.exists()) throw IOException("opencode не найден в архиве")
        // Верификация распакованного бинаря против эталона из манифеста:
        // tar.gz скачан с sha256-проверкой, значит внутри цел; порча возможна
        // при записи файла на ФС — она проявлялась как молчаливый отказ exec
        // («Error relocating … symbol not found») много позже точки ошибки.
        val wantMd5 = oc.getJSONObject("binary").optString("md5", "")
        val wantSize = oc.getJSONObject("binary").optLong("size", 0L)
        val gotMd5 = md5(extracted)
        if (wantMd5.isNotEmpty() && !gotMd5.equals(wantMd5, ignoreCase = true)) {
            extracted.delete()
            throw IOException(
                "md5 распакованного opencode не совпал: $gotMd5 вместо $wantMd5 " +
                    "(размер ${extracted.length()}); артефакт удалён — нужна перекачка",
            )
        }
        if (wantSize > 0L && extracted.length() != wantSize) {
            extracted.delete()
            throw IOException(
                "размер распакованного opencode ${extracted.length()} вместо $wantSize",
            )
        }
        binary.parentFile?.mkdirs()
        binary.delete() // существующий файл мог быть битым — пишем заново
        extracted.copyTo(binary, overwrite = true)
        val installedMd5 = md5(binary)
        if (wantMd5.isNotEmpty() && !installedMd5.equals(wantMd5, ignoreCase = true)) {
            binary.delete()
            marker.delete()
            throw IOException(
                "md5 opencode ПОСЛЕ записи на ФС не совпал: $installedMd5 вместо $wantMd5 " +
                    "(до записи было $gotMd5) — носитель портит файл",
            )
        }
        binary.setExecutable(true, false)
        extracted.delete()
        marker.writeText(oc.getString("version"))
        return binary
    }

    private fun md5(file: File): String {
        val md = java.security.MessageDigest.getInstance("MD5")
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

    /// Эталонный md5 opencode-бинаря из манифеста (для сверки с устройством).
    fun opencodeBinaryMd5(): String? =
        artifacts.getJSONObject("opencode").getJSONObject("binary").optString("md5")
            .takeIf { it.isNotEmpty() }

    /// DNS внутри песочницы. Android не предоставляет /etc/resolv.conf, а
    /// публичные резолверы (8.8.8.8/1.1.1.1) операторы часто блокируют — тогда
    /// apk внутри proot не резолвит хосты («нет сети»), хотя Android-сторона
    /// качается нормально: системный резолвер ходит через DNS оператора.
    /// Поэтому сначала DNS оператора (LinkProperties), затем публичные фолбэки.
    /// Вызывается на каждый запуск: DNS меняется при переключении Wi-Fi/сети.
    fun writeResolvConf(rootfs: File) {
        val resolv = File(rootfs, "etc/resolv.conf")
        resolv.parentFile?.mkdirs()
        val servers = (deviceDnsServers() + listOf("8.8.8.8", "1.1.1.1", "9.9.9.9"))
            .distinct()
            .take(4)
        val body = servers.joinToString("\n") { "nameserver $it" }
        resolv.writeText("$body\noptions timeout:3 attempts:3\n")
    }

    /// Реальные DNS-серверы устройства (IPv4) через ConnectivityManager.
    private fun deviceDnsServers(): List<String> = try {
        val cm = ctx.getSystemService(Context.CONNECTIVITY_SERVICE)
            as android.net.ConnectivityManager
        val out = LinkedHashSet<String>()
        for (net in cm.allNetworks) {
            val lp = cm.getLinkProperties(net) ?: continue
            for (addr in lp.dnsServers) {
                val ip = addr.hostAddress ?: continue
                if (ip.contains(':')) continue // берём только IPv4-резолверы
                out.add(ip)
            }
        }
        out.toList()
    } catch (_: Exception) {
        emptyList()
    }

    /// Страховка: если в minirootfs нет /etc/apk/repositories, apk не откроет
    /// репозитории и bootstrap упадёт. Восстанавливаем по ветке из URL rootfs.
    fun ensureRepositories(rootfs: File) {
        val f = File(rootfs, "etc/apk/repositories")
        if (f.exists() && f.length() > 0) return
        val url = artifacts.getJSONObject("rootfs").getString("url")
        val branch = Regex("/alpine/(v[0-9.]+)/").find(url)?.groupValues?.get(1) ?: "v3.24"
        f.parentFile?.mkdirs()
        f.writeText(
            "https://dl-cdn.alpinelinux.org/alpine/$branch/main\n" +
                "https://dl-cdn.alpinelinux.org/alpine/$branch/community\n",
        )
    }
}
