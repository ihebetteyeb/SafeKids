package com.example.safekids


import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

object NativeMethodChannel {
    private const val CHANNEL_NAME = "com.example.safekids"
    private lateinit var methodChannel: MethodChannel

    fun configureChannel(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME)
    }


    fun sendUsageTime(usageTime: String?) {
        methodChannel.invokeMethod("navigateToChildDetail", mapOf("usageTime" to usageTime))
    }
}