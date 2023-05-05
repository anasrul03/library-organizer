// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Firebase_Auth/SignUp_Page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lib_org/Pages/prefaceLoad.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';

class Authentication extends StatefulWidget {
  final bool firstTime;
  Authentication({super.key, required this.firstTime});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLogged = true; // change to true if u want to start at login page
  bool isFirstTime = true; // change to true if u want to start at login page

  // @override
  // Widget build(BuildContext context) {
  //   if (isLogged && !isFirstTime) {
  //     return LoginPage(
  //       toSignUpPage: toggle,
  //       isBoarded: true,
  //     );
  //   } else if(!isLogged && isFirstTime){

  //     return OnboardingPage(isDone: isFirstTime);
  //   }

  //   else {
  //     return SignUpPage(
  //       toLoginPage: toggle,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) => isLogged
      ? LoginPage(
          toSignUpPage: toggle,
        )
      : SignUpPage(
          toLoginPage: toggle,
        );

  void toggle() => setState(() => isLogged = !isLogged);
}

class GoogleAuth {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Fluttertoast.showToast(
              msg: "The account already exists with a different credential.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
              // backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   action: SnackBarAction(
          //       label: "Dismiss",
          //       onPressed: () {
          //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       }),
          //   backgroundColor: Colors.red,
          //   content: Text(
          //       "'The account already exists with a different credential.'"),
          // ));
        } else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(
              msg: 'Error occurred while accessing credentials. Try again.',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 2,
              // backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   action: SnackBarAction(
          //       label: "Dismiss",
          //       onPressed: () {
          //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
          //       }),
          //   backgroundColor: Colors.red,
          //   content: Text(
          //       "'Error occurred while accessing credentials. Try again.'"),
          // ));
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: 'Error occurred using Google Sign-In. Try again.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 2,
            // backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //   action: SnackBarAction(
        //       label: "Dismiss",
        //       onPressed: () {
        //         ScaffoldMessenger.of(context).hideCurrentSnackBar();
        //       }),
        //   backgroundColor: Colors.red,
        //   content: Text("Error occurred using Google Sign-In. Try again."),
        // ));
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'Error Signing Out. Try again.',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   backgroundColor: Colors.red,
      //   content: Text("Error Signing Out. Try again."),
      // ));
    }
  }
}
