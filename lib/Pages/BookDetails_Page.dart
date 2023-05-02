import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Services/ApiStates/ApiDetailsStates.dart';
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
      body: BlocBuilder<BookDetailsCubit, BookDetailsStates>(
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
              if (bookModel.volumeInfo.averageRating != null) {
                showRatingBar = true;
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Column(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: bookModel
                                      .volumeInfo.imageLinks.smallThumbnail,
                                  placeholder: (context, url) =>
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colors.indigo, size: 50),
                                  // 'https://bookstoreromanceday.org/wp-content/uploads/2020/08/book-cover-placeholder.png',
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  height: 200,
                                ),
                                // Image.network(
                                //   bookModel != null
                                //       ? bookModel
                                //           .volumeInfo.imageLinks.smallThumbnail
                                //       : 'https://bookstoreromanceday.org/wp-content/uploads/2020/08/book-cover-placeholder.png',
                                //   height: 200,
                                // ),
                                const SizedBox(height: 6),
                                Text('ISBN: ${widget.isbn}'),
                                const SizedBox(height: 20),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    toRender.isNotEmpty
                                        ? bookModel.volumeInfo.title
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
                                                .volumeInfo.averageRating!
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
                                        ? 'Author: ${(bookModel.volumeInfo.authors.join(', '))}'
                                        : '',
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    toRender.isNotEmpty
                                        ? 'Categories: ${(bookModel.volumeInfo.categories.join(', '))}'
                                        : '',
                                  ),
                                  const SizedBox(height: 20),
                                  Text(toRender.isNotEmpty
                                      ? 'Book Publisher: ${bookModel.volumeInfo.publisher}'
                                      : ''),
                                  const SizedBox(height: 20),
                                  Text(toRender.isNotEmpty
                                      ? 'Date of Publish: ${bookModel.volumeInfo.publishedDate}'
                                      : ''),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(toRender.isNotEmpty
                          ? 'Book Description: ${bookModel.volumeInfo.description}'
                          : ''),
                      const SizedBox(height: 20),
                      Text(toRender.isNotEmpty
                          ? 'Book Language: ${bookModel.volumeInfo.language}'
                          : ''),
                      const SizedBox(height: 20),
                      Text(toRender.isNotEmpty
                          ? 'Number of Pages: ${bookModel.volumeInfo.pageCount}'
                          : ''),
                      const SizedBox(height: 20),
                      const ElevatedButton(
                        onPressed: null,
                        child: Text('Add to Library'),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is BookDetailsError) {
              return Center(
                child: Text("Error: ${state.message}"),
              );
            } else {
              return const Center(
                child: Text("Error caught! Try again"),
              );
            }
          }),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:http/http.dart' as http;
// import '../Services/ApiServices/ApiService.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// class BookDetailsPage extends StatefulWidget {
//   final String isbn;

//   const BookDetailsPage({Key? key, required this.isbn}) : super(key: key);

//   @override
//   BookDetailsState createState() => BookDetailsState();
// }

// class BookDetailsState extends State<BookDetailsPage> {
//   final itemsCubit = ItemsCubit();

//   @override
//   void initState() {
//     super.initState();
//     // itemsCubit.fetchBookData(widget.isbn, itemsCubit);
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       await itemsCubit.fetchBookData(widget.isbn, itemsCubit);
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Book Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children: [
//                     Column(
//                       children: [
//                         Image.network(
//                           itemsCubit.state.isNotEmpty
//                               ? itemsCubit
//                                   .state[0].volumeInfo.imageLinks.smallThumbnail
//                               : 'https://bookstoreromanceday.org/wp-content/uploads/2020/08/book-cover-placeholder.png',
//                           height: 200,
//                         ),
//                         const SizedBox(height: 6),
//                         Text('ISBN: ${widget.isbn}'),
//                         const SizedBox(height: 20),
//                       ],
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             itemsCubit.state.isNotEmpty
//                                 ? itemsCubit.state[0].volumeInfo.title
//                                 : '',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.bold, fontSize: 20),
//                           ),
//                           const SizedBox(height: 10),
//                           RatingBarIndicator(
//                             rating: itemsCubit.state.isNotEmpty
//                                 ? itemsCubit.state[0].volumeInfo.averageRating
//                                     .toDouble()
//                                 : 0,
//                             itemBuilder: (context, index) => const Icon(
//                               Icons.star,
//                               color: Colors.amber,
//                             ),
//                             itemCount: 5,
//                             itemSize: 20.0,
//                             unratedColor: Colors.grey[300],
//                             direction: Axis.horizontal,
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Author: ${itemsCubit.state.isNotEmpty ? (itemsCubit.state[0].volumeInfo.authors.join(', ')) : ''}',
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                             'Categories: ${itemsCubit.state.isNotEmpty ? (itemsCubit.state[0].volumeInfo.categories.join(', ')) : ''}',
//                           ),
//                           const SizedBox(height: 20),
//                           Text(
//                               'Book Publisher: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.publisher : ''}'),
//                           const SizedBox(height: 20),
//                           Text(
//                               'Date of Publish: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.publishedDate : ''}'),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Text(
//                   'Book Description: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.description : ''}'),
//               const SizedBox(height: 20),
//               Text(
//                   'Book Language: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.language : ''}'),
//               const SizedBox(height: 20),
//               Text(
//                   'Number of Pages: ${itemsCubit.state.isNotEmpty ? itemsCubit.state[0].volumeInfo.pageCount : ''}'),
//               const SizedBox(height: 20),
//               const ElevatedButton(
//                 onPressed: null,
//                 child: Text('Add to Library'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }