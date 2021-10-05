import 'dart:async';

import 'package:demoflutter/app.sign_in/email_sign_in_change_model.dart';
import 'package:demoflutter/service/auth.dart';
import 'package:rxdart/rxdart.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});
  final AuthBase auth;
  final _modelSubject = BehaviorSubject<EmailSignInChangeModel>.seeded(
      EmailSignInChangeModel(auth: Auth()));
  // final StreamController<EmailSignInChangeModel> _modelController =
  //     StreamController<EmailSignInChangeModel>();

  Stream<EmailSignInChangeModel> get modelStream => _modelSubject.stream;
  // EmailSignInChangeModel _model = EmailSignInChangeModel(auth: Auth());
  EmailSignInChangeModel get _model => _modelSubject.value;
  void dispose() {
    _modelSubject.close();
  }

  void updateWith(
      {String? email,
      String? password,
      EmailSignInFormType? formType,
      bool? isLoading,
      submitted}) {
    _modelSubject.value = _model.copyWith(
        email: email!,
        formType: formType!,
        isLoading: isLoading!,
        password: password!,
        submitted: submitted);
  }

  void updateEmail(String email) => updateWith(email: email);
  void updatePassword(String password) => updateWith(password: password);
  void toogleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
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
      if (_model.formType == EmailSignInFormType.signIn) {
        final user =
            await auth.signInWithEmailPassword(_model.email, _model.password);
        // ignore: avoid_print
        print(user);
      } else {
        final user = await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
        // ignore: avoid_print
        print(user);
      }
      // ko dùng truyển trang trong bloc
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }
}
// use async method in bloc 
// add values to the stream , call service async method , return results or throw an exception
