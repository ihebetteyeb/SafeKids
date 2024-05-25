import 'package:flutter/material.dart';
import 'package:safekids/pushNotif.dart';
import 'package:flutter/services.dart';

class ChildDetailsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool expanded;
   final int initialUsageTime;

  const ChildDetailsScreen({
    required this.firstName,
    required this.lastName,
    required this.expanded,
      required this.initialUsageTime,
  });

  @override
  _ChildDetailsScreenState createState() => _ChildDetailsScreenState();
}

  class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  late Future<int> _usageDataFuture;
  bool expanded = true;
   late Future<int> _usageTime;
  @override
  void initState() {
    super.initState();
      _usageTime = Future.value(widget.initialUsageTime); 
  }

  static const platform = MethodChannel('com.example.safekids');



  Future<int> _getUsageTime() async {

    await FirebaseApi().sendUsageTimeNotificationToUser();

    return widget.initialUsageTime; 
  }

   void _refreshUsageTime() {
    setState(() {
      _usageTime = _getUsageTime();
    });
  }

String _formatTime(int milliseconds) {
  int seconds = (milliseconds / 1000).round();

  // Calculate hours, minutes, and remaining seconds
  int hours = seconds ~/ 3600;
  int remainingSeconds = seconds % 3600;
  int minutes = remainingSeconds ~/ 60;

  // Format the time string
  return '$hours h $minutes m $seconds s';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
  appBar: AppBar(
    title: Text('Child Details'),
  ),
  body: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 300, // Specify a height for the container
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                // Display general information about the child
                Container(
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blueGrey[100],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'General Information',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Text(
                            'First Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('ahmed'),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Last Name: ',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('etteyeb'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Display the list of mobile apps with their usage time
                SizedBox(height: 16.0),
                Text(
                  'Mobile Apps Usage',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                // Animated boxes for mobile apps usage
                AnimatedContainer(
  duration: Duration(milliseconds: 500),
  curve: Curves.easeInOut,
  height: expanded ? 200.0 : 50.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10.0),
    color: Colors.blueGrey[100],
  ),
  child: expanded
            ? ListView.builder(
  itemCount: 1,
  itemBuilder: (context, index) {
return FutureBuilder<int>(
              future: _usageTime,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                 final usageTime = snapshot.data ?? 0; 
          return ListTile(
            title: Text('App Name: YouTube'),
            subtitle: Text('Usage Time: ${_formatTime(usageTime)} '),
            trailing: IconButton(
              onPressed: () {
                FirebaseApi().sendStopNotificationToUser();
              },
              icon: Icon(
                Icons.stop_screen_share_outlined,
                color: Colors.red,
              ),
            ),);
                } else {
                  return Text('Press the button to check usage time.');
                }
              },
            );
  },
)
            : Center(
                child: Text(
                  'Tap to Expand',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ),
)
              ],
            ),
          ),
        ),
      ],
    ),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () async {
   
 _refreshUsageTime();

     },
    child: Icon(Icons.refresh),
    backgroundColor:   Colors.blueGrey[100],
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);

  }
}