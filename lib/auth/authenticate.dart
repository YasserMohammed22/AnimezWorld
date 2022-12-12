import 'package:animez_world/auth/login.dart';
import 'package:animez_world/auth/register.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool check = true;
  void toggleAuth(){
    setState((){
      check = !check;
    });
  }
  @override
  Widget build(BuildContext context) {
    return check?Register(toggleAuth: toggleAuth):Login(toggleAuth: toggleAuth);
  }
}

