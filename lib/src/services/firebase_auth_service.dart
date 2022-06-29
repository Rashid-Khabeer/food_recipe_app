import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class FirebaseAuthService {
  FirebaseAuthService._();

  static final _auth = FirebaseAuth.instance;
  static final _googleSignIn = GoogleSignIn();
  static final _facebookAuth = FacebookAuth.instance;

  static bool get isLogin => _auth.currentUser != null;

  static String get userId => _auth.currentUser?.uid ?? '';

  static Future<UserCredential> signInWithGoogle() async {
    try {
      final _account = await _googleSignIn.signIn();
      final _authentication = await _account!.authentication;
      final _authCredential = GoogleAuthProvider.credential(
        accessToken: _authentication.accessToken,
        idToken: _authentication.idToken,
      );
      final _authResult = await _auth.signInWithCredential(_authCredential);
      return _authResult;
    } catch (e) {
      rethrow;
    }
  }

  static Future<UserCredential> signInWithFacebook() async {
    try {
      final _account = await _facebookAuth.login();
      if (_account.status != LoginStatus.success) {
        throw _account.message ?? 'Facebook Login Failed';
      }
      final _facebookAuthCredential =
          FacebookAuthProvider.credential(_account.accessToken!.token);
      final _authResult =
          await _auth.signInWithCredential(_facebookAuthCredential);
      return _authResult;
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> logout() async{
    await _auth.signOut();
  }
}
