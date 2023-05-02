import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Pages/BookDetails_Page.dart';
import 'package:lib_org/Pages/Search_Page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Services/ApiServices/ApiBookList.dart';
import '../Services/ApiStates/ApiListStates.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => LibraryState();
}

class LibraryState extends State<LibraryPage> {
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
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        automaticallyImplyLeading: false,
        title: const Center(child: Text("User Library")),
      ),
      body: Column(
        children: [
          //PLACEHOLDER
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

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(
                                isbn: bookModel.volumeInfo
                                    .industryIdentifiers[0].identifier),
                          ),
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                imageUrl: bookModel
                                    .volumeInfo.imageLinks.smallThumbnail,
                                placeholder: (context, url) =>
                                    LoadingAnimationWidget.staggeredDotsWave(
                                        color: Colors.indigo, size: 50),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                                height: 150,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                bookModel.volumeInfo.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
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
