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
  List<Items> toRender = [];
  bool isLoading = false;
  String? selectedGenre;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<BookListCubit>(context);
    cubit.fetchBookList(selectedGenre);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        cubit.fetchBookList(selectedGenre);
      }
    });
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
            // Image.network(
            //   'https://cdn.dribbble.com/users/1936570/screenshots/15671618/media/8b5f68528a7089ad95e2cb9a98f3977f.gif',
            //   fit: BoxFit.cover,
            // ),
            const Center(
              child: Baseline(
                baseline: 190,
                baselineType: TextBaseline.alphabetic,
                child: Text(
                  'Lib.Org',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 140,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<String>(
                  hint: const Text('Dicover something new'),
                  value: selectedGenre,
                  onChanged: (String? value) {
                    setState(() {
                      selectedGenre = value!;
                      toRender.clear();
                    });
                    cubit.fetchBookList(selectedGenre!);
                  },
                  items: genre
                      .toSet()
                      .map((genre) => DropdownMenuItem<String>(
                            value: genre,
                            child: Text(genre.replaceAll("+", " ")),
                          ))
                      .toList(),
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookSearchPage(),
                      ),
                    );
                  },
                  child: Row(
                    children: const [
                      Text('Search for an item '),
                      Icon(Icons.search)
                    ],
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
                  isLoading = false;
                } else if (state is BookListError) {
                  return Center(
                    child: Text("Error: ${state.message}"),
                  );
                }
                return GridView.builder(
                  controller: _scrollController,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.6,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                  ),
                  itemCount: toRender.length + (isLoading ? 1 : 0),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == toRender.length) {
                      return Center(
                        child: LoadingAnimationWidget.staggeredDotsWave(
                            color: Colors.indigo, size: 50),
                      );
                    }

                    final Items bookModel = toRender[index];

                    if (toRender.isNotEmpty) {
                      bool showBookCard = false;
                      if (bookModel.volumeInfo.title != null &&
                          bookModel.volumeInfo.imageLinks?.smallThumbnail !=
                              null) {
                        showBookCard = true;
                      }
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
                        child: showBookCard
                            ? Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            bookModel.volumeInfo.imageLinks !=
                                                    null
                                                ? bookModel.volumeInfo
                                                    .imageLinks!.smallThumbnail
                                                : "",
                                        placeholder: (context, url) =>
                                            LoadingAnimationWidget
                                                .staggeredDotsWave(
                                                    color: Colors.indigo,
                                                    size: 50),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        fit: BoxFit.cover,
                                        height: 150,
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        bookModel.volumeInfo.title ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      );
                    }
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
