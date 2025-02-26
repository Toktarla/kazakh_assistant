import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:proj_management_project/utils/error/error_handler.dart';
import 'package:proj_management_project/utils/helpers/snackbar_helper.dart';

import '../../../config/variables.dart' show defaultUserPhotoUrl;
import '../repositories/authentication_repository.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AuthenticationRepository _authRepository;
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  User? _user;
  User? get user => _user;

  AuthenticationProvider(this._authRepository, this.googleSignIn, this.firebaseAuth, this.firebaseFirestore);

  Future<void> signIn(String email, String password, BuildContext context) async {
    try {
      _user = await _authRepository.signIn(email, password);
      if (_user != null) {
        Navigator.pushNamedAndRemoveUntil(context, "/StreakTracker", arguments: {
          "userId": _user!.uid,
        }, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      ErrorHandler.handleAuthError(e);
    } catch (e) {
      SnackbarHelper.showErrorSnackbar(message: "An error occurred: $e");
    }
  }

  Future<void> signUp(String email, String password, String confirmPassword, String fullName, BuildContext context) async {
    try {
      if (password == confirmPassword) {
        _user = await _authRepository.signUp(email, password, fullName);
        if (_user != null) {
          Navigator.pushNamedAndRemoveUntil(context, "/VerifyEmail", (route) => false);
        }
      } else {
        SnackbarHelper.showErrorSnackbar(message: "Passwords don't match");
      }
    } on FirebaseAuthException catch (e) {
      ErrorHandler.handleAuthError(e);
    } catch (e) {
      SnackbarHelper.showErrorSnackbar(message: "An error occurred: $e");
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      await googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCred = await firebaseAuth.signInWithCredential(credential);

      _user = userCred.user;
      final userDoc = await firebaseFirestore.collection('users').doc(_user!.uid).get();

      if (!userDoc.exists) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();

        await firebaseFirestore.collection('users').doc(_user!.uid).set({
          'addtime': Timestamp.now(),
          'email': _user!.email,
          'fcmToken': fcmToken ?? '',
          'userId': _user!.uid,
          'streakCount': 1,
          'name': _user!.displayName,
          'photoUrl': _user!.photoURL ?? defaultUserPhotoUrl,
        });
      }
      else {
        if (userDoc['name'] != _user!.displayName &&
            userDoc['photoUrl'] != _user!.photoURL &&
            userDoc['email'] != _user!.email) {
          await userDoc.reference.update({
            'name': _user!.displayName,
            'photoUrl': _user!.photoURL ?? defaultUserPhotoUrl,
            'email': _user!.email,
          });
        }
      }
      Navigator.pushNamedAndRemoveUntil(context, "/StreakTracker", arguments: {
        "userId": _user!.uid,
      }, (route) => false);

      notifyListeners();
    } on Exception catch (e) {
      print("ERROR ${e}");
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _authRepository.signOut();
      _user = null;
      Navigator.pushNamedAndRemoveUntil(context, "/Login", (route) => false);
    } catch (e) {
      print("Error during sign-out: $e");
    }
  }
}
