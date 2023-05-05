// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lib_org/Pages/LibraryRack.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/auth_state.dart';
import 'package:lib_org/cubit/firestore_cubit.dart';
import 'package:lib_org/cubit/user_libraries_cubit.dart';
import 'package:lib_org/main.dart';
import 'package:image_picker/image_picker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkModeOn = false;
  File? _chosenimageFile;
  final TextEditingController _displayNameController = TextEditingController();
  String _currentDisplayName = '';
  late Function(String) _setCurrentDisplayName;
  late String displayName;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthRepo>().state.user!;
    displayName = user.displayName ?? '';
    _currentDisplayName = displayName;
    setState(() {});
  }

  void _showEditNameDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Change Display Name"),
          content: TextField(
            controller: _displayNameController,
            decoration: InputDecoration(hintText: "Enter new display name"),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                final newDisplayName = _displayNameController.text.trim();
                if (newDisplayName.isNotEmpty) {
                  final user = context.read<AuthRepo>().state.user!;
                  user.updateDisplayName(newDisplayName).then((_) {
                    setState(() {
                      _currentDisplayName = newDisplayName;
                      _displayNameController.text = _currentDisplayName;
                    });
                    _setCurrentDisplayName(newDisplayName);
                  }).catchError(
                    (error) {
                      Fluttertoast.showToast(
                          msg: "Failed to update display name: $error",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 2,
                          // backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     action: SnackBarAction(
                      //         label: "Dismiss",
                      //         onPressed: () {
                      //           ScaffoldMessenger.of(context)
                      //               .hideCurrentSnackBar();
                      //         }),
                      //     content:
                      //         Text('Failed to update display name: $error'),
                      //   ),
                      // );
                    },
                  );
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                }

                Fluttertoast.showToast(
                    msg: "Changed name to $newDisplayName.",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.TOP,
                    timeInSecForIosWeb: 2,
                    // backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);

                // Navigator.of(context).pop();
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(
                //         builder: (BuildContext context) => super.widget));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthRepo(),
        ),
        BlocProvider(
          create: (context) =>
              UserLibrariesCubit(context.read<AuthRepo>().state),
        ),
      ],
      child: BlocBuilder<AuthRepo, AuthState>(
        builder: (context, state) {
          return Builder(builder: (context) {
            _currentDisplayName = state.user!.displayName ?? '';

            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                automaticallyImplyLeading: false,
                title: Center(child: const Text("User Profile")),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        color: context.watch<ThemeProvider>().isDarkModeOn
                            ? Colors.black12
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Stack(
                                    children: [
                                      _chosenimageFile == null
                                          ? SizedBox(
                                              width: 100,
                                              child: Image.network(
                                                'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png',
                                                width: 100,
                                              ),
                                            )
                                          : SizedBox(
                                              width: 100,
                                              child: Image.file(
                                                _chosenimageFile!,
                                                width: 100,
                                              ),
                                            ),
                                      _chosenimageFile == null
                                          ? GestureDetector(
                                              onTap: () async {
                                                final pickedFile =
                                                    await ImagePicker()
                                                        .pickImage(
                                                            source: ImageSource
                                                                .gallery);
                                                if (pickedFile != null) {
                                                  setState(() {
                                                    _chosenimageFile =
                                                        File(pickedFile.path);
                                                  });
                                                }
                                              },
                                              child: Icon(
                                                Icons.add_photo_alternate,
                                                size: 30,
                                                color: Colors.white,
                                              ))
                                          : Container()
                                      // ElevatedButton(
                                      // onPressed: () async {
                                      //   final pickedFile = await ImagePicker()
                                      //       .pickImage(
                                      //           source: ImageSource.gallery);
                                      //   if (pickedFile != null) {
                                      //     setState(() {
                                      //       _chosenimageFile =
                                      //           File(pickedFile.path);
                                      //     });
                                      //   }
                                      // },
                                      // child: Text('Select Image'),
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              state.user!.displayName
                                                  .toString(),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            GestureDetector(
                                                onTap: _showEditNameDialog,
                                                child: Icon(
                                                  Icons.edit_note,
                                                  size: 30,
                                                ))
                                          ],
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
                                        Container(
                                          width: 200,
                                          child: Text(
                                            "ID: //${state.user!.uid}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
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
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.indigo)),
                          onPressed: () async {
                            final pickedFile = await ImagePicker()
                                .pickImage(source: ImageSource.gallery);
                            if (pickedFile != null) {
                              setState(() {
                                _chosenimageFile = File(pickedFile.path);
                              });
                            }
                          },
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
                                  Text("   Change Profile Photo",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.indigo)),
                          onPressed: () {
                            context.read<ThemeProvider>().isGridEven =
                                !context.read<ThemeProvider>().isGridEven;
                          },
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
                                  Text(
                                      context.watch<ThemeProvider>().isGridEven
                                          ? "   Switch to Triple Grid"
                                          : "   Switch to Double Grid",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ))),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo,
                          ),
                        ),
                        onPressed: () {
                          // setState(() {
                          // isDarkModeOn = !isDarkModeOn;
                          // });
                          context.read<ThemeProvider>().isDarkModeOn =
                              !context.read<ThemeProvider>().isDarkModeOn;
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                context.watch<ThemeProvider>().isDarkModeOn
                                    ? Icons.sunny
                                    : Icons.nightlight_round_sharp,
                                color: Colors.white,
                              ),
                              Text(
                                context.watch<ThemeProvider>().isDarkModeOn
                                    ? "   Light Mode"
                                    : "   Dark Mode",
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Colors.indigo)),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LibraryRackPage()));
                          },
                          child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.storage,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "   Your Library's Rack",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "BETA",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w200,
                                      fontSize: 10,
                                    ),
                                  )
                                ],
                              ))),
                    ),

                    const SizedBox(
                      height: 60,
                    ),
                    // Spacer(),
                    Center(
                        child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Colors.red)),
                            onPressed: () {
                              context.read<AuthRepo>().signOut(context);
                            },
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
              ),
            );
          });
        },
      ),
    );
  }
}
