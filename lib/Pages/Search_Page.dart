import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lib_org/Pages/BookDetails_Page.dart';

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  List<dynamic> _searchResults = [];

  Future<void> _searchBooks(String searchTerm) async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$searchTerm&key=AIzaSyD-LCZdBsMhtcGdBkKMR0wK3ZXEy9KJ11M";
    http.Response response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> responseJson = json.decode(response.body);
    setState(() {
      _searchResults = responseJson['items'];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search Books...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (String value) {
            setState(() {
              _searchTerm = value;
            });
          },
          onSubmitted: (String value) {
            setState(() {
              _searchTerm = value;
            });
            _searchBooks(_searchTerm);
          },
        ),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: _searchResults.length,
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic> book = _searchResults[index]['volumeInfo'];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsPage(
                          isbn: book['industryIdentifiers'][0]['identifier']),
                    ),
                  );
                },
                child: ListTile(
                  leading: book['imageLinks'] != null
                      ? Image.network(book['imageLinks']['thumbnail'])
                      : Container(),
                  title: Text(book['title'] != null ? book['title'] : ''),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
