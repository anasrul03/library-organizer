import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Pages/BookDetails_Page.dart';
import 'package:lib_org/Pages/Search_Page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Services/ApiServices/ApiBookList.dart';
import '../Services/ApiStates/ApiListStates.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  final _scrollController = ScrollController();
  late BookListCubit cubit;
  final _bookList = <Items>[];
  List<Items> toRender = [];
  bool isLoading = false;
  String? selectedGenre;
  final _maxResults = 20;
  int _startIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<BookListCubit>(context);
    cubit.fetchBookList(selectedGenre, _startIndex, _maxResults);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        {
          setState(() {
            isLoading = true;
          });
          cubit.fetchBookList(selectedGenre, _startIndex, _maxResults);
          setState(() {
            _startIndex += _maxResults;
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(children: [
            CachedNetworkImage(
              imageUrl:
                  "https://cdn.dribbble.com/users/1936570/screenshots/15671618/media/8b5f68528a7089ad95e2cb9a98f3977f.gif",
              placeholder: (context, url) =>
                  LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.indigo, size: 50),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const Center(
              child: Baseline(
                baseline: 190,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'Lib.Org',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 120,
                  ),
                ),
              ),
            ),
            const Center(
              child: Baseline(
                baseline: 230,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'Manage your personal library with ease!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ]),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  hint: const Text('Discover something new'),
                  value: selectedGenre,
                  onChanged: (String? value) {
                    setState(() {
                      selectedGenre = value!;
                      toRender.clear();
                    });
                    cubit.fetchBookList(
                        selectedGenre, _startIndex, _maxResults);
                  },
                  items: genre
                      .toSet()
                      .map((genre) => DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre.replaceAll("+", " ")),
                          ))
                      .toList(),
                ),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.indigo),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookSearchPage(),
                        ),
                      );
                    },
                    child: const Icon(Icons.search, size: 30),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<BookListCubit, BookListStates>(
              bloc: cubit,
              builder: ((context, state) {
                if (state is BookListLoading && toRender.isEmpty) {
                  return Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.indigo, size: 80),
                  );
                }
                if (state is BookListLoaded) {
                  toRender.addAll(state.apiBookList.items);
                  if (_startIndex >= state.apiBookList.totalItems) {
                    _startIndex = 0;
                  }
                  isLoading = false;
                } else if (state is BookListError) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                if (toRender.isNotEmpty) {
                  if (toRender.contains('ISBN_13') ||
                      toRender.contains('ISBN_10')) {
                    toRender.removeWhere((item) =>
                        item.volumeInfo.industryIdentifiers[0].type !=
                            'ISBN_13' &&
                        item.volumeInfo.industryIdentifiers[0].type !=
                            'ISBN_10');
                  }
                }

                if (toRender.isEmpty) {
                  return const Center(child: Text('No books found.'));
                }
                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    crossAxisSpacing: 2,
                  ),
                  itemCount: toRender.length + (isLoading ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (toRender.isNotEmpty) {
                      if (index == toRender.length) {
                        return Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.indigo, size: 50),
                        );
                      }
                      final Items bookModel = toRender[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookDetailsPage(
                                    isbn: bookModel.volumeInfo
                                        .industryIdentifiers[0].identifier),
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
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: bookModel.volumeInfo.imageLinks!
                                        .smallThumbnail ??
                                    '',
                                placeholder: (context, url) =>
                                    LoadingAnimationWidget.staggeredDotsWave(
                                        color: Colors.indigo, size: 50),
                                errorWidget: (context, url, error) =>
                                    FadeInImage.assetNetwork(
                                  placeholder:
                                      'https://islandpress.org/sites/default/files/default_book_cover_2015.jpg',
                                  image:
                                      'https://islandpress.org/sites/default/files/default_book_cover_2015.jpg',
                                  fit: BoxFit.cover,
                                ),
                                // fit: BoxFit.cover,
                                height: 160,
                                width: 120,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                bookModel.volumeInfo.title ?? "",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54),
                              ),
                            ],
                          ));
                    }
                    return null;
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
