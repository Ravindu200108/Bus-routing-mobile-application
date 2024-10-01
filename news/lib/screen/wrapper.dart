import 'package:flutter/material.dart';
import 'package:news/models/UserModel.dart';
import 'package:news/screen/authenticate/authenticate.dart';
import 'package:news/screen/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
