// ignore_for_file: prefer_const_constructors, sort_child_properties_last, use_build_context_synchronously, avoid_print, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';
import 'package:lib_org/cubit/user_libraries_cubit.dart';

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
  final TextStyle title =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 60, color: Colors.white);
  final TextStyle subtitle = TextStyle(
      fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white60);
  late UserLibrariesCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = BlocProvider.of<UserLibrariesCubit>(context);
    cubit.fetchUserLibraries("myRack");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserLibrariesCubit, UserLibrariesState>(
      bloc: cubit,
      builder: (context, state) {
        return BlocBuilder<SignupCubit, SignupState>(
          builder: (BuildContext context, state) {
            return Scaffold(
              body: Center(
                  child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        "https://img.freepik.com/free-photo/library-with-books_1063-98.jpg?w=1380&t=st=1683220121~exp=1683220721~hmac=5f7fb527cf7cec5dc4744a201fc067e0d447bdc1dd8916bb787e5de7d95037dd",
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
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Join us!",
                            style: title,
                          ),
                          Text(
                            "Register and ready to be productive!",
                            style: subtitle,
                          ),
                          Column(
                            children: [
                              Material(
                                elevation: 10.0,
                                borderRadius: BorderRadius.circular(12.0),
                                shadowColor: Color(0x55434343),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your email';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    context
                                        .read<SignupCubit>()
                                        .emailChanged(value);
                                    print(state.email);
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(),
                                      hintText: "Email"),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Material(
                                elevation: 10.0,
                                borderRadius: BorderRadius.circular(12.0),
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
                                    context
                                        .read<SignupCubit>()
                                        .passwordChanged(value);
                                    print(state.password);
                                  },
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.lock),
                                      border: OutlineInputBorder(),
                                      hintText: "Password"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 300,
                            height: 50,
                            child: ElevatedButton(
                                autofocus: true,
                                onPressed: () {
                                  context
                                      .read<SignupCubit>()
                                      .signupWithCredentials(context);
                                  context
                                      .read<UserLibrariesCubit>()
                                      .addDefaultRack();
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(fontSize: 20),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  //border width and color
                                  elevation: 2, //elevation of button
                                  shape: RoundedRectangleBorder(
                                      //to set border radius to button
                                      borderRadius: BorderRadius.circular(13)),
                                )),
                          ),
                          RichText(
                            text: TextSpan(
                                text: "Already have an account? ",
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
                ],
              )),
            );
          },
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
