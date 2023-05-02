// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_field, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/main.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../cubit/auth_cubit.dart';

class LoginPage extends StatefulWidget {
  VoidCallback? toSignUpPage;
  LoginPage({super.key, this.toSignUpPage});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthRepo _authCubit = AuthRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Container(
        padding: EdgeInsets.all(15),
        margin: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Text("Login Page"),
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(15.0),
                  shadowColor: Color(0x55434343),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: "Email"),
                  ),
                ),
                Material(
                  elevation: 10.0,
                  borderRadius: BorderRadius.circular(15.0),
                  shadowColor: Color(0x55434343),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            icon: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off)),
                        border: OutlineInputBorder(),
                        hintText: "Password"),
                  ),
                ),
                RichText(
                  text: TextSpan(
                      text: "No Account? ",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      children: [
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = widget.toSignUpPage,
                            text: 'Sign Up',
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue[200]))
                      ]),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      autofocus: true,
                      onPressed: logIn,
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        //border width and color
                        elevation: 2, //elevation of button
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(13)),
                      )),
                ),
                SizedBox(
                  width: 200,
                  child: ElevatedButton(
                      autofocus: true,
                      onPressed: anon,
                      child: Text("Anonymous"),
                      style: ElevatedButton.styleFrom(
                        //border width and color
                        elevation: 2, //elevation of button
                        shape: RoundedRectangleBorder(
                            //to set border radius to button
                            borderRadius: BorderRadius.circular(13)),
                      )),
                ),
                SizedBox(
                    width: 200,
                    child: SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        try {
                          final UserCredential userCredential =
                              await signInWithGoogle();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green,
                              content: Text(
                                  "Logged using google ${userCredential.user?.displayName}"),
                              duration: Duration(seconds: 1)));
                          // Successfully signed in
                        } catch (e) {
                          print("YOUR ERROR IS $e");
                          // Error signing in
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.black,
                              content: Text("Cancelled : $e"),
                              duration: Duration(seconds: 5)));
                          // Successfully
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future logIn() async {
    // if (isLoading == true) {

    // }
    // print(_emailController.text.trim());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text("Successfully Logged as " + _emailController.text.trim()),
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

  Future anon() async {
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
