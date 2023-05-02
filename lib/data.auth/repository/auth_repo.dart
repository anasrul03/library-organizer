// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../listeners/auth_signup_listener.dart';

class AuthRepository {
  void registerUser(
      {required String email,
      required String password,
      required AuthSigUpListener authSignUpListener}) async {
    var authInstance = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await authInstance
          .createUserWithEmailAndPassword(email: email, password: password);
      userCredential.user!.sendEmailVerification();
      authInstance.signOut();
      authSignUpListener.success();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        authSignUpListener.weakPassword();
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        authSignUpListener.userExists();
      }
    } catch (e) {
      print(e);
      authSignUpListener.failed();
    }
  }
}
