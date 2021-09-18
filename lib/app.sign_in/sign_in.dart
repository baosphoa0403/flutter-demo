import 'package:demoflutter/app.sign_in/email_sign_in_page.dart';
import 'package:demoflutter/app.sign_in/sign_in_button.dart';
import 'package:demoflutter/app.sign_in/social_sign_in_button.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;

  Future<void> _signInAnonymous() async {
    try {
      await auth.signInAnonymous();
      // ignore: avoid_print
      // print(userCredencials);
    } catch (e) {
      print(e.toString());
    }
  }

  // ignore: unused_element
  Future<void> _signInGoogle() async {
    try {
      final user = await auth.signInWithGoogle();
      print(user);
      // ignore: avoid_print
      // print(userCredencials);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
  void _signInWithEmail(BuildContext  context){
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => EmailSignInPage(auth: auth,),fullscreenDialog: true)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timer Tracker"),
        elevation: 10.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    // underscore == private java
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 8.0,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: "Sign In With Google",
            color: Colors.white,
            textColor: Colors.black,
            onPressed: () => {_signInGoogle()},
            borderRadius: 19.0,
            height: 50,
            assertName: 'image/google-48.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: "Sign In With facebook",
            color: const Color(0xFF334D92),
            textColor: Colors.black,
            onPressed: () => { auth.signInWithFacebook()},
            borderRadius: 19.0,
            height: 50,
            assertName: 'image/facebook-48.png',
          ),
          const SizedBox(
            height: 8.0,
          ),
          SocialSignInButton(
            text: "Sign In With email",
            color: Colors.pink.shade400,
            textColor: Colors.black,
            onPressed: () => _signInWithEmail(context),
            borderRadius: 19.0,
            height: 50,
            assertName: 'image/instagram-48.png',
          ),
          const Text(
            "or",
            style: TextStyle(fontSize: 14.0, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8.0,
          ),
          SignInButton(
            text: "Go anonnymous",
            color: Colors.lime,
            textColor: Colors.black,
            onPressed: () => _signInAnonymous(),
            borderRadius: 19.0,
            height: 50,
          ),
        ],
      ),
    );
  }

  void hello() {}

  void _signInWithGoogle() {
    print("hello world");
  }
}
