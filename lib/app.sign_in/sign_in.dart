import 'package:demoflutter/app.sign_in/email_sign_in_page.dart';
import 'package:demoflutter/app.sign_in/sign_in_button.dart';
import 'package:demoflutter/app.sign_in/social_sign_in_button.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key, required this.auth}) : super(key: key);
  final AuthBase auth;
  void _showSignInError(BuildContext context, Exception exception) {
    showExceptionAlertDialog(context,
        exception: exception, title: "Sign in Failed", deafaultActionTex: "ok");
  }

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isLoading = false;
  Future<void> _signInAnonymous(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await widget.auth.signInAnonymous();
      // ignore: avoid_print
      // print(userCredencials);
    } on Exception catch (e) {
      widget._showSignInError(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ignore: unused_element
  Future<void> _signInGoogle(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final user = await widget.auth.signInWithGoogle();
      print(user);
      // ignore: avoid_print
      // print(userCredencials);
    } on Exception catch (e) {
      // ignore: avoid_print
      widget._showSignInError(context, e);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => EmailSignInPage(
              auth: widget.auth,
            ),
        fullscreenDialog: true));
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
          SizedBox(
            child: _buildHeader(),
            height: 50.0,
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
            onPressed: _isLoading ? null : () => {_signInGoogle(context)},
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
            onPressed: _isLoading
                ? null
                : () => {widget.auth.signInWithFacebook(context)},
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
            onPressed: _isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: _isLoading ? null : () => _signInAnonymous(context),
            borderRadius: 19.0,
            height: 50,
          ),
        ],
      ),
    );
  }

  void hello() {}

  Widget _buildHeader() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return const Text(
      "Sign In",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.w600),
    );
  }
}
