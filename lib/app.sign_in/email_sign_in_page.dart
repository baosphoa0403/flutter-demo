import 'package:demoflutter/app.sign_in/email_sign_in_bloc_base.dart';
import 'package:demoflutter/app.sign_in/email_sign_in_form_stateful.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/material.dart';

class EmailSignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Time Tracker"),
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        // responsive nè
        child: Padding(
          child: Card(child: EmailSignInFormBlocBased.create(context)),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
