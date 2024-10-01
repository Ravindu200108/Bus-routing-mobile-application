import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Color.fromARGB(255, 0, 83, 125),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
            return Center(child: Text('No notifications available.'));
          }

          var notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              var notification = notifications[index];
              var notificationData =
                  notification.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(notificationData['message'] ?? 'No message'),
                subtitle: Text(
                    notificationData['timestamp'].toDate().toString() ??
                        'No timestamp'),
                contentPadding: EdgeInsets.all(16),
              );
            },
          );
        },
      ),
    );
  }
}
