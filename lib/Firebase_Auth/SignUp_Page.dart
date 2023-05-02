// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, avoid_print, must_be_immutable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';

import 'SignUp_Cubit.dart';

class SignUpPage extends StatefulWidget {
  VoidCallback? toLoginPage;
  SignUpPage({super.key, this.toLoginPage});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return SignUpWidget(
      clickToggle: widget.toLoginPage,
    );
  }
}

class SignUpWidget extends StatefulWidget {
  VoidCallback? clickToggle;
  // final Function(String)? onChanged;
  SignUpWidget({super.key, this.clickToggle});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          backgroundColor: Colors.indigo,
          body: Container(
            margin: EdgeInsets.all(20),
            child: Card(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text("Sign Up"),
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
                      shadowColor: Color(0x55434343),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<SignupCubit>().emailChanged(value);
                          print(state.email);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            hintText: "Email"),
                      ),
                    ),
                    Material(
                      elevation: 10.0,
                      borderRadius: BorderRadius.circular(15.0),
                      shadowColor: Color(0x55434343),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters long';
                          } else if (!RegExp(
                                  r'(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])')
                              .hasMatch(value)) {
                            return 'Password must contain at least one uppercase letter, one lowercase letter, and one number';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          context.read<SignupCubit>().passwordChanged(value);
                          print(state.password);
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                            hintText: "Password"),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ElevatedButton(
                          autofocus: true,
                          onPressed: () {
                            context
                                .read<SignupCubit>()
                                .signupWithCredentials(context);
                          },
                          child: Text("Sign Up"),
                          style: ElevatedButton.styleFrom(
                            //border width and color
                            elevation: 2, //elevation of button
                            shape: RoundedRectangleBorder(
                                //to set border radius to button
                                borderRadius: BorderRadius.circular(13)),
                          )),
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
                                  ..onTap = widget.clickToggle,
                                text: 'Login',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue[200]))
                          ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Future signUp() async {
  //   try {
  //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //         email: _emailController.text.trim(),
  //         password: _passwordController.text.trim());
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Successfully Registered!"),
  //       backgroundColor: Colors.green,
  //     ));
  //   } on FirebaseAuthException catch (e) {
  //     print("Error : $e");

  //     if (e.code == 'weak-password') {
  //       print('The password provided is too weak.');
  //     } else if (e.code == 'email-already-in-use') {
  //       print('The account already exists for that email.');
  //     }
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Firebase Error!: $e"),
  //       backgroundColor: Colors.red,
  //     ));
  //   } catch (e) {
  //     print("Error : $e");

  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text("Error Catch! >> $e"),
  //       backgroundColor: Colors.red,
  //     ));
  //   }
  // }
}
