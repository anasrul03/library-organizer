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
                      selectedGenre = value;
                      toRender.clear();
                    });
                    cubit.fetchBookList(selectedGenre!);
                  },
                  items: genre
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



// import 'dart:convert';
// import 'package:dropdown_button2/dropdown_button2.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../Services/ApiServices/ApiService.dart';

// class HomeWidget extends StatefulWidget {
//   const HomeWidget({super.key});

//   @override
//   HomeWidgetState createState() => HomeWidgetState();
// }

// class HomeWidgetState extends State<HomeWidget> {
//   late Future<List<Items>> _futureItems;
//   String? _selectedGenre;

//   List<String> genres = [
//     "antiques+&+collectibles",
//     "literary+collections",
//     "architecture",
//     "literary+criticism",
//     "art",
//     "mathematics",
//     "bibles",
//     "medical",
//     "biography+&+autobiography",
//     "music",
//     "body+mind+&+spirit",
//     "nature",
//     "business+&+economics",
//     "performing+arts",
//     "comics+&+graphic+novels",
//     "pets",
//     "computers",
//     "philosophy",
//     "cooking",
//     "photography",
//     "crafts+&+hobbies",
//     "poetry",
//     "design",
//     "political+science",
//     "drama",
//     "psychology",
//     "education",
//     "reference",
//     "family+&+relationships",
//     "religion",
//     "fiction",
//     "science",
//     "foreign+language+study",
//     "self-help",
//     "games+&+activities",
//     "social+science",
//     "gardening",
//     "sports+&+recreation",
//     "health+&+fitness",
//     "study+aids",
//     "history",
//     "technology+&+engineering",
//     "house+&+home",
//     "transportation",
//     "humor",
//     "travel",
//     "juvenile+fiction",
//     "true+crime",
//     "juvenile+nonfiction",
//     "young+adult+fiction",
//     "language+arts+&+disciplines",
//     "young+adult+nonfiction",
//     "law",
//   ];

//   Future<List<Items>> fetchBookList(String? selectedGenre) async {
//     if (selectedGenre!.isNotEmpty) {
//       final response = await http.get(
//         Uri.parse(
//             'https://www.googleapis.com/books/v1/volumes?q=subject:$selectedGenre&key=$apiKey'),
//       );

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         print(response.statusCode);
//         print(response.body);
//         print(response.body.length);
//         final data = jsonDecode(response.body);
//         final items =
//             List.from(data['items']).map((e) => Items.fromJson(e)).toList();
//         return items;
//       } else {
//         print(response.statusCode);
//         print(response.body);
//         return [];
//       }
//     } else {
//       return [];
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _futureItems = fetchBookList(_selectedGenre);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lib.Org'),
//       ),
//       body: Column(
//         children: [
//           DropdownButton2<String>(
//             hint: const Text('Select a genre'),
//             value: _selectedGenre,
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedGenre = newValue!;
//                 _futureItems = fetchBookList(_selectedGenre);
//               });
//             },
//             items: genres.map((String genre) {
//               return DropdownMenuItem(
//                 value: genre,
//                 child: Text(genre.replaceAll("+", " ")),
//               );
//             }).toList(),
//           ),
//           Expanded(
//             child: FutureBuilder<List<Items>>(
//               future: _futureItems,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasData) {
//                   return GridView.count(
//                     crossAxisCount: 2,
//                     children: List.generate(snapshot.data!.length, (index) {
//                       return Column(
//                         children: [
//                           ListTile(
//                             leading: Image.network(
//                               snapshot.data![index].volumeInfo.imageLinks
//                                       .smallThumbnail ??
//                                   'https://via.placeholder.com/200',
//                               height: 200,
//                             ),
//                             title: Text(snapshot.data![index].volumeInfo.title),
//                             subtitle: Text(snapshot
//                                 .data![index].volumeInfo.authors
//                                 .join(", ")),
//                           ),
//                           const Divider(),
//                         ],
//                       );
//                     }),
//                   );
//                 } else if (snapshot.hasError) {
//                   return Center(
//                     child: Text("Error: ${snapshot.error}"),
//                   );
//                 } else {
//                   return const Center(child: Text("No data found"));
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class HomeWidget extends StatefulWidget {
//   const HomeWidget({Key? key});

//   @override
//   HomeWidgetState createState() => HomeWidgetState();
// }

// class HomeWidgetState extends State<HomeWidget> {
//   late Future<List<Items>> _futureItems;

//   Future<List<Items>> fetchBookList() async {
//     final response = await http.get(
//       Uri.parse(
//           'https://www.googleapis.com/books/v1/volumes?q=subject:fiction&key=$apiKey'),
//     );

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       print(response.statusCode);
//       print(response.body);
//       print(response.body.length);
//       final data = jsonDecode(response.body);
//       final items = List<dynamic>.from(data['items'] ?? [])
//           .map((e) => Items.fromJson(e))
//           .toList();
//       return items;
//     } else {
//       print(response.statusCode);
//       print(response.body);
//       return [];
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _futureItems = fetchBookList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Lib.Org'),
//       ),
//       body: FutureBuilder<List<Items>>(
//         future: _futureItems,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasData) {
//             final thumbnailUrl =
//                 snapshot.data!.first.volumeInfo.imageLinks.smallThumbnail ??
//                     'https://via.placeholder.com/200';
//             return Image.network(
//               thumbnailUrl,
//               height: 200,
//               fit: BoxFit.cover,
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text("Error: ${snapshot.error}"),
//             );
//           } else {
//             return const Center(child: Text("No data found"));
//           }
//         },
//       ),
//     );
//   }
// }