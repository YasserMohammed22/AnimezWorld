import 'package:animez_world/auth/authenticate.dart';
import 'package:animez_world/home/home.dart';
import 'package:animez_world/models/member.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Member?>(context);
    print(user);
    if(user == null) {
      return Authenticate();
    } else {
      return const Home();
    }
  }
}
