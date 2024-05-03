import 'package:flutter/material.dart';
import 'package:safekids/auth.dart';
import 'package:safekids/pages/app_usage.dart';
import 'package:safekids/pages/home_page.dart';
import 'package:safekids/pages/login_register_page.dart';
import 'package:flutter/services.dart';


class WidgetTree extends StatefulWidget {

  const WidgetTree({Key? key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateChanges,
    builder: (context, snapshot) {
      if(snapshot.hasData){
        return HomePage();
      }else {
        return const LoginPage();
        // return const AppUsage2();
      }
    },);
  }
}