// ignore_for_file: prefer_const_constructors, sort_child_properties_last, unused_field, prefer_interpolation_to_compose_strings, use_build_context_synchronously, avoid_print
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/cubit/auth_state.dart';
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
  final bool isLoading = false;
  final AuthRepo _authCubit = AuthRepo();
  final TextStyle title =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white);
  final TextStyle subtitle = TextStyle(
      fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white60);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _passwordVisible = true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthRepo, AuthState>(
      builder: (context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          // backgroundColor: Colors.indigo,
          body: Center(
            child: Stack(
              // textDirection: TextDirection.ltr,
              // fit: StackFit.passthrough,
              children: <Widget>[
                CachedNetworkImage(
                  imageUrl:
                      "https://img.freepik.com/free-photo/reading-concept-vintage-tone-woman-selecting-book-from-bookshelf-portrait-serious-girl-library-looking-book_1391-446.jpg?w=1380&t=st=1683219844~exp=1683220444~hmac=8560bd8320b5411e1d4326cca98e9c833a9f70711772afcd5ff6e6176a203247",
                  width: 600,
                  height: 900,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.6),
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.4, 0.7, 1.0],
                    ),
                  ),
                  // Other properties of the container
                ),
                Positioned(
                  top: 130,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Let's Start!",
                          textAlign: TextAlign.left,
                          style: title,
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            "Manage your books perfectly without hassle",
                            textAlign: TextAlign.left,
                            style: subtitle,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  // left: 10,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(19, 0, 35, 0),
                    child: GlassmorphicContainer(
                      width: 380,
                      height: 400,
                      borderRadius: 9,
                      blur: 20,
                      alignment: Alignment.bottomCenter,
                      border: 2,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF0E0E0E).withOpacity(0.1),
                            Color(0xFF272727).withOpacity(0.05),
                          ],
                          stops: [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF555555).withOpacity(0.5),
                          Color((0xFF353535)).withOpacity(0.5),
                        ],
                      ),
                      child: null,
                    ),
                  ),
                ),
                Positioned(
                  top: 300,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(20),
                    width: 400,
                    child: Material(
                      // elevation: 10.0,
                      borderRadius: BorderRadius.circular(12.0),
                      // shadowColor: Color(0x55434343),
                      child: TextFormField(
                        onChanged: (value) {
                          context.read<AuthRepo>().emailChanged(value);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            // border: OutlineInputBorder(),
                            hintText: "Email"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 360,
                  // left: 10,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    padding: EdgeInsets.all(20),
                    width: 400,
                    child: Material(
                      // elevation: 10.0,
                      borderRadius: BorderRadius.circular(12.0),
                      // shadowColor: Color(0x55434343),
                      child: TextFormField(
                        onChanged: (value) {
                          context.read<AuthRepo>().passwordChanged(value);
                          print(state.password);
                        },
                        obscureText: _passwordVisible,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.password),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passwordVisible = !_passwordVisible;
                                  });
                                },
                                icon: Icon(_passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off)),
                            // border: OutlineInputBorder(),
                            hintText: "Password"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                    top: 500,
                    left: 30,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            width: 300,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    autofocus: true,
                                    onPressed: () {
                                      context
                                          .read<AuthRepo>()
                                          .showLoaderDialog(context);
                                      context
                                          .read<AuthRepo>()
                                          .logIn(context, isLoading);
                                      Navigator.pop(context);
                                    },
                                    child: Text("Login"),
                                    style: ElevatedButton.styleFrom(
                                      //border width and color
                                      elevation: 2, //elevation of button
                                      shape: RoundedRectangleBorder(
                                          //to set border radius to button
                                          borderRadius:
                                              BorderRadius.circular(518)),
                                    )),
                          ),
                          SizedBox(
                            width: 300,
                            child: isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    autofocus: true,
                                    onPressed: () {
                                      context.read<AuthRepo>().anon(context);
                                    },
                                    child: Text("Anonymous"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black87,
                                      //border width and color
                                      elevation: 2, //elevation of button
                                      shape: RoundedRectangleBorder(
                                          //to set border radius to button
                                          borderRadius:
                                              BorderRadius.circular(518)),
                                    )),
                          ),
                          Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 300,
                              child: SignInButton(
                                shape: RoundedRectangleBorder(
                                    //to set border radius to button
                                    borderRadius: BorderRadius.circular(518)),
                                Buttons.Google,
                                onPressed: () async {
                                  setState(() {
                                    isLoading ==
                                        true; // set isLoading to true to show the circular progress indicator
                                  });

                                  try {
                                    final UserCredential userCredential =
                                        await context
                                            .read<AuthRepo>()
                                            .signInWithGoogle();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                "Logged using google ${userCredential.user?.displayName}"),
                                            duration: Duration(seconds: 1)));
                                    // Successfully signed in
                                  } catch (e) {
                                    print("YOUR ERROR IS $e");
                                    // Error signing in
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            backgroundColor: Colors.black,
                                            content: Text("Cancelled : $e"),
                                            duration: Duration(seconds: 5)));
                                    // Successfully
                                  }
                                },
                              )),
                        ],
                      ),
                    )),
                Positioned(
                  top: 450,
                  right: 28,
                  child: RichText(
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
                ),
                Positioned(
                  top: 770,
                  left: 100,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Library Organizer",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.white),
                    ),
                  ),
                ),
                Positioned(
                  top: 810,
                  left: 165,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      "by Lubega & Anas",
                      style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: Colors.white),
                    ),
                  ),
                )
              ],

              // Column(
              //   mainAxisSize: MainAxisSize.max,
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: <Widget>[
              //     Stack(
              //       children: [
              //         Image.asset(
              //           "lib/assets/lib.jpg",
              //           width: 400,
              //           height: 500,
              //           fit: BoxFit.cover,
              //         )
              //       ],
              //     ),
              // Text(
              //   "Let's Start!",
              //   style: title,
              // ),
              // Material(
              //   elevation: 10.0,
              //   borderRadius: BorderRadius.circular(15.0),
              //   shadowColor: Color(0x55434343),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       context.read<AuthRepo>().emailChanged(value);
              //     },
              //     decoration: InputDecoration(
              //         border: OutlineInputBorder(), hintText: "Email"),
              //   ),
              // ),
              // Material(
              //   elevation: 10.0,
              //   borderRadius: BorderRadius.circular(15.0),
              //   shadowColor: Color(0x55434343),
              //   child: TextFormField(
              //     onChanged: (value) {
              //       context.read<AuthRepo>().passwordChanged(value);
              //       print(state.password);
              //     },
              //     obscureText: _passwordVisible,
              //     decoration: InputDecoration(
              //         suffixIcon: IconButton(
              //             onPressed: () {
              //               setState(() {
              //                 _passwordVisible = !_passwordVisible;
              //               });
              //             },
              //             icon: Icon(_passwordVisible
              //                 ? Icons.visibility
              //                 : Icons.visibility_off)),
              //         border: OutlineInputBorder(),
              //         hintText: "Password"),
              //   ),
              // ),
              // RichText(
              //   text: TextSpan(
              //       text: "No Account? ",
              //       style: TextStyle(
              //         color: Colors.white,
              //         fontSize: 18,
              //       ),
              //       children: [
              //         TextSpan(
              //             recognizer: TapGestureRecognizer()
              //               ..onTap = widget.toSignUpPage,
              //             text: 'Sign Up',
              //             style: TextStyle(
              //                 decoration: TextDecoration.underline,
              //                 color: Colors.blue[200]))
              //       ]),
              // ),
              // SizedBox(
              //   width: 200,
              //   child: isLoading
              //       ? CircularProgressIndicator()
              //       : ElevatedButton(
              //           autofocus: true,
              //           onPressed: () {
              //             context
              //                 .read<AuthRepo>()
              //                 .showLoaderDialog(context);
              //             context
              //                 .read<AuthRepo>()
              //                 .logIn(context, isLoading);
              //             Navigator.pop(context);
              //           },
              //           child: Text("Login"),
              //           style: ElevatedButton.styleFrom(
              //             //border width and color
              //             elevation: 2, //elevation of button
              //             shape: RoundedRectangleBorder(
              //                 //to set border radius to button
              //                 borderRadius: BorderRadius.circular(13)),
              //           )),
              // ),
              // SizedBox(
              //   width: 200,
              //   child: isLoading
              //       ? CircularProgressIndicator()
              //       : ElevatedButton(
              //           autofocus: true,
              //           onPressed: () {
              //             context.read<AuthRepo>().anon(context);
              //           },
              //           child: Text("Anonymous"),
              //           style: ElevatedButton.styleFrom(
              //             //border width and color
              //             elevation: 2, //elevation of button
              //             shape: RoundedRectangleBorder(
              //                 //to set border radius to button
              //                 borderRadius: BorderRadius.circular(13)),
              //           )),
              // ),
              // SizedBox(
              //     width: 200,
              //     child: SignInButton(
              //       Buttons.Google,
              //       onPressed: () async {
              //         setState(() {
              //           isLoading ==
              //               true; // set isLoading to true to show the circular progress indicator
              //         });

              //         try {
              //           final UserCredential userCredential = await context
              //               .read<AuthRepo>()
              //               .signInWithGoogle();
              //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //               backgroundColor: Colors.green,
              //               content: Text(
              //                   "Logged using google ${userCredential.user?.displayName}"),
              //               duration: Duration(seconds: 1)));
              //           // Successfully signed in
              //         } catch (e) {
              //           print("YOUR ERROR IS $e");
              //           // Error signing in
              //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //               backgroundColor: Colors.black,
              //               content: Text("Cancelled : $e"),
              //               duration: Duration(seconds: 5)));
              //           // Successfully
              //         }
              //       },
              //     )),
              // ],
            ),
          ),
        );
      },
    );
  }

  // Future logIn() async {
  //   // if (isLoading == true) {

  //   // }
  //   // print(_emailController.text.trim());
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text.trim(),
  //       password: _passwordController.text.trim(),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.green,
  //       content: Text("Successfully Logged as " + _emailController.text.trim()),
  //       duration: Duration(seconds: 1),
  //     ));
  //   } catch (e) {
  //     print("ERROR: $e");
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       backgroundColor: Colors.red,
  //       content: Text("Please input a correct email and password !!"),
  //       duration: Duration(seconds: 3),
  //     ));
  //   }
  //   navigatorKey.currentState!.popUntil((route) => route.isFirst);
  // }

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
}
