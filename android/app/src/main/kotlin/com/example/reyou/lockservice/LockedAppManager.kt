package com.example.reyou.lockservice

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject

object LockedAppManager {
    private const val PREF_NAME = "locked_apps_prefs"
    private const val KEY_LOCKED_APPS = "locked_apps"

    fun update(context: Context, apps: List<Map<String, String>>) {
        val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        val jsonArray = JSONArray()

        for (app in apps) {
            val json = JSONObject()
            json.put("packageName", app["packageName"])
            json.put("unlockDate", app["unlockDate"])
            json.put("unlockTime", app["unlockTime"])
            json.put("isLocked", app["isLocked"])
            jsonArray.put(json)
        }
    

        prefs.edit().putString(KEY_LOCKED_APPS, jsonArray.toString()).apply()
    }

    fun getLockedApps(context: Context): List<JSONObject> {
        val prefs = context.getSharedPreferences(PREF_NAME, Context.MODE_PRIVATE)
        val jsonString = prefs.getString(KEY_LOCKED_APPS, "[]")
        val jsonArray = JSONArray(jsonString)
        val result = mutableListOf<JSONObject>()
        for (i in 0 until jsonArray.length()) {
            result.add(jsonArray.getJSONObject(i))
        }
        return result
    }
}
