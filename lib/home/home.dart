import 'package:animez_world/models/member.dart';
import 'package:animez_world/models/member_profile.dart';
import 'package:animez_world/services/auth.dart';
import 'package:animez_world/services/database.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../profile/profile.dart';
import 'home_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<BottomNavigationBarItem> items = [
  ];
  var currIndex = 0;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Member?>(context)??null;
    return Scaffold(
      appBar: AppBar(
        title: Text("AnimezWorld"),
        actions: [
          TextButton.icon(
              onPressed: () async {
                await Auth().signOut();
              },
              icon: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              label: Text("Logout", style: TextStyle(color: Colors.white)))
        ],
      ),
      body: StreamProvider<MemberProfileData?>.value(value: Database(uid: user!.uid).userProfile,initialData: null,
      child: getBody(currIndex)),
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile")
      ],
        currentIndex: currIndex,
        onTap: (int index)=>setState((){
          currIndex = index;
        }),
      ),
    );
  }

  Widget getBody(int index){
    switch(index){
      case 0: return HomeScreen();
      case 1: return Profile();
      default: return HomeScreen();
    }
  }
}
