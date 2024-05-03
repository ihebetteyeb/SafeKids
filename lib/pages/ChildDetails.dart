import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChildDetailsScreen extends StatefulWidget {
  final String firstName;
  final String lastName;
  final bool expanded;

  const ChildDetailsScreen({
    required this.firstName,
    required this.lastName,
    required this.expanded,
  });

  @override
  _ChildDetailsScreenState createState() => _ChildDetailsScreenState();
}

  class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  late Future<int> _usageDataFuture;
  bool expanded = true;
  @override
  void initState() {
    super.initState();
    // _usageDataFuture = getUsageData();
  }

  static const platform = MethodChannel('getting_youtube_usage');

  Future<int> getUsageData() async {
    try {
      final int usageTime = await platform.invokeMethod('checkUsageTime');
      print(usageTime);
      return usageTime;
    } on PlatformException catch (e) {
      print('Error getting usage time: ${e.message}');
      return -1; // Or any default value
    }
  }
 int staticUsageTime = 120;
String _formatTime(int seconds) {
    // Convert seconds to hours and minutes
    int hours = seconds ~/ 3600;
    int remainingSeconds = seconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    return '$hours h $minutes m';
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
                  return ListTile(
                    title: Text('App Name: Youtube'),
                    subtitle: Text('Usage Time: ${_formatTime(staticUsageTime)}'),
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
    onPressed: () {
       getUsageData();
    // Trigger a rebuild of the widget tree
    setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Refreshed!')),
      );
    },
    child: Icon(Icons.refresh),
    backgroundColor: Colors.blue,
  ),
  floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
);

  }
}