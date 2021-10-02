import 'package:demoflutter/app.sign_in/landing.page.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp(
          title: "Timer Tracker",
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: LandingPage()),
    );
  }
}

// 1.introduce Bloc

// 2.refactor SignInPage

//3. refactor EmailSignForm 

// advantage working with Blocs

// separate business logic from: 
//- layout code
//- implementation details of external services

// 4 state ui loading data empty error