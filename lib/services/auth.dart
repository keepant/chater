import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User _user;

  Future<User> registerUser(
      String email, String password, String displayName) async {
    try {
      User user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ))
          .user;
      _user = user;
      user.updateProfile(displayName: displayName);
    } catch (e) {
      print(e);
    }
    return _user;
  }

  Future<User> signInWithEmail(String email, String password) async {
    String errorMessage;
    User _user;

    try {
      User user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      _user = user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "invalid-email":
          errorMessage = e.message;
          break;
        case "wrong-password":
          errorMessage = e.message;
          break;
        case "user-not-found":
          errorMessage = e.message;
          break;
        default:
          errorMessage = "An undefined Error happened";
      }
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return _user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }
}

Auth auth = Auth();
