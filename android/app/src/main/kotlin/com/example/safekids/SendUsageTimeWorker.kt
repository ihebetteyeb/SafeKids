package com.example.safekids
import android.content.Context
import android.util.Log
import androidx.work.Worker
import androidx.work.WorkerParameters
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import org.json.JSONObject

class SendUsageTimeWorker(
    context: Context,
    workerParams: WorkerParameters
) : Worker(context, workerParams) {

    override fun doWork(): Result {
        val adminDeviceToken = inputData.getString("adminDeviceToken") ?: return Result.failure()
        val usageTime = inputData.getString("usageTime") ?: return Result.failure()

        val response = sendUsageTimeToAdmin(adminDeviceToken, usageTime)
        return if (response.isSuccessful) {
            Log.d(TAG, "Usage time sent successfully")
            Result.success()
        } else {
            Log.e(TAG, "Failed to send usage time: ${response.message}")
            Result.failure()
        }
    }

    private fun sendUsageTimeToAdmin(adminDeviceToken: String, usageTime: String): okhttp3.Response {
        val json = JSONObject()
        json.put("to", adminDeviceToken)
        val data = JSONObject()
        data.put("usageTime", usageTime)
        data.put("triggerMethod", "getUsageTime")
        json.put("data", data)

        val requestBody = json.toString().toRequestBody("application/json; charset=utf-8".toMediaTypeOrNull())

        val request = Request.Builder()
            .url("https://fcm.googleapis.com/fcm/send")
            .post(requestBody)
            .addHeader("Authorization", "key=AAAAZWtXuiA:APA91bF59W1qnPQhBIi6X2ybRXgFsgkF9thBDQCo4v-sfVsr5_0f5yQwMxcmIrpC2z4iBnVeEzNtGblfMAEQ7IKCwSvfnCYs9RdyGU62xNeXlMEt3xHEw-jCgtVQ6tBMTRcRnu4D8tZR")
            .build()

        val client = OkHttpClient()
        return client.newCall(request).execute()
    }

    companion object {
        private const val TAG = "SendUsageTimeWorker"
    }
}
