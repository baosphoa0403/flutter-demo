import 'package:demoflutter/app.sign_in/email_sign_in_form_change_notifier.dart';
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
          child: Card(child: EmailSignInFormChangeNotifier.create(context)),
          padding: const EdgeInsets.all(16.0),
        ),
      ),
    );
  }
}
