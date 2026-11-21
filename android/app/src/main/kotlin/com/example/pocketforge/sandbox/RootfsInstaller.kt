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
    val packages: List<String>
        get() = artifacts.getJSONArray("packages").let { arr ->
            (0 until arr.length()).map { arr.getString(it) }
        }

    /// Критические для запуска proot пути rootfs: без симлинка /bin/sh
    /// proot не может execve и умирает молча с кодом 255 (реальный случай
    /// на устройстве). Возвращает список отсутствующих частей.
    /// bin/sh — путь через usrmerge-симлинки Debian (/bin → /usr/bin,
    /// /usr/bin/sh → dash), поэтому проверяем резолв по существованию,
    /// не наличие записи в tar — запись bin/sh в Debian-архиве нет.
    private fun brokenRootfsParts(rootfs: File): List<String> {
        val missing = mutableListOf<String>()
        if (!File(rootfs, "bin/sh").exists()) missing += "bin/sh"
        val apt = File(rootfs, "usr/bin/apt-get")
        if (!apt.exists() || !apt.canExecute()) missing += "usr/bin/apt-get(x)"
        if (!File(rootfs, "usr/bin/dpkg").exists()) missing += "usr/bin/dpkg"
        if (!File(rootfs, "lib/ld-linux-aarch64.so.1").exists()) {
            missing += "lib/ld-linux-aarch64.so.1"
        }
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
        // скачиваем Debian-слой OCI-образа (debuerreotype, URL закреплён
        // коммитом) и проверяем sha256, как и opencode
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
            // битый бинарь жил под маркером и ронял загрузчик «symbol not found»).
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
    /// apt внутри proot не резолвит хосты («нет сети»), хотя Android-сторона
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

    /// Страховка: если в rootfs нет apt-источников (debian.sources /
    /// sources.list), apt-get update не сможет ничего скачать. Debian rootfs
    /// (debuerreotype) несёт sources.list.d/debian.sources — пишем свой
    /// список только если обоих нет; кодовое имя берём из URL rootfs.
    fun ensureRepositories(rootfs: File) {
        val builtin = File(rootfs, "etc/apt/sources.list.d/debian.sources")
        if (builtin.exists() && builtin.length() > 0) return
        val legacy = File(rootfs, "etc/apt/sources.list")
        if (legacy.exists() && legacy.length() > 0) return
        val url = artifacts.getJSONObject("rootfs").getString("url")
        val codename = Regex("/(trixie|bookworm|bullseye)/").find(url)?.groupValues?.get(1) ?: "trixie"
        val f = File(rootfs, "etc/apt/sources.list.d/pocketforge.list")
        f.parentFile?.mkdirs()
        f.writeText(
            "deb http://deb.debian.org/debian $codename main\n" +
                "deb http://deb.debian.org/debian $codename-updates main\n" +
                "deb http://deb.debian.org/debian-security $codename-security main\n",
        )
    }
}
