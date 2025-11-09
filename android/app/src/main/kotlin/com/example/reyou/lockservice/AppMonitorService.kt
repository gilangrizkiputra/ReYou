package com.example.reyou.lockservice

import android.app.Service
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.IBinder
import android.provider.Settings
import android.view.Gravity
import android.view.LayoutInflater
import android.view.View
import android.view.WindowManager
import android.widget.TextView
import android.widget.Toast
import com.example.reyou.R
import android.util.Log
import android.os.Handler
import android.os.Looper
import org.json.JSONObject
import org.json.JSONArray

class AppMonitorService : Service() {
    private var overlayView: View? = null
    private var currentLockedApp: String? = null
    private var lastDetectedApp: String? = null
    private var isRunning = false
    // private val lockedApps: List<String> get() = LockedAppManager.getLockedApps()

    private fun getCurrentlyLockedApp(packageName: String): JSONObject? {
        val apps = LockedAppManager.getLockedApps(this)
        val now = java.util.Calendar.getInstance()

        for (app in apps) {
            val pkg = app.getString("packageName")
            val isLocked = app.getString("isLocked").toBoolean()

            val unlockDate = app.optString("unlockDate", "")
            val unlockTime = app.optString("unlockTime", "")

            if (pkg == packageName && isLocked) {
                // Cek jam & tanggal sekarang < waktu unlock
                val nowHour = now.get(java.util.Calendar.HOUR_OF_DAY)
                val nowDate = now.get(java.util.Calendar.DAY_OF_MONTH)
                val unlockHour = unlockTime.split(".").getOrNull(0)?.toIntOrNull() ?: 24
                val unlockDateDay = unlockDate.split("/").getOrNull(0)?.toIntOrNull() ?: 0

                if (nowDate <= unlockDateDay && nowHour < unlockHour) {
                    return app
                }
            }
        }
        Log.d("AppMonitorService", "Locked apps: ${LockedAppManager.getLockedApps(this)}")

        return null
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("AppMonitorService", "✅ Service started")

        Thread {
            while (true) {
                Handler(Looper.getMainLooper()).post {
                    checkForegroundApp()
                }
                Thread.sleep(3000)
            }
        }.start()

        if (isRunning) return START_STICKY
        isRunning = true

        return START_STICKY
    }


    private fun checkForegroundApp() {
        val usageStatsManager = getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val time = System.currentTimeMillis()
        val events = usageStatsManager.queryEvents(time - 2000, time)
        val event = UsageEvents.Event()

        var lastApp: String? = null
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                lastApp = event.packageName
            }
        }

        // kalau gak ada event baru, pake app sebelumnya
        if (lastApp == null) {
            lastApp = lastDetectedApp
        } else {
            lastDetectedApp = lastApp
        }

        Log.d("AppMonitorService", "Foreground app: $lastApp")

        if (lastApp != null && getCurrentlyLockedApp(lastApp) != null) {
            if (currentLockedApp != lastApp) {
                Log.d("AppMonitorService", "🔒 App dikunci: $lastApp")
                showOverlay(lastApp)
                currentLockedApp = lastApp
            }
        } else {
            if (currentLockedApp != null) {
                removeOverlay()
                currentLockedApp = null
            }
        }
    }


    private fun showOverlay(packageName: String) {
        if (overlayView != null && overlayView?.isAttachedToWindow == true) return

        val wm = getSystemService(WINDOW_SERVICE) as WindowManager
        val inflater = getSystemService(LAYOUT_INFLATER_SERVICE) as LayoutInflater
        overlayView = inflater.inflate(R.layout.overlay_lock, null)

        overlayView?.findViewById<TextView>(R.id.lockText)?.text =
            "Aplikasi ini dikunci: $packageName"

        val params = WindowManager.LayoutParams(
            WindowManager.LayoutParams.MATCH_PARENT,
            WindowManager.LayoutParams.MATCH_PARENT,
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O)
                WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            else
                WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE or
                WindowManager.LayoutParams.FLAG_NOT_TOUCH_MODAL or
                WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
            PixelFormat.TRANSLUCENT
        )

        params.gravity = Gravity.CENTER
        wm.addView(overlayView, params)
    }

    private fun isUsageAccessGranted(): Boolean {
        try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as android.app.AppOpsManager
            val mode = appOps.checkOpNoThrow(
                "android:get_usage_stats",
                android.os.Process.myUid(),
                packageName
            )
            return mode == android.app.AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            return false
        }
    }

    private fun removeOverlay() {
         overlayView?.let {
            val wm = getSystemService(WINDOW_SERVICE) as WindowManager
            if (it.isAttachedToWindow) wm.removeView(it)
            overlayView = null
        }
    }

    private fun isLockTime(): Boolean {
        // contoh: jam 8 malam - 10 malam
        val now = java.util.Calendar.getInstance()
        val hour = now.get(java.util.Calendar.HOUR_OF_DAY)
        return hour in 20..22
    }


    override fun onBind(intent: Intent?): IBinder? = null
}
