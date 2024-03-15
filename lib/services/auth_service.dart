import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._privateConstructor();
  static final AuthService instance = AuthService._privateConstructor();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final User? firebaseUser = userCredential.user;
      if (firebaseUser != null) {
        return {'success': true, 'message': 'Welcome user'};
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        return {
          'success': false,
          'message': 'The email address is badly formatted.'
        };
      } else if (e.code == 'invalid-credential') {
        return {
          'success': false,
          'message': 'The supplied auth credential is malformed or has expired.'
        };
      }

      rethrow;
    }

    return {'success': false};
  }

  Future<Map<String, dynamic>> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
      return {'success': true, 'message': 'Correctly disconnected.'};
    } catch (e) {
      return {'success': false, 'message': 'Something went wrong.'};
    }
  }
}
