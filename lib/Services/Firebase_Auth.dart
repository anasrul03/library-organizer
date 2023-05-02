// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Firebase_Auth/SignUp_Page.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool isLogged = true; // change to true if u want to start at login page

  @override
  Widget build(BuildContext context) {
    if (isLogged) {
      return LoginPage(
        toSignUpPage: toggle,
      );
    } else {
      return BlocProvider(
        create: (context) => SignupCubit(authRepo: context.read<AuthRepo>()),
        child: SignUpPage(
          toLoginPage: toggle,
        ),
      );
    }
  }

  // @override
  // Widget build(BuildContext context) => isLogged
  //     ? LoginPage(
  //         toSignUpPage: toggle,
  //       )
  //     : SignUpPage(
  //       toLoginPage: toggle,
  //     );

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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                "'The account already exists with a different credential.'"),
          ));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(
                "'Error occurred while accessing credentials. Try again.'"),
          ));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error occurred using Google Sign-In. Try again."),
        ));
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text("Error Signing Out. Try again."),
      ));
    }
  }
}
