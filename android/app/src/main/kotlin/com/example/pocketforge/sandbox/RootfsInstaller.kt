package com.example.pocketforge.sandbox

import android.content.Context
import java.io.File
import java.io.IOException
import org.json.JSONObject

/// Установка rootfs (из assets APK) и бинарника opencode (скачивание),
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

    fun ensureRootfs(): File {
        val rootfs = SandboxPaths.rootfs(ctx)
        val marker = File(rootfs, ".pf-rootfs-version")
        val wanted = artifacts.getJSONObject("rootfs").getString("version")
        if (marker.exists() && marker.readText().trim() == wanted && File(rootfs, "bin").isDirectory) {
            return rootfs
        }
        // распаковка с нуля (частичная установка недопустима)
        rootfs.deleteRecursively()
        rootfs.mkdirs()
        val asset = artifacts.getJSONObject("rootfs").getString("asset")
        val expected = artifacts.getJSONObject("rootfs").getString("sha256")
        val tmp = File(SandboxPaths.artifacts(ctx), "rootfs-verify.tar.gz")
        copyAssetWithSha(asset, tmp, expected)
        TarExtractor.extract(tmp, rootfs)
        tmp.delete()

        // DNS внутри песочницы: у Android нет /etc/resolv.conf — пишем публичные
        val resolv = File(rootfs, "etc/resolv.conf")
        resolv.parentFile?.mkdirs()
        resolv.writeText("nameserver 8.8.8.8\nnameserver 1.1.1.1\noptions timeout:2 attempts:2\n")

        marker.writeText(wanted)
        return rootfs
    }

    fun ensureOpencode(rootfs: File): File {
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

    private fun copyAssetWithSha(assetPath: String, dest: File, expectedSha256: String) {
        val md = java.security.MessageDigest.getInstance("SHA-256")
        val stream = try {
            ctx.assets.open(assetPath)
        } catch (e: IOException) {
            throw IOException("Ассет '$assetPath' не найден в assets APK", e)
        }
        stream.use { input ->
            dest.outputStream().use { out ->
                val buf = ByteArray(64 * 1024)
                while (true) {
                    val n = input.read(buf)
                    if (n <= 0) break
                    out.write(buf, 0, n)
                    md.update(buf, 0, n)
                }
            }
        }
        val actual = md.digest().joinToString("") { "%02x".format(it) }
        if (!actual.equals(expectedSha256, ignoreCase = true)) {
            dest.delete()
            throw ArtifactsDownloader.ChecksumMismatchException(
                "rootfs: ожидалось $expectedSha256, получено $actual",
            )
        }
    }
}
