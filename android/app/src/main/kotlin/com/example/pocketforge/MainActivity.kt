package com.example.pocketforge

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.pocketforge.sandbox.RuntimeService
import java.io.File
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {

    /// M7 терминал: exec — блокирующая операция, выполняется вне main-thread,
    /// результат/ошибка возвращаются в UI-поток через [mainHandler].
    private val execExecutor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pocketforge/sandbox")
        RuntimeService.methodChannel = channel
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "status" -> result.success(RuntimeService.currentStateMap())
                "start" -> {
                    val intent = Intent(this, RuntimeService::class.java)
                        .setAction(RuntimeService.ACTION_START)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        startForegroundService(intent)
                    } else {
                        startService(intent)
                    }
                    result.success(null)
                }
                "stop" -> {
                    RuntimeService.stopSandbox(this)
                    result.success(null)
                }
                "reset" -> {
                    RuntimeService.resetSandbox(this)
                    result.success(null)
                }
                "exec" -> {
                    val cmd = call.argument<String>("command")
                    if (cmd.isNullOrBlank()) {
                        result.error("bad_args", "command обязателен", null)
                        return@setMethodCallHandler
                    }
                    val timeoutMs = (call.argument<Number>("timeoutMs") as? Number)?.toLong()
                        ?: 30_000L
                    execExecutor.execute {
                        try {
                            val res = RuntimeService.execInSandbox(cmd, timeoutMs)
                            mainHandler.post { result.success(res) }
                        } catch (e: Exception) {
                            mainHandler.post {
                                result.error("exec_failed", e.message ?: "ошибка exec", null)
                            }
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }

        // M6: in-app update — версия и установка APK через FileProvider.
        val updateChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "pocketforge/update")
        updateChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "version" -> result.success(appVersionName())
                "canRequestInstall" -> {
                    // M8: статус права REQUEST_INSTALL_PACKAGES для настроек.
                    result.success(packageManager.canRequestPackageInstalls())
                }
                "installApk" -> {
                    val path = call.argument<String>("path")
                    if (path.isNullOrBlank()) {
                        result.error("bad_args", "path обязателен", null)
                        return@setMethodCallHandler
                    }
                    installApk(path, result)
                }
                "openInstallPermissionSettings" -> {
                    val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
                        .setData(Uri.parse("package:$packageName"))
                    startActivity(intent)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun appVersionName(): String =
        packageManager.getPackageInfo(packageName, 0).versionName ?: "unknown"

    /// Установка APK: FileProvider URI + ACTION_VIEW (REQUEST_INSTALL_PACKAGES
    /// объявлен в манифесте; при отсутствии права открываем настройки).
    private fun installApk(path: String, result: MethodChannel.Result) {
        val file = File(path)
        if (!file.exists()) {
            result.error("not_found", "APK не найден: $path", null)
            return
        }
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O &&
            !packageManager.canRequestPackageInstalls()
        ) {
            result.success("needsPermission")
            return
        }
        val uri = FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            file,
        )
        val intent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(uri, "application/vnd.android.package-archive")
            .addFlags(
                Intent.FLAG_GRANT_READ_URI_PERMISSION or
                    Intent.FLAG_ACTIVITY_NEW_TASK,
            )
        startActivity(intent)
        result.success("launched")
    }
}
