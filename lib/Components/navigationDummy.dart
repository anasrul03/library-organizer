import 'package:flutter/material.dart';
import 'package:lib_org/Firebase_Auth/Login_Page.dart';
import 'package:lib_org/Pages/BookDetails_Page.dart';
import 'package:lib_org/main.dart';

import '../Pages/Barcode_Page.dart';

class NavigateDummy extends StatelessWidget {
  const NavigateDummy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dummy navigation page"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => MyHomePage(
                            title: 'home',
                          ))));
                },
                child: Text("LoginPage")),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => BarcodePage())));
                },
                child: Text("BookDetails")),
          ],
        ),
      ),
    );
  }
}
