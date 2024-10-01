import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic>? userData;

  const ProfileScreen({Key? key, this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = userData?['name'] ?? 'Name not available';
    final email = userData?['email'] ?? 'Email not available';
    final nic = userData?['nic'] ?? 'NIC not available';

    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/ssaa.jpg'),
              radius: 50,
            ),
            SizedBox(height: 20),
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Email: $email',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              'NIC: $nic',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
