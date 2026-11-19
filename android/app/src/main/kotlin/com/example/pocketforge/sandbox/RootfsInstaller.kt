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

    fun ensureRootfs(onProgress: (Long, Long) -> Unit = { _, _ -> }): File {
        val rootfs = SandboxPaths.rootfs(ctx)
        val marker = File(rootfs, ".pf-rootfs-version")
        val wanted = artifacts.getJSONObject("rootfs").getString("version")
        if (marker.exists() && marker.readText().trim() == wanted && File(rootfs, "bin").isDirectory) {
            return rootfs
        }
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

        // DNS внутри песочницы: у Android нет /etc/resolv.conf — пишем публичные
        val resolv = File(rootfs, "etc/resolv.conf")
        resolv.parentFile?.mkdirs()
        resolv.writeText("nameserver 8.8.8.8\nnameserver 1.1.1.1\noptions timeout:2 attempts:2\n")

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
}
