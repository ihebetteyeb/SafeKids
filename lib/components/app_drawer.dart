import 'package:flutter/material.dart';
import 'package:safekids/pages/children_screen.dart';
import 'package:flutter/services.dart';


class AppDrawer extends StatelessWidget {

     AppDrawer({super.key });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('My Account'),
            onTap: () {
              // Navigate to My Account screen
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/my_account');
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('Children'),
           onTap: () {
    // Navigate to the ChildrenScreen when "Children" is tapped
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChildrenScreen()),
    );
  },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Navigate to Settings screen
              Navigator.pop(context); // Close the drawer
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ],
      ),
    );
  }
}
