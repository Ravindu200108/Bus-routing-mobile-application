//import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart'; //--------------------------
import 'package:flutter/material.dart';
import 'package:news/models/UserModel.dart';
import 'package:news/screen/admin/AdminPanel.dart';
import 'package:news/screen/authenticate/sign_in.dart';
import 'package:news/screen/wrapper.dart';
import 'package:news/services/auth.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ------------------
  await Firebase.initializeApp(); // --------------------
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel?>.value(
      initialData: UserModel(uid: "null"),
      value: AuthServices().user,
      child: MaterialApp(
        home: Wrapper(),
        initialRoute: '/login',
        routes: {
          '/login': (context) => Sign_In(toggle: () {}),
          '/admin': (context) => AdminPanel(),
          // Add other routes here
        },
      ),
    );
  }
}
