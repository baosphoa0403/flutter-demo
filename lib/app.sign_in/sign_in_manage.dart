import 'dart:async';

import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInManage {
  SignInManage({required this.auth, required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;
  // 1 cái quản lý event, đảm nhận nhiệm vụ nhận event từ UI

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User?> signInAnonymous() async =>
      await _signIn(() => auth.signInAnonymous());
  Future<User?> signInWithGoogle() async =>
      await _signIn(() => auth.signInWithGoogle());
  Future<User?> signInWithFacebook() async =>
      await _signIn(() => auth.signInWithFacebook());
}
