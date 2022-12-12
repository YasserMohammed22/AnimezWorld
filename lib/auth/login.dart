import 'package:flutter/material.dart';

import '../services/auth.dart';
import '../styles/authstyles.dart';

class Login extends StatefulWidget {
  final toggleAuth;
  const Login({Key? key, this.toggleAuth}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "";
  String password = "";
  String error = "";
  final formKey = GlobalKey<FormState>();
  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        actions: [
          TextButton.icon(
              onPressed: widget.toggleAuth,
              icon: Icon(Icons.person_add_alt_1_sharp, color: Colors.white),
              label: Text(
                'register',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: AuthStyle().textInput(text: 'EMAIL'),
                  style: AuthStyle().textStyle(),
                  validator: (val) {
                    if (val == "") {
                      return "This Field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextFormField(
                  decoration: AuthStyle().textInput(text: 'PASSWORD'),
                  style: AuthStyle().textStyle(),
                  obscureText: true,
                  validator: (val) {
                    if (val == "") {
                      return "This Field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      dynamic result = await auth.signIn(email, password);
                      if (result == null) {
                        setState(() =>
                        error = "Either email or password is incorrect");
                      }
                    }
                  },
                  child: Text(
                    "LOG IN",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 23.0,
                    ),
                  ),
                  style: ButtonStyle(
                      padding: MaterialStateProperty.resolveWith((states) =>
                          EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0)),
                      backgroundColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blueAccent)),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Text(
                  error,
                  style: TextStyle(
                    fontSize: 21.0,
                    color: Colors.redAccent[200],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
