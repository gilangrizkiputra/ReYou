package com.example.reyou.lockservice

import android.accessibilityservice.AccessibilityService
import android.content.Intent
import android.view.accessibility.AccessibilityEvent
import com.example.reyou.LockScreenActivity

class AppLockService : AccessibilityService() {
    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType == AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) {
            val packageName = event.packageName?.toString() ?: return

            if (packageName == "com.whatsapp") {
                val lockIntent = Intent(this, LockScreenActivity::class.java)
                lockIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(lockIntent)
            }
        }
    }

    override fun onInterrupt() {}
}
