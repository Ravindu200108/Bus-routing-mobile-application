import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:news/services/auth.dart';
// Import your AuthServices class

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthServices _auth = AuthServices(); // Instantiate AuthServices
  final _formKey = GlobalKey<FormState>();
  final _notificationFormKey = GlobalKey<FormState>();

  String routeName = "";
  String routeDescription = "";
  String startPoint = "";
  String endPoint = "";
  String timings = "";
  String? selectedRouteId;
  String notificationMessage = ""; // Add this field for notifications

  // Method to add a new route to Firestore
  Future<void> _addRoute() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _firestore.collection('routes').add({
        'name': routeName,
        'description': routeDescription,
        'start_point': startPoint,
        'end_point': endPoint,
        'timings': timings,
        'createdAt': Timestamp.now(),
      });

      // Clear the form fields
      setState(() {
        routeName = "";
        routeDescription = "";
        startPoint = "";
        endPoint = "";
        timings = "";
      });

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route added successfully')),
      );
    }
  }

  // Method to update a route in Firestore
  Future<void> _updateRoute(String routeId) async {
    if (_formKey.currentState?.validate() ?? false) {
      await _firestore.collection('routes').doc(routeId).update({
        'name': routeName,
        'description': routeDescription,
        'start_point': startPoint,
        'end_point': endPoint,
        'timings': timings,
      });

      // Clear the form fields
      setState(() {
        routeName = "";
        routeDescription = "";
        startPoint = "";
        endPoint = "";
        timings = "";
        selectedRouteId = null;
      });

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Route updated successfully')),
      );
    }
  }

  // Method to delete a route from Firestore
  Future<void> _deleteRoute(String routeId) async {
    await _firestore.collection('routes').doc(routeId).delete();

    // Optionally, show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Route deleted successfully')),
    );
  }

  // Method to handle logout
  Future<void> _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Navigate to login screen after logout
  }

  // Method to send a notification and save it to Firestore
  Future<void> _sendNotification() async {
    if (_notificationFormKey.currentState?.validate() ?? false) {
      // Add notification to Firestore
      await _firestore.collection('notifications').add({
        'message': notificationMessage,
        'timestamp': Timestamp.now(),
      });

      // Optionally, show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification saved successfully')),
      );

      // Clear the notification message field
      setState(() {
        notificationMessage = "";
      });
    }
  }

  // Method to show all feedbacks from Firestore
  void _showFeedbacks() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Feedbacks'),
          content: SizedBox(
            width: double.maxFinite,
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('feedback').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(child: Text('No feedbacks available.'));
                }

                var feedbacks = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    var feedback = feedbacks[index];
                    var feedbackData = feedback.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(feedbackData['feedback'] ?? 'No Feedback'),
                      subtitle: Text(
                          feedbackData['timestamp']?.toDate().toString() ??
                              'No Timestamp'),
                    );
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        backgroundColor: Color.fromARGB(255, 25, 154, 219),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('routes').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                  return Center(child: Text('No routes available.'));
                }

                var routes = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: routes.length,
                  itemBuilder: (context, index) {
                    var route = routes[index];
                    var routeData = route.data() as Map<String, dynamic>;

                    return Card(
                      margin: EdgeInsets.all(8.0),
                      elevation: 4,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.0),
                        title: Text(
                          routeData['name'] ?? 'No Name',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Description: ${routeData['description'] ?? 'No Description'}'),
                            SizedBox(height: 4),
                            Text(
                                'Start Point: ${routeData['start_point'] ?? 'No Start Point'}'),
                            Text(
                                'End Point: ${routeData['end_point'] ?? 'No End Point'}'),
                            Text(
                                'Timings: ${routeData['timings'] ?? 'No Timings'}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                setState(() {
                                  routeName = routeData['name'] ?? '';
                                  routeDescription =
                                      routeData['description'] ?? '';
                                  startPoint = routeData['start_point'] ?? '';
                                  endPoint = routeData['end_point'] ?? '';
                                  timings = routeData['timings'] ?? '';
                                  selectedRouteId = route.id;
                                });
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Edit Route'),
                                    content: SingleChildScrollView(
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: 400),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Route Name'),
                                                initialValue: routeName,
                                                validator: (value) => value
                                                            ?.isEmpty ==
                                                        true
                                                    ? 'Please enter a route name'
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    routeName = value;
                                                  });
                                                },
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Description'),
                                                initialValue: routeDescription,
                                                validator: (value) => value
                                                            ?.isEmpty ==
                                                        true
                                                    ? 'Please enter a description'
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    routeDescription = value;
                                                  });
                                                },
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Start Point'),
                                                initialValue: startPoint,
                                                validator: (value) => value
                                                            ?.isEmpty ==
                                                        true
                                                    ? 'Please enter a start point'
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    startPoint = value;
                                                  });
                                                },
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'End Point'),
                                                initialValue: endPoint,
                                                validator: (value) => value
                                                            ?.isEmpty ==
                                                        true
                                                    ? 'Please enter an end point'
                                                    : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    endPoint = value;
                                                  });
                                                },
                                              ),
                                              TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: 'Timings'),
                                                initialValue: timings,
                                                validator: (value) =>
                                                    value?.isEmpty == true
                                                        ? 'Please enter timings'
                                                        : null,
                                                onChanged: (value) {
                                                  setState(() {
                                                    timings = value;
                                                  });
                                                },
                                              ),
                                              SizedBox(height: 20),
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (selectedRouteId != null) {
                                                    _updateRoute(
                                                        selectedRouteId!);
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text('Update Route'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                if (selectedRouteId != null) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this route?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            if (selectedRouteId != null) {
                                              _deleteRoute(selectedRouteId!);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text('Add New Route'),
                        content: SingleChildScrollView(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 400),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Route Name'),
                                    validator: (value) => value?.isEmpty == true
                                        ? 'Please enter a route name'
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        routeName = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Description'),
                                    validator: (value) => value?.isEmpty == true
                                        ? 'Please enter a description'
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        routeDescription = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration: InputDecoration(
                                        labelText: 'Start Point'),
                                    validator: (value) => value?.isEmpty == true
                                        ? 'Please enter a start point'
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        startPoint = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'End Point'),
                                    validator: (value) => value?.isEmpty == true
                                        ? 'Please enter an end point'
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        endPoint = value;
                                      });
                                    },
                                  ),
                                  TextFormField(
                                    decoration:
                                        InputDecoration(labelText: 'Timings'),
                                    validator: (value) => value?.isEmpty == true
                                        ? 'Please enter timings'
                                        : null,
                                    onChanged: (value) {
                                      setState(() {
                                        timings = value;
                                      });
                                    },
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _addRoute,
                                    child: Text('Add Route'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text('Create Route'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showFeedbacks,
                  child: Text('Show Feedbacks'),
                ),
                SizedBox(height: 20),
                Text(
                  'Send Notification',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Form(
                  key: _notificationFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            InputDecoration(labelText: 'Notification Message'),
                        validator: (value) => value?.isEmpty == true
                            ? 'Please enter a notification message'
                            : null,
                        onChanged: (value) {
                          setState(() {
                            notificationMessage = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _sendNotification,
                        child: Text('Send Notification'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
