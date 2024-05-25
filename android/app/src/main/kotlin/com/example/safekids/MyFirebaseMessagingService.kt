package com.example.safekids
import android.util.Log
import com.google.firebase.messaging.FirebaseMessagingService
import com.google.firebase.messaging.RemoteMessage
import android.content.Intent
import android.app.usage.UsageStatsManager
import android.app.AppOpsManager
import android.content.pm.PackageManager
import android.content.Context
import android.provider.Settings
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.workDataOf
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class MyFirebaseMessagingService : FirebaseMessagingService() {

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

    override fun onMessageReceived(remoteMessage: RemoteMessage) {
        super.onMessageReceived(remoteMessage)
        
        if (remoteMessage.data.containsKey("triggerMethod")) {
            val triggerMethod = remoteMessage.data["triggerMethod"]
            if (triggerMethod == "pressHomeButton") {
                // If the trigger method is "pressHomeButton", send a broadcast
                sendBroadcast(Intent("com.example.safekids.PRESS_HOME_BUTTON"))
                Log.d(TAG, "sending broadcast")
            } else  if (triggerMethod == "requestUsageTime") {
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
                
                if (youtubeUsageTime != null) {
                    sendUsageTimeToAdmin(youtubeUsageTime)
                    Log.d("stats", "Usage Stats this is from sending to admin }")
                    // result.success(mapOf("appName" to "YouTube", "usageTime" to youtubeUsageTime.toString()))
                } else {
                    // result.success(mapOf("appName" to "YouTube", "usageTime" to "0"))
                }
            } else {
                requestUsageStatsPermission(context)
                // result.error("PERMISSION_DENIED", "Usage stats permission not granted", null)
            }
               
            }
            else if (triggerMethod == "getUsageTime") {
                 // Extract usage time from the payload
                     Log.d("HELOOOOOOOOOOOOOO", "HELOOOOOOOOOOOOOOO")
            val usageTime = remoteMessage.data["usageTime"]
            Log.d(TAG, "Received usageTime: $usageTime")

            // Send the usage time to Flutter via MethodChannel
          val intent = Intent("com.example.safekids.GET_USAGE_TIME")
intent.putExtra("usageTime", usageTime.toString())
applicationContext.sendBroadcast(intent)

//  val intent = Intent("com.example.safekids.GET_USAGE_TIME")
//     intent.putExtra("usageTime", usageTime)
//     LocalBroadcastManager.getInstance(this).sendBroadcast(intent)

Log.d(TAG, "Broadcast sent with usage time: $usageTime")
            }
        }


          
        // Handle the incoming message here
        Log.d(TAG, "Message data payload: ${remoteMessage.data}")
        
        // You can access notification data as well
        remoteMessage.notification?.let {
            Log.d(TAG, "Message Notification Body: ${it.body}")
        }
    }

    override fun onNewToken(token: String) {
        super.onNewToken(token)
        // Handle token refresh if needed
        Log.d(TAG, "Refreshed token: $token")
    }

    companion object {
        private const val TAG = "MyFirebaseMessagingService"
    }


  private fun sendUsageTimeToAdmin(usageTime: Long) {
        val data = workDataOf(
            "adminDeviceToken" to "chLd5mF6SkCF5btUsw8T2k:APA91bEfk-SoZKbCmwNzVjHA3RdcHWm3SKVCUammZfX4gy_TjAzusKZh8NSZ4VxyJgc-b4lbMXcJMNLxiDtg-pXi-J1hWlhnuCbRzX9yU9yupsN5enUqriMU1Xds3st8vQTDW3-o4tPS",
            "usageTime" to usageTime.toString()
        )

        val sendWorkRequest = OneTimeWorkRequestBuilder<SendUsageTimeWorker>()
            .setInputData(data)
            .build()

        WorkManager.getInstance(applicationContext).enqueue(sendWorkRequest)
    }
}
