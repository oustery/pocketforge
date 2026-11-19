package com.example.pocketforge

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.pocketforge.sandbox.RuntimeService

class MainActivity : FlutterActivity() {

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
                else -> result.notImplemented()
            }
        }
    }
}
