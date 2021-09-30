import 'package:demoflutter/home/jobs/jobs_page.dart';
import 'package:demoflutter/app.sign_in/sign_in.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:demoflutter/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context,
        listen:
            false); // do là stateless nên listen là false ko cần change rebuild
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
          return Provider<Database>(
              // add database provider
              create: (context) => FirestoreDatabase(uid: user.uid),
              child: JopsPage());
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

// để liên lạc giữa 2 widget với nhau thì mình dùng callback
