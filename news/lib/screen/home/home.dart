import 'package:flutter/material.dart';
import 'package:news/constants/color.dart';
import 'package:news/screen/home/BusRouteScreen.dart';
import 'package:news/screen/home/busTracking.dart';
import 'package:news/screen/home/profileScreen.dart';
import 'package:news/screen/home/NotificationScreen.dart';
import 'package:news/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthServices _auth = AuthServices();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _navigateToProfile(BuildContext context) async {
    final user = _auth.getCurrentUser();
    if (user != null) {
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(userData: userData),
        ),
      );
    }
  }

  // Show feedback dialog
  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Send Feedback'),
          content: TextField(
            controller: feedbackController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your feedback here...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String feedback = feedbackController.text;
                if (feedback.isNotEmpty) {
                  // Save the feedback to Firestore
                  try {
                    await _firestore.collection('feedback').add({
                      'feedback': feedback,
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Feedback sent successfully!')),
                    );
                  } catch (e) {
                    print('Failed to send feedback: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to send feedback.')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter feedback.')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Send'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 83, 125),
        title: Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        NotificationScreen()), // Navigate to NotificationScreen
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () => _navigateToProfile(context),
          ),
          SizedBox(width: 16), // Add some spacing between icons and the edge
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
            ),
            onPressed: () async {
              await _auth.signOut();
              // Handle navigation to sign-in screen
              Navigator.pushReplacementNamed(context, '/signIn');
            },
            child: Icon(Icons.logout, color: Colors.black),
          ),
          SizedBox(width: 8), // Adjust spacing if needed
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/home_photo.png', // Path to your image asset
              width: 400, // Adjust the width as needed
              height: 400, // Adjust the height as needed
              fit: BoxFit.cover, // Adjust the fit as needed
            ),
            SizedBox(height: 20), // Add some spacing below the image
            Wrap(
              spacing: 20, // Add some spacing between buttons
              runSpacing: 20, // Add some spacing between rows
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BusRouteScreen()), // Navigate to BusRouteScreen
                    );
                  },
                  child: Text('Bus Route'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              BusTrackingScreen()), // Navigate to BusTrackingScreen
                    );
                  },
                  child: Text('Bus Tracking'),
                ),
                ElevatedButton(
                  onPressed: _showFeedbackDialog,
                  child: Text('Send Feedback'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
