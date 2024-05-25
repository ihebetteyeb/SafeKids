import 'package:flutter/material.dart';


import 'package:firebase_core/firebase_core.dart';
import 'package:safekids/pushNotif.dart';
import 'package:safekids/widget_tree.dart';
import 'firebase_options.dart';
import 'package:flutter/services.dart';
import 'package:safekids/pages/ChildDetails.dart';
import 'package:provider/provider.dart';
import 'package:safekids/providers/childrenProvider.dart'; 
import 'package:safekids/providers/child.dart'; 

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp( options: DefaultFirebaseOptions.currentPlatform);
  // Initialize notifications using FirebaseApi
  final firebaseApi = FirebaseApi();
  await firebaseApi.initNotifications();



  // Set up the MethodChannel
  const platform = MethodChannel('com.example.safekids');
  platform.setMethodCallHandler((call) async {
    if (call.method == 'navigateToChildDetail') {
      final usageTime = int.parse(call.arguments['usageTime']);
      MyApp.navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ChildDetailsScreen(
          firstName: "iheb",
          lastName: "etteyeb",
          expanded: true,
          initialUsageTime: usageTime,
        ),
      ));
    }
  });


   runApp(const MyApp());
}


class MyApp extends StatelessWidget {
 
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChildrenProvider()),
      ],
      child: MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.purple),
    navigatorKey: navigatorKey,
    home:  WidgetTree()));
  }
}