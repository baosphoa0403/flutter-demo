import 'dart:io';

import 'package:demoflutter/app.sign_in/validator.dart';
import 'package:demoflutter/common_widgets/form_submit_button.dart';
import 'package:demoflutter/common_widgets/show_alert_dialog.dart';
import 'package:demoflutter/common_widgets/show_exception_diaglog.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator {
  final AuthBase auth;
  EmailSignInForm({Key? key, required this.auth}) : super(key: key);

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  // const EmailSignInForm({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  String get _email => _emailController.text;
  final FocusNode _emailFocusNode = new FocusNode();

  final TextEditingController _passwordController = TextEditingController();
  String get _password => _passwordController.text;
  final FocusNode _passwordFocusNode = new FocusNode();

  EmailSignInFormType _formType = EmailSignInFormType.register;
  bool _submitted = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    print("dispose cancel");
    super.dispose();
  }

  List<Widget> _buildChildren() {
    final primaryText =
        _formType == EmailSignInFormType.signIn ? "Sign In" : "create Account";
    final secondaryText = _formType == EmailSignInFormType.signIn
        ? "Need an Account? Register"
        : "have an account ? SignIn";
    // bool submitEnable = _email.isNotEmpty && _password.isNotEmpty;
    bool submitEnable = widget.emailValidator.isValid(_email) &&
        widget.emailValidator.isValid(_password) &&
        !_loading;
    return [
      _buttonEmailTextField(),
      const SizedBox(
        height: 20,
        width: 20,
      ),
      _buttonPasswordTextField(),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnable ? _submit : null,
      ),
      ElevatedButton(
          onPressed: !_loading ? _toogleFormType : null,
          child: Text(
            secondaryText,
            style: TextStyle(color: Colors.black),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.white, // background
            onPrimary: Colors.white, // foreground
            //  fixedSize: Size(300, 500)
          )),
    ];
  }

  TextField _buttonPasswordTextField() {
    bool showErrorText = _submitted &&
        !widget.emailValidator.isValid(
            _password); // kiểm tra tình huống đã submit mà error firebase ném về
    // xong ngta xoá đi content thì empty => false => là null vì vậy phải phủ định !false => true show error
    return TextField(
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: "password",
            hintText: "123",
            errorText: showErrorText ? widget.invalidPassErrorText : null,
            enabled: _loading == false),
        obscureText: true, // same same type password html
        controller: _passwordController,
        textInputAction: TextInputAction.done,
        focusNode: _passwordFocusNode,
        onChanged: (password) => {_updateState()},
        onEditingComplete: () => _submit());
  }

  TextField _buttonEmailTextField() {
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: "email",
          hintText: "bao@gmail.com",
          errorText: showErrorText ? widget.invalidEmailErrorText : null,
          enabled: _loading == false),
      autocorrect: true,
      autofocus: true,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      controller: _emailController,
      focusNode: _emailFocusNode,
      onChanged: (email) => {_updateState()},
      onEditingComplete: () {
        final newFocus = widget.emailValidator
                .isValid(_email) // check có cho chuyển forcus ko
            ? _passwordFocusNode
            : _emailFocusNode;
        FocusScope.of(context).requestFocus(newFocus);
      },
    );
  }

  void _submit() async {
    print("submit-call");
    setState(() {
      _submitted = true;
      _loading = true;
    });
    try {
      await Future.delayed(Duration(seconds: 3));
      if (_formType == EmailSignInFormType.signIn) {
        final user =
            await widget.auth.signInWithEmailPassword(_email, _password);
        // ignore: avoid_print
        print(user);
      } else {
        final user =
            await widget.auth.createUserWithEmailAndPassword(_email, _password);
        // ignore: avoid_print
        print(user);
      }
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      showExceptionAlertDialog(context,
          exception: e, title: "Sign in Failed", deafaultActionTex: "ok");
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  _updateState() {
    setState(() {});
  }

  void _toogleFormType() {
    setState(() {
      _formType = _formType == EmailSignInFormType.signIn
          ? EmailSignInFormType.register
          : EmailSignInFormType.signIn;
      _submitted = false;
    });
    FocusScope.of(context).requestFocus(_emailFocusNode);
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // chìu ngang
        mainAxisSize: MainAxisSize.min, // theo chìu dọc bỏ khoảng trắng bớt
        children: _buildChildren(),
      ),
    );
  }
}
