import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_usage/app_usage.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';

  
 Future<void> _handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('payload: ${message.data}');

  
  }


class FirebaseApi  {



    final _firebaseMessaging = FirebaseMessaging.instance; 
    
    Future<void> initNotifications() async {
      await Firebase.initializeApp(); // Ensure Firebase is initialized

  if (FirebaseMessaging.instance != null) {
    await FirebaseMessaging.instance.requestPermission();
    final FCMToken = await FirebaseMessaging.instance.getToken();
    print('Token: $FCMToken');
    FirebaseMessaging.onBackgroundMessage(_handleBackgroundMessage);
  } else {
    print('FirebaseMessaging.instance is null');
  }

    }

 



//Send Appointment Notfification To Admin
sendNotificationToAdmin() async {
  //Our API Key
  var serverKey = "AAAAZWtXuiA:APA91bF59W1qnPQhBIi6X2ybRXgFsgkF9thBDQCo4v-sfVsr5_0f5yQwMxcmIrpC2z4iBnVeEzNtGblfMAEQ7IKCwSvfnCYs9RdyGU62xNeXlMEt3xHEw-jCgtVQ6tBMTRcRnu4D8tZR";

  //Get our Admin token from Firesetore DB
  var token = "cXYxxkQySh2eGPTFGN7cei:APA91bENxJA-xHhJOT-5oDPbkR0dj3sJIb_lr1M7yolCL6M7yzf5u6cvchia0YXXYRJgMBEuZgdBq5p8yh1iKOLnwWhNFuXLAaV6B1ZQ0IlNyXu2HgTvsoidsdDK6-bpZzaHt7clP6Q3";
  

  //Create Message with Notification Payload
  String constructFCMPayload(String token) {

    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': "You have a new notif from your child",
          'title': "safekids notif",
        },
        'data': <String, dynamic>{
          'name': "test",
          
        },
        'to': token
      },
    );
  }

  if (token.isEmpty) {
    return print('Unable to send FCM message, no token exists.');
  }

  try {
    //Send  Message
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructFCMPayload(token));

    print("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    print("error push notification $e");
  }
}



sendNotificationToUser() async {
  //Our API Key
  var serverKey = "AAAAZWtXuiA:APA91bF59W1qnPQhBIi6X2ybRXgFsgkF9thBDQCo4v-sfVsr5_0f5yQwMxcmIrpC2z4iBnVeEzNtGblfMAEQ7IKCwSvfnCYs9RdyGU62xNeXlMEt3xHEw-jCgtVQ6tBMTRcRnu4D8tZR";

  // var token = "chLd5mF6SkCF5btUsw8T2k:APA91bEfk-SoZKbCmwNzVjHA3RdcHWm3SKVCUammZfX4gy_TjAzusKZh8NSZ4VxyJgc-b4lbMXcJMNLxiDtg-pXi-J1hWlhnuCbRzX9yU9yupsN5enUqriMU1Xds3st8vQTDW3-o4tPS";
  var token = "cXYxxkQySh2eGPTFGN7cei:APA91bENxJA-xHhJOT-5oDPbkR0dj3sJIb_lr1M7yolCL6M7yzf5u6cvchia0YXXYRJgMBEuZgdBq5p8yh1iKOLnwWhNFuXLAaV6B1ZQ0IlNyXu2HgTvsoidsdDK6-bpZzaHt7clP6Q3";
  
  //Create Message with Notification Payload
  String constructFCMPayload(String token) {
    return jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body':
              "Hi , Stop wasting time on youtube ",
          'title': "SafeKids",
        },
        'data': <String, dynamic>{'name': 'test'},
        'to': token
      },
    );
  }

  if (token.isEmpty) {
    return print('Unable to send FCM message, no token exists.');
  }

  try {
    //Send  Message
    http.Response response =
        await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Authorization': 'key=$serverKey',
            },
            body: constructFCMPayload(token));

    print("status: ${response.statusCode} | Message Sent Successfully!");
  } catch (e) {
    print("error push notification $e");
  }
}


}