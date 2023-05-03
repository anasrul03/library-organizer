// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Services/ApiStates/ApiDetailsStates.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/auth_state.dart';
import 'package:lib_org/cubit/firestore_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../Services/ApiServices/ApiBookDetails.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BookDetailsPage extends StatefulWidget {
  final String isbn;

  const BookDetailsPage({Key? key, required this.isbn}) : super(key: key);

  @override
  BookDetailsState createState() => BookDetailsState();
}

class BookDetailsState extends State<BookDetailsPage> {
  // final itemsCubit = ItemsCubit();
  late BookDetailsCubit cubit;
  List<Items> toRender = [];
  bool isAnon = false;
  List<String> itemList = ['Flutter', 'Javascript', 'React'];

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<BookDetailsCubit>(context);
    cubit.fetchBookDetails(widget.isbn);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Details'),
        backgroundColor: Colors.indigo,
      ),
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FirestoreCubit(context.read<AuthRepo>().state),
          ),
          BlocProvider(
            create: (context) => AuthRepo(),
          ),
        ],
        child: BlocBuilder<BookDetailsCubit, BookDetailsStates>(
            bloc: cubit,
            builder: (context, state) {
              if (state is BookDetailsLoading && toRender.isEmpty) {
                return Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.indigo, size: 80),
                );
              }
              if (state is BookDetailsLoaded) {
                toRender.addAll(state.apiBookDetails.items);
              }
              if (toRender.isNotEmpty) {
                final Items bookModel = toRender[0];
                bool showRatingBar = false;
                if (bookModel.volumeInfo?.averageRating != null) {
                  showRatingBar = true;
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: bookModel.volumeInfo?.imageLinks
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
                                    height: 150,
                                  ),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 200,
                                ),
                                const SizedBox(height: 6),
                                Text('ISBN: //${widget.isbn}'),
                                const SizedBox(height: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      toRender.isNotEmpty
                                          ? bookModel.volumeInfo!.title
                                          : '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const SizedBox(height: 10),
                                    Container(
                                      child: showRatingBar
                                          ? RatingBar.builder(
                                              initialRating: bookModel
                                                  .volumeInfo?.averageRating!
                                                  .toDouble(),
                                              minRating: 0,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 1),
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {},
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      toRender.isNotEmpty
                                          ? 'Author: ${(bookModel.volumeInfo?.authors.join(', '))}'
                                          : '',
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      toRender.isNotEmpty
                                          ? 'Categories: ${(bookModel.volumeInfo?.categories.join(', '))}'
                                          : '',
                                    ),
                                    const SizedBox(height: 20),
                                    Text(toRender.isNotEmpty
                                        ? 'Book Publisher: ${bookModel.volumeInfo?.publisher}'
                                        : ''),
                                    const SizedBox(height: 20),
                                    Text(toRender.isNotEmpty
                                        ? 'Date of Publish: ${bookModel.volumeInfo?.publishedDate}'
                                        : ''),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(toRender.isNotEmpty
                            ? 'Book Description: ${bookModel.volumeInfo?.description}'
                            : ''),
                        const SizedBox(height: 20),
                        Text(toRender.isNotEmpty
                            ? 'Book Language: ${bookModel.volumeInfo?.language}'
                            : ''),
                        const SizedBox(height: 20),
                        Text(toRender.isNotEmpty
                            ? 'Number of Pages: ${bookModel.volumeInfo?.pageCount}'
                            : ''),
                        const SizedBox(height: 20),
                        BlocBuilder<AuthRepo, AuthState>(
                          builder: (context, state) {
                            return state.user!.email == null
                                ? ElevatedButton(
                                    onPressed: null,
                                    child: Text("Sigin to add"))
                                : BlocBuilder<FirestoreCubit, FirestoreState>(
                                    builder: (context, state) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          await showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Choose your categories'),
                                                  content: Text("PELANCO"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                      child:
                                                          const Text('Close'),
                                                    ),
                                                  ],
                                                );
                                              });

                                          print("Added");
                                          context.read<FirestoreCubit>().addBook(
                                              context,
                                              "${widget.isbn}",
                                              "${bookModel.volumeInfo?.imageLinks.smallThumbnail}",
                                              "${(bookModel.volumeInfo?.categories.join(', '))}",
                                              "${bookModel.volumeInfo?.title}");
                                        },
                                        child: Text('Add to Library'),
                                      );
                                    },
                                  );
                          },
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is BookDetailsError) {
                Navigator.pop(context,
                    'Sorry, item is not available currently ${state.message}');
                return const Text('');
              } else {
                return const Center(
                  child: Text("Error caught! Try again"),
                );
              }
            }),
      ),
    );
  }
}
