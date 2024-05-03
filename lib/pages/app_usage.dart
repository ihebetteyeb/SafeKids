import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:app_usage/app_usage.dart';
import 'dart:async';
import 'package:flutter/services.dart';


class AppUsage2 extends StatefulWidget {
  const AppUsage2({super.key});

  @override
  State<AppUsage2> createState() => _AppUsage2State();
}

class _AppUsage2State extends State<AppUsage2> {

   List<AppUsageInfo> _infos = [];
  static const platform = MethodChannel("com.example.safekids");

List<String> _installedApps = [];




  @override
  void initState() {
    super.initState();
   
  }



Future<int> _closeYoutube() async {

  try {
      final int usageTime = await platform.invokeMethod("getUsage");
      // print(usageTime);
      return usageTime;
    } on PlatformException catch (e) {
      print('Error getting usage time: ${e.message}');
      return -1; // Or any default value
    }
  }




Future<void> _getInstalledApps() async {
    List<String> installedApps;
    try {
      final List<dynamic> result = await platform.invokeMethod('getInstalledApps');
      installedApps = result.cast<String>();
      print(installedApps);
    } on PlatformException catch (e) {
      print("Failed to get installed apps: '${e.message}'.");
      installedApps = [];
    }

    setState(() {
      _installedApps = installedApps;
    });
  }




  void getUsageStats() async {
    try {
      DateTime endDate = DateTime.now();
      DateTime startDate = endDate.subtract(Duration(hours: 1));
      List<AppUsageInfo> infoList =
          await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);

      for (var info in infoList) {
        print(info.toString());
      }
    } on AppUsageException catch (exception) {
      print(exception);
    }
  }

   


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _closeYoutube();
      },
      child: Text('Close Youtube'),
    );
    //  return MaterialApp(
    //   home: Scaffold(
    //     appBar: AppBar(
    //       title: const Text('App Usage Example'),
    //       backgroundColor: Colors.green,
    //     ),
    //     body: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: <Widget>[
    //     Text('Installed Apps:'),
    //     Expanded(
    //       child: ListView.builder(
    //         itemCount: _installedApps.length,
    //         itemBuilder: (context, index) {
    //           return ListTile(
    //             title: Text(_installedApps[index]),
    //           );
    //         },
    //       ),
    //     ),
    //     ElevatedButton(
    //       onPressed: _getInstalledApps,
    //       child: Text('Get Installed Apps'),
    //     ),
    //   ],
    // )
    //     // ListView.builder(
    //     //     itemCount: _infos.length,
    //     //     itemBuilder: (context, index) {
    //     //       return ListTile(
    //     //           title: Text(_infos[index].appName),
    //     //           trailing: Text(_infos[index].usage.toString()));
    //     //     }),
    //     // floatingActionButton: FloatingActionButton(
    //     //     onPressed: getUsageStats, child: Icon(Icons.file_download)),
    //   ),
    // );
  }
}