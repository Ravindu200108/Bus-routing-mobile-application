import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatefulWidget {
  final Function toggle;
  const Register({Key? key, required this.toggle}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String name = "";
  String nic = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 198, 225, 238),
      appBar: AppBar(
        title: Text(
          "Register",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 0, 83, 125),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "If you don't have an account, you can register here",
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
              ),
              SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/logo.png',
                  height: 200,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Name",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (val) =>
                            val?.isEmpty == true ? "Enter Name" : null,
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "NIC",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (val) =>
                            val?.isEmpty == true ? "Enter NIC" : null,
                        onChanged: (val) {
                          setState(() {
                            nic = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (val) =>
                            val?.isEmpty == true ? "Enter Email" : null,
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(color: Colors.black),
                          labelStyle: TextStyle(color: Colors.black),
                        ),
                        validator: (val) => val!.length < 6
                            ? "Enter Password (min 6 characters)"
                            : null,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 50),
                      Text(error, style: TextStyle(color: Colors.red)),
                      Text(
                        "Login with social account",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Image.asset(
                            'assets/gmail.png',
                            height: 50,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w300),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              widget.toggle();
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            try {
                              UserCredential result =
                                  await _auth.createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );

                              final userId = result.user!.uid;

                              await _firestore
                                  .collection('users')
                                  .doc(userId)
                                  .set({
                                'name': name,
                                'email': email,
                                'nic': nic,
                              });

                              Navigator.of(context).pushReplacementNamed(
                                  '/home'); // Adjust as necessary
                            } catch (e) {
                              setState(() {
                                error = "Error: ${e.toString()}";
                              });
                            }
                          }
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(width: 2, color: Colors.yellow),
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
