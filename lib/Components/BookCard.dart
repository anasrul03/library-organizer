import 'package:flutter/material.dart';
import 'package:lib_org/Services/ApiServices/ApiBookList.dart';

class BookCard extends StatelessWidget {
  const BookCard({required this.bookModel, Key? key}) : super(key: key);
  final ApiBookList bookModel;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Image.network(
              bookModel.items[1].volumeInfo.imageLinks.smallThumbnail),
          Text(bookModel.items[1].volumeInfo.title)
        ],
      ),
    ));
  }
}
