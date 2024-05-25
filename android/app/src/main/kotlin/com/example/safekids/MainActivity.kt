package com.example.safekids

import android.app.ActivityManager
import android.content.Context
import android.content.pm.ApplicationInfo
import android.content.pm.PackageManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import android.util.Log
import android.content.Intent
import android.provider.Settings
import android.app.usage.UsageStatsManager
import android.app.AppOpsManager

import android.content.BroadcastReceiver

import android.content.IntentFilter

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safekids"


    

private fun hasUsageStatsPermission(context: Context): Boolean {
    val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
    val mode = appOps.checkOpNoThrow(
        AppOpsManager.OPSTR_GET_USAGE_STATS,
        android.os.Process.myUid(),
        context.packageName
    )
    return mode == AppOpsManager.MODE_ALLOWED
}

private fun requestUsageStatsPermission(context: Context) {
    val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
    context.startActivity(intent)
}

override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    NativeMethodChannel.configureChannel(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
        if (call.method == "checkUsageTime") {
            val context = this
            if (hasUsageStatsPermission(context)) {
                Log.d("stats", "Hello there")
                val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
                val endTime = System.currentTimeMillis()
                val beginTime = endTime - 1000 * 60 * 60 * 24 // 24 hours ago
                Log.d("stats", "Begin Time: $beginTime, End Time: $endTime")
                var totalTimeUsed = 0L
                val usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, beginTime, endTime)
                val packageManager = context.packageManager
                var youtubeUsageTime: Long? = null

                for (usageStats in usageStatsList) {
                    if (usageStats.packageName == "com.google.android.youtube") {
                        try {
                            val appName = packageManager.getApplicationLabel(packageManager.getApplicationInfo(usageStats.packageName, 0)).toString()
                            val usageTime = usageStats.totalTimeInForeground
                            Log.d("UsageStats", "App: $appName, Usage Time: $usageTime ms")
                            youtubeUsageTime = usageTime
                            break
                        } catch (e: PackageManager.NameNotFoundException) {
                            Log.e("UsageStats", "App not found for package: ${usageStats.packageName}", e)
                        }
                    }
                }
                Log.d("stats", "Usage Stats List Size: ${usageStatsList.size}")
                if (youtubeUsageTime != null) {
                    result.success(mapOf("appName" to "YouTube", "usageTime" to youtubeUsageTime.toString()))
                } else {
                    result.success(mapOf("appName" to "YouTube", "usageTime" to "0"))
                }
            } else {
                requestUsageStatsPermission(context)
                result.error("PERMISSION_DENIED", "Usage stats permission not granted", null)
            }
        } else if (call.method == "pressHomeButton") {
            Log.e("Press", "test ")
                   sendBroadcast(Intent("com.example.safekids.PRESS_HOME_BUTTON"))
                    result.success(null)
                } 
                else {
            result.notImplemented()
        }
    }
}


}
