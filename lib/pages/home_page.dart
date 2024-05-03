import 'package:flutter/material.dart';
import 'package:safekids/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:safekids/components/app_drawer.dart';
import 'package:flutter/services.dart';

class HomePage extends StatelessWidget {

  HomePage({super.key }); 

  final User? user = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut(); 
  }

  Widget _title() {
    return const Text('SafeKids Auth');
  }


  Widget _userUid() {
    return  Text(user?.email ?? 'User email');
  }

  Widget _signOutButton() {
    return  ElevatedButton(onPressed: signOut, child: const Text('Sign Out'));
  }

 final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build (BuildContext context){
    
  return Scaffold(
    key: _scaffoldKey,
    appBar: AppBar(
    title: _title(),
    leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            

            _scaffoldKey.currentState!.openDrawer();
          },
        ),
  ),
  drawer: AppDrawer(),
  body: Container(height: double.infinity, width: double.infinity,padding: const EdgeInsets.all(20),
  child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
  children: <Widget>[
    _userUid(),
    _signOutButton()
  ],)),);}
}