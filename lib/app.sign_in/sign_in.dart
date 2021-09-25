import 'package:demoflutter/app.sign_in/email_sign_in_page.dart';
import 'package:demoflutter/app.sign_in/sign_in_manage.dart';
import 'package:demoflutter/app.sign_in/sign_in_button.dart';
import 'package:demoflutter/app.sign_in/social_sign_in_button.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.manage, required this.isLoading})
      : super(key: key);
  final SignInManage manage;
  final bool isLoading;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      // register update
      create: (_) => ValueNotifier<bool>(
          false), //ValueNotifier là sub class of ChageNotifier
      // dùng changeNotifier cho object còn valueNotifier cho primitive
      child: Consumer<ValueNotifier<bool>>(
        // use consumer
        builder: (_, isLoading, __) => Provider<SignInManage>(
          //builder will call ValueNotifier.value change
          // nhà cung cấp
          // lất lớp provider bọc child vs builder
          create: (_) =>
              SignInManage(auth: auth, isLoading: isLoading), // builder nè
          child: Consumer<SignInManage>(
            // do dùng Provider.of<T>(context) bị lặp lại code vì z dùng Consumer để pass Object qua constructor
            builder: (_, manage, __) => SignInPage(
              // chuyền manage zo
              manage: manage, isLoading: isLoading.value,
            ),
          ), // child
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    showExceptionAlertDialog(context,
        exception: exception, title: "Sign in Failed", deafaultActionTex: "ok");
  }

  // bool _isLoading = false;
  Future<void> _signInAnonymous(BuildContext context) async {
    try {
      await manage.signInAnonymous();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  // ignore: unused_element
  Future<void> _signInGoogle(BuildContext context) async {
    try {
      await manage.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInFacebook(BuildContext context) async {
    try {
      await manage.signInWithFacebook();
    } on Exception catch (e) {
      showExceptionAlertDialog(context,
          exception: e, title: "Sign in Failed", deafaultActionTex: "ok");
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => EmailSignInPage(), fullscreenDialog: true));
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

// snapshot has connectionState, hasError/Error, hasData/data
  Widget _buildContent(BuildContext context) {
    // underscore == private java
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            child: _buildHeader(isLoading),
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
            onPressed: isLoading ? null : () => {_signInGoogle(context)},
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
            onPressed: isLoading ? null : () => {_signInFacebook(context)},
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
            onPressed: isLoading ? null : () => _signInWithEmail(context),
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
            onPressed: isLoading ? null : () => _signInAnonymous(context),
            borderRadius: 19.0,
            height: 50,
          ),
        ],
      ),
    );
  }

  void hello() {}

  Widget _buildHeader(bool isLoading) {
    if (isLoading) {
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
