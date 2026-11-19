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

    fun ensureRootfs(onProgress: (Long, Long) -> Unit = { _, _ -> }): File {
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

    fun ensureOpencode(rootfs: File, onProgress: (Long, Long) -> Unit = { _, _ -> }): File {
        val oc = artifacts.getJSONObject("opencode")
        val marker = File(rootfs, "usr/local/bin/.pf-opencode-version")
        val binary = File(rootfs, oc.getString("installPath").removePrefix("/"))
        if (marker.exists() && marker.readText().trim() == oc.getString("version") && binary.exists()) {
            return binary
        }
        val tar = ArtifactsDownloader.download(
            url = oc.getString("url"),
            dest = File(SandboxPaths.artifacts(ctx), "opencode-${oc.getString("version")}-arm64.tar.gz"),
            expectedSha256 = oc.getString("sha256"),
            onProgress = onProgress,
        )
        TarExtractor.extract(tar, SandboxPaths.artifacts(ctx))
        // tar содержит ./opencode
        val extracted = File(SandboxPaths.artifacts(ctx), oc.getString("tarEntry"))
        if (!extracted.exists()) throw IOException("opencode не найден в архиве")
        binary.parentFile?.mkdirs()
        extracted.copyTo(binary, overwrite = true)
        binary.setExecutable(true, false)
        extracted.delete()
        marker.writeText(oc.getString("version"))
        return binary
    }

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
