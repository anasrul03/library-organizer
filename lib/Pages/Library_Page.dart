import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../cubit/firestore_cubit.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<FirestoreCubit>().fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FirestoreCubit, FirestoreState>(
      listener: (context, state) {
        if (state is FirestoreError) {}

        if (state is FirestoreSuccess) {}
      },
      child: BlocBuilder<FirestoreCubit, FirestoreState>(
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

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(isbn: isbn),
                      ),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            imageUrl: imageLinks,
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
                            isbn,
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.6,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
