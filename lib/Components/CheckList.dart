// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:lib_org/Components/Categories.dart';

class CheckListCategories extends StatefulWidget {
  List<String> selectedCategories = [];
  CheckListCategories({
    super.key,
  });
  List<Categories> categoriesList = [
    Categories(title: "Fiction"),
    Categories(title: "Horror"),
    Categories(title: "Gay")
  ];
  @override
  State<CheckListCategories> createState() => _CheckListCategoriesState();
}

class _CheckListCategoriesState extends State<CheckListCategories> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        itemCount: widget.categoriesList.length,
        itemBuilder: (BuildContext context, index) {
          return CheckboxListTile(
            title: Text(widget.categoriesList[index].title),
            value: widget.categoriesList[index].isSelected,
            onChanged: (bool? value) {
              setState(() {
                widget.categoriesList[index].isSelected = value!;
              });

              if (widget.categoriesList[index].isSelected) {
                widget.selectedCategories
                    .add(widget.categoriesList[index].title);
              } else if (!widget.categoriesList[index].isSelected) {
                widget.selectedCategories
                    .remove(widget.categoriesList[index].title);
              }
              print(widget.selectedCategories);
            },
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: Colors.blue,
            checkColor: Colors.white,
          );
        },
      ),
    );
  }
}
