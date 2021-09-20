import 'dart:async';

import 'package:demoflutter/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});
  var isLoading = false;
  final AuthBase auth;
  // 1 cái quản lý event, đảm nhận nhiệm vụ nhận event từ UI
  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    print("run dispose");
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      _setIsLoading(false);
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
