// sign_in.dart

import 'package:flutter/material.dart';
import 'package:news/constants/color.dart';
import 'package:news/constants/style.dart';
import 'package:news/screen/admin/AdminPanel.dart';
import 'package:news/services/auth.dart';
// Import the AdminPanel screen

class Sign_In extends StatefulWidget {
  final Function toggle;
  const Sign_In({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  final AuthServices _auth = AuthServices();

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 225, 238),
      appBar: AppBar(
        title: Text(
          "Sign In",
          style: topic.copyWith(color: const Color.fromARGB(255, 0, 0, 0)),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 25, 154, 219),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Text(
                "Login Your account",
                style: des.copyWith(
                    color: Colors.black, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 20),
              Center(
                  child: Image.asset(
                'assets/logo.png',
                height: 200,
              )),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Email
                        TextFormField(
                          style: TextStyle(color: Colors.black),
                          decoration: tID.copyWith(
                              hintStyle: TextStyle(color: Colors.black),
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (val) =>
                              val?.isEmpty == true ? "Enter Email" : null,
                          onChanged: (val) {
                            setState(() {
                              email = val;
                            });
                          },
                        ),
                        // Password
                        TextFormField(
                          obscureText: true,
                          style: TextStyle(color: Colors.black),
                          decoration: tID.copyWith(
                              hintText: "password",
                              hintStyle: TextStyle(color: Colors.black),
                              labelStyle: TextStyle(color: Colors.black)),
                          validator: (val) =>
                              val!.length < 6 ? "Enter Password" : null,
                          onChanged: (val) {
                            setState(() {
                              password = val;
                            });
                          },
                        ),
                        SizedBox(height: 50),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red),
                        ),
                        // Google
                        Text("Login with social account",
                            style: des.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w300)),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {},
                          child: Center(
                              child: Image.asset(
                            'assets/gmail.png',
                            height: 50,
                          )),
                        ),
                        SizedBox(height: 10),
                        // Register
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Do not have an account",
                              style: des.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(width: 10),
                            GestureDetector(
                                onTap: () {
                                  widget.toggle();
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: mainBlue,
                                      fontWeight: FontWeight.w600),
                                )),
                            SizedBox(height: 10),
                          ],
                        ),
                        // Login Button
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () async {
                            dynamic result = await _auth
                                .signInUsingEmailAndPassword(email, password);

                            if (result == null) {
                              setState(() {
                                error = "Username or Password incorrect";
                              });
                            } else {
                              // Check if the signed-in user is admin
                              if (email == "admin@gmail.com") {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AdminPanel()),
                                );
                              } else {
                                // Navigate to regular user home or another screen
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: mainwhite,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(width: 2, color: mainYellow)),
                            child: Center(
                                child: Text(
                              "Log In",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black),
                            )),
                          ),
                        ),
                        SizedBox(height: 10),
                        // Guest Login
                        GestureDetector(
                          onTap: () async {
                            await _auth.signInAnonymously();
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          child: Container(
                            height: 40,
                            width: 200,
                            decoration: BoxDecoration(
                                color: mainwhite,
                                borderRadius: BorderRadius.circular(50),
                                border:
                                    Border.all(width: 2, color: mainYellow)),
                            child: Center(
                                child: Text(
                              "Log In as Guest",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                  color: Colors.black),
                            )),
                          ),
                        ),
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
