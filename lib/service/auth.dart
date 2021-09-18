import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User? get currentUser;
  Stream<User?> authStateChanges();
  Future<User?> signInAnonymous();
  Future<void> signOut();
  Future<User?> signInWithGoogle();
  Future<User?> signInWithFacebook();
  Future<User?> signInWithEmailPassword(String email, String password);
  Future<User?> createUserWithEmailAndPassword(String email, String password);
}

class Auth extends AuthBase {
  // ignore: unused_field
  final _firebaseAuth = FirebaseAuth.instance;
  final _facebookAuth = FacebookAuth.instance;
  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User?> signInAnonymous() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _facebookAuth.logOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<User?> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            code: "Error_Missing_Google_ID_Token",
            message: "Missing Google ID Token");
      }
    } else {
      throw FirebaseAuthException(
          code: "Error_Aborted_By_User", message: "Sign in aborted by user");
    }
  }

  @override
  Future<User?> signInWithEmailPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithCredential(
      EmailAuthProvider.credential(email: email, password: password),
    );
    return userCredential.user;
  }

  @override
  Future<User?> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<User?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login(
      permissions: [
        'public_profile',
        'email',
        'pages_show_list',
        'pages_messaging',
        'pages_manage_metadata'
      ],
    );
    final userData = await _facebookAuth.getUserData();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final facebookAuthCredential =
          FacebookAuthProvider.credential(accessToken.token);
      final userCreadential =
          await _firebaseAuth.signInWithCredential(facebookAuthCredential);
      return userCreadential.user;
    } else if (result.status == LoginStatus.cancelled) {
      throw FirebaseAuthException(
          code: "ERROR_ABORTED_BY_USER", message: "SIGN IN ABORTED BY USER");
    } else if (result.status == LoginStatus.failed) {
      throw FirebaseAuthException(
          code: "ERROR_ABORTED_BY_USER", message: result.message);
    } else {
      throw UnimplementedError();
    }
  }
}
