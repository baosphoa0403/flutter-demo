import 'package:demoflutter/app.sign_in/validator.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:flutter/material.dart';

enum EmailSignInFormType { signIn, register }

class EmailSignInChangeModel with EmailAndPasswordValidator, ChangeNotifier {
  // ChangeNotifier used with mutable object != blocC used with stream of immutable object
  String email, password;
  EmailSignInFormType formType;
  bool isLoading, submitted;
  final AuthBase auth;
  EmailSignInChangeModel(
      {required this.auth,
      this.email = "",
      this.password = "",
      this.formType = EmailSignInFormType.signIn,
      this.isLoading = false,
      this.submitted = false});

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      submitted}) {
    this.email = email ?? this.email;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.password = password ?? this.password;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toogleFormType() {
    final formType = this.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
        email: "",
        password: "",
        formType: formType,
        submitted: false,
        isLoading: false);
  }

  Future<void> submit() async {
    // build context always have in stateFull but need to passed inside stateless widget
    updateWith(submitted: true, isLoading: true);
    try {
      // await Future.delayed(Duration(seconds: 3));
      if (formType == EmailSignInFormType.signIn) {
        final user = await auth.signInWithEmailPassword(email, password);
        // ignore: avoid_print
        print(user);
      } else {
        final user = await auth.createUserWithEmailAndPassword(email, password);
        // ignore: avoid_print
        print(user);
      }
      // ko dùng truyển trang trong bloc
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == EmailSignInFormType.signIn
        ? "Sign In"
        : "Create Account";
  }

  String get secondaryText {
    return formType == EmailSignInFormType.signIn
        ? "Need an Account? Register"
        : "have an account ? SignIn";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        emailValidator.isValid(password) &&
        !isLoading;
  }

  String? showErrorText(String value, String mess) {
    final flag = submitted && !emailValidator.isValid(value);
    return flag ? mess : null;
  }
  // kiểm tra tình huống đã submit mà error firebase ném về
  // xong ngta xoá đi content thì empty => false => là null vì vậy phải phủ định !false => true show error
}
