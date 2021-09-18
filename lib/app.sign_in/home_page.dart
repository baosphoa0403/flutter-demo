import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key, User? user, required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _logoutAnonymous() async {
    try {
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure that you want to logout",
        defaultActionText: "OK",
        cancelActionText: "No");
    if (didRequestSignOut == true) {
      _logoutAnonymous();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: <Widget>[
          ElevatedButton(
              onPressed: () => confirmSignOut(context),
              child: const Text(
                "Logout",
                style: TextStyle(fontSize: 20.0, color: Colors.white),
              )),
        ],
      ),
      // ignore: prefer_const_constructors
      body: Padding(
        padding: EdgeInsets.all(3.0),
        child: Text("Hha"),
      ),
    );
  }
}
