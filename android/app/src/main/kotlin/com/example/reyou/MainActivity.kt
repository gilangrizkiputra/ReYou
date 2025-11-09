package com.example.reyou

import android.content.Intent
import android.os.Bundle
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.example.reyou.lockservice.AppMonitorService
import com.example.reyou.lockservice.LockedAppManager

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app_lock_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "openOverlaySettings" -> {
                        val intent = Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(null)
                    }
                    "openUsageAccessSettings" -> {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(null)
                    }
                    "startService" -> {
                        val intent = Intent(this, AppMonitorService::class.java)
                        startService(intent)
                        result.success(null)
                    }
                    "updateLockedApps" -> {
                        val list = call.arguments as ArrayList<HashMap<String, String>>
                        LockedAppManager.update(applicationContext, list)
                        result.success(null)
                    }
                    "stopService" -> {
                        val intent = Intent(this, AppMonitorService::class.java)
                        stopService(intent)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }
}
