import 'dart:io';

import 'package:animez_world/home/wrapper.dart';
import 'package:animez_world/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:animez_world/firebase_options.dart';
import 'models/member.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  runApp(const AnimezWorld());
}

class AnimezWorld extends StatelessWidget {

  const AnimezWorld({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Member?>.value(
        value: Auth().user,
        initialData: null,
        child: MaterialApp(
          title: "AnimezWorld",
          debugShowCheckedModeBanner: false,
          home: Wrapper(),
        )
    );
  }
}

