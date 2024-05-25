import 'package:flutter/material.dart';
import 'package:safekids/pages/ChildDetails.dart';
import 'package:safekids/providers/child.dart';
import 'package:safekids/pushNotif.dart';
import 'package:flutter/services.dart';
import 'package:safekids/providers/childrenProvider.dart'; 
import 'package:safekids/providers/child.dart'; 
import 'package:provider/provider.dart';

class ChildrenScreen extends StatelessWidget {

   ChildrenScreen({super.key });

  @override
  Widget build(BuildContext context) {
     final childrenProvider = Provider.of<ChildrenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Children'),
      ),
      body: ListView.builder(
        itemCount: children.length,
        itemBuilder: (context, index) {
          final child = children[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(child.imageUrl),
            ),
            title: Text(child.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.data_usage),
                  onPressed: () {
                    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChildDetailsScreen(
          firstName: "iheb",
          lastName: "etteyeb",
          expanded: true,
          initialUsageTime: 0
        ),
      ),
    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    FirebaseApi().sendStopNotificationToUser();
                  },
                ),
              ],
            ),
            onTap: () {
              
            },
          );
        },
      ),
    );
  }
}




final List<Child> children = [
  Child(name: 'Child 1', imageUrl: 'assets/images/child1.png'),
  Child(name: 'Child 2', imageUrl: 'assets/images/child1.png'),

];