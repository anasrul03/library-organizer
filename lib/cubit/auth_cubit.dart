// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart';
import 'auth_state.dart';

class AuthRepo extends Cubit<AuthState> {
  AuthRepo() : super(AuthState.initial()) {
    checkSignin();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: AuthStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: AuthStatus.initial));
  }

  Future<void> checkSignin() async {
    final User? user = _auth.currentUser;

    if (user != null) {
      emit(state.copyWith(user: user));
    }
  }

  Future signUp(BuildContext context, String email, String password) async {
    print("Running Firebase Create user");
    try {
      final createUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Fluttertoast.showToast(
          msg: "Successfully Registered! as ${email}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Successfully Registered! as ${email}"),
      //   backgroundColor: Colors.green,
      // ));
      // emit(createUser.user?.email);
    } on FirebaseAuthException catch (e) {
      print("Error : $e");

      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }

      Fluttertoast.showToast(
          msg: "Firebase Error!: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Firebase Error!: $e"),
      //   backgroundColor: Colors.red,
      // ));
    } catch (e) {
      print("Error : $e");
      Fluttertoast.showToast(
          msg: "Error Catch! >> $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text("Error Catch! >> $e"),
      //   backgroundColor: Colors.red,
      // ));
    }
  }

  Future logIn(BuildContext context, bool loaded) async {
    try {
      var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email,
        password: state.password,
      );
      emit(state.copyWith(user: user.user));
      print(user);
      Fluttertoast.showToast(
          msg: "Successfully Logged as ${state.email}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   backgroundColor: Colors.green,
      //   content: Text("Successfully Logged as " + state.email),
      //   duration: Duration(seconds: 1),
      // ));
    } catch (e) {
      print("ERROR: $e");
      Fluttertoast.showToast(
          msg: "Please input a correct email and password !!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   backgroundColor: Colors.red,
      //   content: Text("Please input a correct email and password !!"),
      //   duration: Duration(seconds: 3),
      // ));
    }
    loaded = false;
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signOut(BuildContext context) async {
    try {
      GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();
      emit(state.copyWith(email: "", password: "", status: AuthStatus.initial));
      Fluttertoast.showToast(
          msg: "Logged out",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   duration: Duration(seconds: 1),
      //   content: Text("Logged out"),
      //   backgroundColor: Colors.grey,
      // ));
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(
          msg: "Error Catch! >> $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   duration: Duration(seconds: 6),
      //   content: Text("Firebase Error: $e"),
      //   backgroundColor: Colors.red,
      // ));
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Catch! >> $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   duration: Duration(seconds: 6),
      //   content: Text("Error: $e"),
      //   backgroundColor: Colors.red,
      // ));
    }
  }

  Future anon(context) async {
    try {
      var user = await FirebaseAuth.instance.signInAnonymously();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   backgroundColor: Colors.green,
      //   content: Text("Logged Anonymously"),
      //   duration: Duration(seconds: 1),
      // ));
      Fluttertoast.showToast(
          msg: "Sign in as Anon",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      emit(state.copyWith(user: user.user));
    } catch (e) {
      print("ERROR: $e");
      Fluttertoast.showToast(
          msg: "Cannot Log! Anon : $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   showCloseIcon: true,
      //   backgroundColor: Colors.red,
      //   content: Text("Cannot Log! Anon : $e"),
      //   duration: Duration(seconds: 3),
      // ));
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

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
