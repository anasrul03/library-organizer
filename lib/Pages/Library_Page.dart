import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/auth_state.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../cubit/firestore_cubit.dart';
import '../main.dart';
import 'BookDetails_Page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirestoreCubit(context.read<AuthRepo>().state),
      child: BlocBuilder<FirestoreCubit, FirestoreState>(
        builder: (context, state) {
          return Scaffold(
            body: BookCard(),
          );
        },
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  const BookCard({Key? key}) : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  final double cardWidth = 120;
  final double cardHeight = 400;
  final int columnNum = 3;
  @override
  void initState() {
    super.initState();
    context.read<FirestoreCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthRepo, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocBuilder<FirestoreCubit, FirestoreState>(
          builder: (context, state) {
            if (state is FirestoreLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FirestoreError) {
              return Center(
                child: Text(
                  state.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (state is FirestoreFetchSuccess) {
              return GridView.builder(
                itemCount: state.bookLibraries.myBooks.length,
                itemBuilder: (context, index) {
                  final book = state.bookLibraries.myBooks[index];
                  final isbn = book['ISBN'];
                  final categories = book['categories'];
                  final imageLinks = book['imageLinks'];
                  final title = book['title'];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BookDetailsPage(isbn: book['ISBN']),
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
                    child: Card(
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                              height: cardHeight,
                              imageUrl: imageLinks,
                              fit: BoxFit.cover),
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [
                                  Colors.black.withOpacity(0.9),
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                stops: const [0.0, 0.4, 0.7, 1.0],
                              ),
                            ),
                            // Other properties of the container
                          ),
                          IconButton(
                            onPressed: () {
                              context.read<FirestoreCubit>().deleteBook(
                                  isbn, imageLinks, categories, title);
                            },
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 2,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              width: cardWidth,
                              height: 55,
                              child: Text(
                                title,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      context.watch<ThemeProvider>().isGridEven ? 2 : 3,
                  childAspectRatio: 0.6,
                  mainAxisSpacing: 0,
                  crossAxisSpacing: 0,
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}



       // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => BookDetailsPage(isbn: isbn),
                      //   ),
                      // );