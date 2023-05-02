import 'package:cached_network_image/cached_network_image.dart';
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
  FocusNode _searchFocusNode = FocusNode();

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
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: TextField(
          style: const TextStyle(color: Colors.white),
          focusNode: _searchFocusNode,
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
      body: _searchResults.isEmpty
          ? Center(
              child: Column(
                children: [
                  const Spacer(),
                  CachedNetworkImage(
                    imageUrl:
                        'https://cdn.dribbble.com/users/1785190/screenshots/3906047/search.gif',
                  ),
                  const Text(
                    'Input search query above!',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  const Spacer()
                ],
              ),
            )
          : ListView.builder(
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
                              isbn: book['industryIdentifiers'][0]
                                  ['identifier']),
                        ),
                      ).then((value) {
                        if (value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(value),
                              ),
                              backgroundColor: Colors.indigo,
                            ),
                          );
                        }
                      });
                    },
                    child: ListTile(
                      leading: SizedBox(
                        width: 50,
                        child: book['imageLinks'] != null
                            ? Image.network(book['imageLinks']['thumbnail'])
                            : Container(),
                      ),
                      title: Text(book['title'] ?? ''),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
