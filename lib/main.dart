import 'package:demoflutter/app.sign_in/landing.page.dart';
import 'package:demoflutter/app.sign_in/sign_in.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final signInPage = SignInPage();

    return MaterialApp(
        title: "Timer Tracker",
        theme: ThemeData(primarySwatch: Colors.indigo),
        home: LandingPgae(auth: Auth()));
  }
}

// 1.introduce Bloc

// 2.refactor SignInPage

//3. refactor EmailSignForm 