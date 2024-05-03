import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:safekids/pushNotif.dart';
import 'package:safekids/widget_tree.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  const platform = MethodChannel('getting_youtube_usage');
  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
  // Initialize notifications using FirebaseApi
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();



  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
 

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.purple),
    home:  WidgetTree());
  }
}