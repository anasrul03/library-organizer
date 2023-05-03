import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lib_org/Pages/BookDetails_Page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const _maxResultsPerPage = 40;
String apiKey = dotenv.env['API_KEY']!;

class BookSearchPage extends StatefulWidget {
  @override
  _BookSearchPageState createState() => _BookSearchPageState();
}

class _BookSearchPageState extends State<BookSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';
  List<dynamic> _searchResults = [];
  final FocusNode _searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  int _startIndex = 0;
  bool _isLoading = false;

  Future<void> _searchBooks(String searchTerm, int startIndex) async {
    String apiUrl =
        "https://www.googleapis.com/books/v1/volumes?q=$searchTerm&startIndex=$startIndex&maxResults=$_maxResultsPerPage&key=$apiKey";
    http.Response response = await http.get(Uri.parse(apiUrl));
    Map<String, dynamic> responseJson = json.decode(response.body);
    List<dynamic> newResults = responseJson['items'] ?? [];
    setState(() {
      if (startIndex == 0) {
        _searchResults = newResults;
      } else {
        _searchResults.addAll(newResults);
      }
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _searchFocusNode.requestFocus();
    _searchBooks(_searchTerm, _startIndex);
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.position.pixels) {
        // if (!_isLoading) {
        //   setState(() {
        //     _isLoading = true;
        //     _startIndex += _maxResultsPerPage;
        //   });
        //   _searchBooks(_searchTerm, _startIndex);
        // }

        {
          setState(() {
            _isLoading = true;
          });
          _searchBooks(_searchTerm, _startIndex);
          setState(() {
            _startIndex += _maxResultsPerPage;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
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
            _searchBooks(_searchTerm, _startIndex);
          },
        ),
      ),
      body: _searchResults.isEmpty
          ? SingleChildScrollView(
              child: Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
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
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _searchResults.length + (_isLoading ? 1 : 0),
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> book = _searchResults[index]['volumeInfo'];
                if (book['industryIdentifiers'] != null &&
                    book['industryIdentifiers'][0]['identifier'] != null &&
                    book['industryIdentifiers'][0]['type'] != 'OTHER' &&
                    _searchResults[index]['volumeInfo'] != <String>[] &&
                    _searchResults[index]['volumeInfo'] != <String>[]) {
                  if (index == _searchResults.length) {
                    return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.indigo, size: 50),
                    );
                  }
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
                              ? CachedNetworkImage(
                                  imageUrl:
                                      book['imageLinks']['thumbnail'] ?? '',
                                  placeholder: (context, url) =>
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colors.indigo, size: 30),
                                  errorWidget: (context, url, error) =>
                                      FadeInImage.assetNetwork(
                                    placeholder:
                                        'https://islandpress.org/sites/default/files/default_book_cover_2015.jpg',
                                    image:
                                        'https://islandpress.org/sites/default/files/default_book_cover_2015.jpg',
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(),
                        ),
                        title: Text(book['title'] ?? ''),
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
    );
  }
}
