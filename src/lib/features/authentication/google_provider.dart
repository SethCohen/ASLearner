import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  GoogleSignInProvider({GoogleSignIn? googleSignIn, FirebaseAuth? auth})
      : _googleSignIn = googleSignIn ?? GoogleSignIn(),
        _auth = auth ?? FirebaseAuth.instance {
    _user = _auth.currentUser;
  }

  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _auth;

  User? _user;

  User? get user => _user;

  Future<void> googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser != null) {
        final User? user = await signInWithGoogle(googleUser);
        if (user != null) {
          _user = user;
          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> googleLogout() async {
    try {
      await _googleSignIn.disconnect();
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<void> deleteUser() async {
    try {
      await _user!.delete();
      await _googleSignIn.disconnect();
      await _auth.signOut();
      _user = null;
      notifyListeners();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  Future<User?> signInWithGoogle(GoogleSignInAccount googleUser) async {
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User? user = authResult.user;

    return user;
  }
}
