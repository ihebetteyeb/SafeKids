package com.example.safekids
import android.util.Log
import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.view.accessibility.AccessibilityEvent
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MyAccessibilityService : AccessibilityService() {
     override fun onCreate() {
        super.onCreate()
        Log.d("AccessibilityService", "onCreate")}
        
    private val homeButtonReceiver = object : BroadcastReceiver() {

        
        override fun onReceive(context: Context, intent: Intent?) {
            if (intent?.action == "com.example.safekids.PRESS_HOME_BUTTON") {
                Log.e("Press", "test 1 ")
                pressHomeButton()
            }
            else if (intent?.action == "com.example.safekids.GET_USAGE_TIME"){
                Log.e("Press", "test 11111111111111111111 ")
                 val usageTime = intent.getStringExtra("usageTime")
            Log.d("MyBroadcastReceiver", "Received usage time: $usageTime")

            // Send the usage time to Flutter
            // val flutterEngine = FlutterEngine(context)
            // val platformChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "com.example.safekids")
            // platformChannel.invokeMethod("navigateToChildDetail", mapOf("usageTime" to usageTime))
            NativeMethodChannel.sendUsageTime(usageTime)
            Log.d("MyBroadcastReceiver", "AFTRERRRRRRRRRRRRRRRRR")
            }
        }
    }

    override fun onServiceConnected() {
        // val info = AccessibilityServiceInfo().apply {
        //     eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED
        //     feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
        //     notificationTimeout = 100
        // }
         super.onServiceConnected()
        // serviceInfo = info
        registerReceiver(homeButtonReceiver, IntentFilter("com.example.safekids.PRESS_HOME_BUTTON"))
        registerReceiver(homeButtonReceiver, IntentFilter("com.example.safekids.GET_USAGE_TIME"))
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Handle accessibility events if needed
    }

    override fun onInterrupt() {
        // Handle interruptions
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(homeButtonReceiver)
    }

    private fun pressHomeButton() {
        val intent = Intent(Intent.ACTION_MAIN).apply {
            addCategory(Intent.CATEGORY_HOME)
            flags = Intent.FLAG_ACTIVITY_NEW_TASK
        }
        startActivity(intent)
    }

}
