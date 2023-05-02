// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meta/meta.dart';
import '../main.dart';
part 'auth_state.dart';

class AuthRepo {
  // AuthRepo() : super(Null);

  Future signUp(BuildContext context, String email, String password) async {
    print("Running Firebase Create user");
    try {
      final createUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully Registered! as ${email}"),
        backgroundColor: Colors.green,
      ));
      // emit(createUser.user?.email);
    } on FirebaseAuthException catch (e) {
      print("Error : $e");

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Firebase Error!: $e"),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print("Error : $e");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error Catch! >> $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future logIn(BuildContext context, String email, String password) async {
    // if (isLoading == true) {

    // }
    // print(_emailController.text.trim());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully Logged as " + email),
        duration: Duration(seconds: 1),
      ));
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Please input a correct email and password !!"),
        duration: Duration(seconds: 3),
      ));
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future anon(context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Logged Anonymously"),
        duration: Duration(seconds: 1),
      ));
    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Cannot Log! Anon : $e"),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }
}
