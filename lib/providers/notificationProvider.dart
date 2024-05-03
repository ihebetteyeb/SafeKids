import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationProvider extends ChangeNotifier {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotificationToChild(String deviceId) async {
    try {
      // Create the notification message
      RemoteMessage message = RemoteMessage(
        data: {
          'device_id': deviceId,
          // Add any additional data you want to send to the child app
        },
      );

      // Send the message
    await _firebaseMessaging.sendMessage(message);
    } catch (error) {
      // Handle any errors that occur during sending the notification
      print('Error sending notification: $error');
    }
  }
}