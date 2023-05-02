// ignore_for_file: prefer_const_constructors

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:lib_org/Pages/Barcode_Page.dart';
import 'package:lib_org/Pages/LibrarySetting_Page.dart';
import 'package:lib_org/Pages/Library_Page.dart';
import 'package:lib_org/Pages/Main_Page.dart';
import 'package:lib_org/Pages/Search_Page.dart';
import 'package:lib_org/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    HomeWidget(),
    LibraryPage(),
    BarcodePage(),
    BookSearchPage(),
    SettingPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      bottomNavigationBar: CurvedNavigationBar(
        key: navigatorKey,
        height: 60,
        color: Colors.grey[900]!,
        buttonBackgroundColor: Colors.grey[900],
        backgroundColor: Colors.indigo,
        items: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.home,
                size: 30,
                color: Colors.white,
              ),
              Text(
                "Home",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.menu_book,
                size: 30,
                color: Colors.white,
              ),
              Text(
                "Library",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.qr_code,
                size: 30,
                color: Colors.white,
              ),
              Text(
                "Scan",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
              Text(
                "Search",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              Text(
                "Profile",
                style: TextStyle(color: Colors.white, fontSize: 8),
              ),
            ],
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          print("Index is $index");
          //Handle button tap
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
