import 'package:demoflutter/app.sign_in/email_sign_in_form.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  final AuthBase auth;

  const EmailSignInPage({Key? key, required this.auth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView( // responsive nè 
        child: Padding(
          child: Card(
              child: EmailSignInForm(
            auth: auth,
          )),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
