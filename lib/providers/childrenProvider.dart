import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'child.dart'; // Make sure to import your model class

class ChildrenProvider with ChangeNotifier {
  List<Child> _children = [];
  final DatabaseReference _childrenRef = FirebaseDatabase.instance.ref().child('children');

  List<Child> get children => _children;

  ChildrenProvider() {
    fetchChildren();
  }

  Future<void> fetchChildren() async {
    _childrenRef.onValue.listen((event) {
      final dataSnapshot = event.snapshot;
      if (dataSnapshot.value != null && dataSnapshot.value is Map<dynamic, dynamic>) {
        final Map<dynamic, dynamic> childrenMap = dataSnapshot.value as Map<dynamic, dynamic>;
        final List<Child> loadedChildren = [];
        childrenMap.forEach((key, value) {
          if (value is Map<dynamic, dynamic>) {
          final child = Child.fromMap(Map<String, dynamic>.from(value));
            loadedChildren.add(child);
            print('Key: $key, Value: $value'); // Print the raw data
            print('Child: ${child.name}, Image URL: ${child.imageUrl}'); // Print parsed data
          }
        });
        _children = loadedChildren;
        notifyListeners();
      }
    });
  }
}
