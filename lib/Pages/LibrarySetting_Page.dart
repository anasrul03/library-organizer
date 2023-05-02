// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/auth_state.dart';
import 'package:lib_org/cubit/firestore_cubit.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthRepo, AuthState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.indigo,
            automaticallyImplyLeading: false,
            title: Center(child: const Text("User Profile")),
          ),
          body: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                              height: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    state.user!.displayName.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    state.user!.email.toString(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Your ID is ${state.user!.uid.toString()}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.indigo)),
                    onPressed: null,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            Text("   Profile Settings",
                                style: TextStyle(color: Colors.white))
                          ],
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.indigo)),
                    onPressed: null,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book,
                              color: Colors.white,
                            ),
                            Text("   Library Settings",
                                style: TextStyle(color: Colors.white))
                          ],
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.indigo)),
                    onPressed: null,
                    child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.settings,
                              color: Colors.white,
                            ),
                            Text("   Application Settings",
                                style: TextStyle(color: Colors.white))
                          ],
                        ))),
              ),
              Spacer(),
              Center(
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.red)),
                      onPressed: signOut,
                      child: Container(
                          width: 200,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout),
                              Text("   Log out dude",
                                  style: TextStyle(color: Colors.white))
                            ],
                          )))),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        );
      },
    );
  }

  Future signOut() async {
    try {
      GoogleSignIn().disconnect();
      await FirebaseAuth.instance.signOut();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        content: Text("Logged out"),
        backgroundColor: Colors.grey,
      ));
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 6),
        content: Text("Firebase Error: $e"),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 6),
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }
}
