import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lib_org/Components/RackSelectableButtonList.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/auth_state.dart';
import 'package:lib_org/main.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../cubit/firestore_cubit.dart';
import 'BookDetails_Page.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  State<LibraryPage> createState() => LibraryPageState();
}

class LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[
    new Tab(icon: Text("Reading")),
    new Tab(icon: Text("Wishlist")),
    new Tab(icon: Text("Completed")),
    new Tab(icon: Text("Favorites")),
  ];
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirestoreCubit(context.read<AuthRepo>().state),
      child: BlocBuilder<FirestoreCubit, FirestoreState>(
        builder: (context, state) {
          return DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.indigo,
                centerTitle: true,
                title: const Text("My Library"),
                bottom: TabBar(
                  tabs: myTabs,
                  controller:
                      _tabController, // Assign the TabController to the TabBar
                ),
              ),
              // floatingActionButton: FloatingActionButton(onPressed: () {
              //   print(_tabController!
              //       .index); // Get the value of the current selected tab
              // }),
              body: TabBarView(
                controller: _tabController,
                children: const [
                  BookCard(tableName: "Reading", currentTab: 0),
                  BookCard(tableName: "Wishlist", currentTab: 1),
                  BookCard(tableName: "Completed", currentTab: 2),
                  BookCard(tableName: "Favorites", currentTab: 3)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookCard extends StatefulWidget {
  final String tableName;
  final int currentTab;
  const BookCard({Key? key, required this.tableName, required this.currentTab})
      : super(key: key);

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  final double cardWidth = 120;
  final double cardHeight = 400;
  final int columnNum = 3;
  final String assetName = './lib/assets/empty.svg';
  final TextStyle title = const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 26, color: Colors.indigo);
  final TextStyle subtitle = const TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Colors.grey);

  @override
  void initState() {
    super.initState();
    context.read<FirestoreCubit>().fetchData(widget.tableName);
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
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: SvgPicture.asset(
                      assetName,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "There is no book added yet",
                    style: title,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 300,
                    child: Text(
                      "You can add book in library directly from details page",
                      style: subtitle,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ));
            } else if (state is FirestoreFetchSuccess) {
              return Expanded(
                child: GridView.builder(
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
                                final String value = "Reading";
                                print(widget.currentTab);
                                context.read<FirestoreCubit>().deleteBook(
                                    isbn,
                                    imageLinks,
                                    categories,
                                    title,
                                    widget.currentTab);
                                switch (widget.currentTab) {
                                  case 0:
                                    setState(() {
                                      value == "Reading";
                                    });
                                    break;
                                  case 1:
                                    setState(() {
                                      value == "Wishlist";
                                    });
                                    break;
                                  case 2:
                                    setState(() {
                                      value == "Completed";
                                    });
                                    break;
                                  case 3:
                                    setState(() {
                                      value == "Favorites";
                                    });
                                    break;
                                  default:
                                }
                                print("Fetching data from $value");
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
                                height: 58,
                                child: Text(
                                  title,
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
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