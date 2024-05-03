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

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.safekids"

override fun configureFlutterEngine( flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
  MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
    if (call.method == "getUsage") {
        Log.d("stats", "Hello there")
        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val endTime = System.currentTimeMillis()
        val beginTime = endTime - 1000 * 60 * 60 * 24 // 24 hours ago
        Log.d("stats", "Begin Time: $beginTime, End Time: $endTime")
        var totalTimeUsed = 0L
        val usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, beginTime, endTime)
        for (usageStats in usageStatsList) {
            Log.d("UsageStats", usageStats.toString())
        }
        Log.d("stats", "Usage Stats List Size: ${usageStatsList.size}")
        // Handle the result or send it back to Flutter
        result.success("Usage stats retrieved successfully")
    } else {
        result.notImplemented()
    }
}
  }


//  private fun checkUsageTime(context: Context): Long {
//        val usageStatsManager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
//     val endTime = System.currentTimeMillis()
//     val beginTime = endTime - 1000 * 60 * 60 * 24 // 24 hours ago
//     var totalTimeUsed = 0L
//     val usageStatsList = usageStatsManager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, beginTime, endTime)

//     for (usageStats in usageStatsList) {
//         if (usageStats.packageName == "com.google.android.youtube") {
//             totalTimeUsed += usageStats.totalTimeInForeground
//             Log.d("YouTube Usage Stats", "Usage Stats: $usageStats")
//         }
//     }
//     return totalTimeUsed
//     }
// private fun requestUsageStatsPermission() {
//     val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS)
//     startActivity(intent)
// }

//   private fun getInstalledApps(): List<String> {
//         val installedApps = mutableListOf<String>()
//         val packageManager: PackageManager = packageManager
//         val packages: List<ApplicationInfo> = packageManager.getInstalledApplications(PackageManager.GET_META_DATA)
//         for (packageInfo in packages) {
//             installedApps.add(packageInfo.packageName)
//         }
//         return installedApps
//     }


//      private fun closeYoutube() {
//         val activityManager = getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
//         val packageManager: PackageManager = packageManager
//  val runningProcesses = activityManager.runningAppProcesses

// for (processInfo in runningProcesses) {
//     Log.d("RunningProcess", "Process Name: ${processInfo.processName}")
//     // You can access other information about the process here
// }

    

//      }



     // private fun checkUsageStatsPermission(): Boolean {
//     val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
//     val mode = appOps.checkOpNoThrow(
//         AppOpsManager.OPSTR_GET_USAGE_STATS,
//         android.os.Process.myUid(), packageName
//     )
//     return mode == AppOpsManager.MODE_ALLOWED
// }
}
