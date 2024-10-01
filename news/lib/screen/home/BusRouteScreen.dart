import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BusRouteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Route'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('routes').snapshots(),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                      Text('Timings: ${routeData['timings'] ?? 'No Timings'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
