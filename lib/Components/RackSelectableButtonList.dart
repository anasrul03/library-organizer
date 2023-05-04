// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RackSelectableButtonList extends StatefulWidget {
  const RackSelectableButtonList({Key? key}) : super(key: key);

  @override
  _RackSelectableButtonListState createState() =>
      _RackSelectableButtonListState();
}

class _RackSelectableButtonListState extends State<RackSelectableButtonList> {
  String? selectedValue;

  final List<String> _values = ['Value 1', 'Value 2', 'Value 3', 'Value 4'];

  @override
  void initState() {
    super.initState();
    selectedValue = _values[0];
    // Set the first value as the default selected value
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (String value in _values)
            ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedValue = value;
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: selectedValue == value ? 0 : 3.0,
                      color: Colors.indigo,
                    ),
                    borderRadius: BorderRadius.circular(20)),
                backgroundColor: selectedValue == value
                    ? Colors.indigo
                    : Colors.grey.shade300,
              ),
              child: Text(
                value,
                style: TextStyle(
                  color: selectedValue == value
                      ? Colors.white
                      : Colors.indigo[400],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
