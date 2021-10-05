import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);
  Future<void> _logoutAnonymous(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      final googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await auth.signOut();
    } catch (e) {}
  }

  Future<void> confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure that you want to logout",
        defaultActionText: "OK",
        cancelActionText: "No");
    if (didRequestSignOut == true) {
      _logoutAnonymous(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account"),
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
    );
  }
}
