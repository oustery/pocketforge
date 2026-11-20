package com.example.pocketforge.sandbox

import android.content.Context
import android.util.Base64
import java.io.File
import java.net.ServerSocket
import java.security.SecureRandom

/// Пути песочницы — всё внутри приватного хранилища приложения.
object SandboxPaths {
    fun root(ctx: Context): File = File(ctx.filesDir, "sandbox")
    fun rootfs(ctx: Context): File = File(root(ctx), "rootfs")
    fun workspace(ctx: Context): File = File(root(ctx), "workspace")
    fun artifacts(ctx: Context): File = File(root(ctx), "artifacts")
    fun logs(ctx: Context): File = File(root(ctx), "logs")
    fun prootTmp(ctx: Context): File = File(ctx.cacheDir, "proot-tmp")

    fun ensureAll(ctx: Context) {
        listOf(
            root(ctx), rootfs(ctx), workspace(ctx),
            artifacts(ctx), logs(ctx), prootTmp(ctx),
        ).forEach { it.mkdirs() }
    }

    /// Полный сброс: rootfs, workspace, скачанные артефакты.
    fun wipe(ctx: Context) {
        root(ctx).deleteRecursively()
        prootTmp(ctx).deleteRecursively()
    }
}

/// Пароль сервера (128 бит, base64url без паддинга) и свободный порт.
object SandboxSecurity {
    private val random = SecureRandom()

    fun randomPassword(): String {
        val bytes = ByteArray(16)
        random.nextBytes(bytes)
        return Base64.encodeToString(bytes, Base64.NO_WRAP or Base64.NO_PADDING or Base64.URL_SAFE)
    }

    fun freePort(): Int {
        repeat(32) {
            val candidate = 20000 + random.nextInt(20000)
            try {
                ServerSocket(candidate, 1, java.net.InetAddress.getByName("127.0.0.1")).use {
                    return candidate
                }
            } catch (_: Exception) {
                // порт занят — пробуем следующий
            }
        }
        throw IllegalStateException("Не удалось найти свободный порт в диапазоне 20000-40000")
    }
}
