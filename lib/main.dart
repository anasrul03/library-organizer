// ignore_for_file: prefer_const_constructors, avoid_print, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Components/navigationDummy.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Firebase_Auth/SignUp_Page.dart';
import 'package:lib_org/Pages/BookDetails_Page.dart';
import 'package:lib_org/Pages/LibrarySetting_Page.dart';
import 'package:lib_org/Services/ApiStates/ApiDetailsStates.dart';
import 'package:lib_org/Pages/Home_Page.dart';
import 'package:lib_org/Services/ApiStates/ApiListStates.dart';
import 'package:lib_org/Services/Firebase_Auth.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/firestore_cubit.dart';
import 'package:lib_org/cubit/signup_cubit.dart';
import 'package:lib_org/cubit/user_libraries_cubit.dart';
import 'package:lib_org/firebase_options.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Pages/prefaceLoad.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: "lib/API_KEY.env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MyApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkModeOn = false;

  bool get isDarkModeOn => _isDarkModeOn;

  bool _isGridEven = false;

  bool get isGridEven => _isGridEven;

  // void toggleTheme() {
  //   _isDarkModeOn = !_isDarkModeOn;
  //   notifyListeners();
  // }
  set isDarkModeOn(bool value) {
    _isDarkModeOn = value;
    notifyListeners();
  }

  set isGridEven(bool value) {
    _isGridEven = value;
    notifyListeners();
  }
}

Future<void> requestPermission() async {
  final status = await Permission.storage.request();
  if (status.isDenied) {
    print(status.index);
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepo(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) {
              return BookListCubit();
            },
          ),
          BlocProvider(
            create: (BuildContext context) {
              return SignupCubit(authRepo: context.read<AuthRepo>());
            },
          ),
          BlocProvider(
            create: (BuildContext context) {
              return BookDetailsCubit();
            },
          ),
          BlocProvider(
            create: (BuildContext context) {
              return FirestoreCubit(context.read<AuthRepo>().state);
            },
          ),
          BlocProvider(create: (BuildContext context) {
            return UserLibrariesCubit(context.read<AuthRepo>().state);
          })
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: context.watch<ThemeProvider>().isDarkModeOn
                ? ThemeMode.dark
                : ThemeMode.light,
            title: 'Flutter Demo',
            home: MyHomePage(title: "bega n anas")),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  setUserId(String? userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   // Try reading data from the 'action' key. If it doesn't exist, returns null.
    prefs.setString('userId', userId!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        //Validating the user email & password
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Something went wrong!"));
          } else if (snapshot.hasData) {
            print("Directing to Homepage");
            print("User id is " + snapshot.data!.uid);

            // log(snapshot.data!.uid);
            // Store userId in local Phone Storage
            // setUserId(snapshot.data!.uid);
            return HomePage();
          } else {
            print("Re-directing to AuthPage");
            double width = MediaQuery.of(context).size.width;
            print("the width is $width");
            return Authentication(
              firstTime: true,
            );
          }
        },
      ),
    );
  }
}
