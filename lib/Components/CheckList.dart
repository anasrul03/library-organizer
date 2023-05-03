// ignore_for_file: prefer_final_fields, avoid_print, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Components/Categories.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:lib_org/cubit/firestore_cubit.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../Services/ApiServices/ApiBookDetails.dart';
import '../Services/ApiStates/ApiDetailsStates.dart';

class CheckListCategories extends StatefulWidget {
  List<String> selected = [];
  final String isbn;
  CheckListCategories({
    super.key,
    required this.isbn,
  });

  @override
  State<CheckListCategories> createState() => _CheckListCategoriesState();
}

class _CheckListCategoriesState extends State<CheckListCategories> {
  late BookDetailsCubit cubit;
  List<Items> toRender = [];
  bool isAnon = false;
  // CheckListCategories checkListCategories = CheckListCategories(isbn: widget.isbn,);
  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<BookDetailsCubit>(context);
    cubit.fetchBookDetails(widget.isbn);
    setState(() {});
  }

  List<Categories> rackList = [
    Categories(title: "Fiction"),
    Categories(title: "Horror"),
    Categories(title: "Adventure")
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FirestoreCubit(context.read<AuthRepo>().state),
      child: BlocBuilder<BookDetailsCubit, BookDetailsStates>(
        bloc: cubit,
        builder: (BuildContext context, state) {
          if (state is BookDetailsLoading && toRender.isEmpty) {
            return Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.indigo,
                size: 80,
              ),
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
            // Add the return statement here
            return SizedBox(
              height: 300.0, // Change as per your requirement
              width: 300.0, // Change as per your requirement
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: ListView.builder(
                      itemCount: rackList.length,
                      itemBuilder: (BuildContext context, index) {
                        return CheckboxListTile(
                          title: Text(rackList[index].title),
                          value: rackList[index].isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              rackList[index].isSelected = value!;
                              if (rackList[index].isSelected) {
                                widget.selected.add(rackList[index].title);
                              } else if (!rackList[index].isSelected) {
                                widget.selected.remove(rackList[index].title);
                              }
                              print(widget.selected);
                            });
                            // List<String> update = widget.selected;
                            // widget.setString(widget.selected);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: Colors.blue,
                          checkColor: Colors.white,
                        );
                      },
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        context.read<FirestoreCubit>().addBook(
                            context,
                            "${widget.isbn}",
                            "${bookModel.volumeInfo!.imageLinks}",
                            "${bookModel.volumeInfo!.categories}",
                            "${bookModel.volumeInfo!.title}",
                            widget.selected);
                      },
                      child: Text("Lesgoo"))
                ],
              ),
            );
          } else if (state is BookDetailsError) {
            print("error: ${state.message}");

            Navigator.pop(context,
                'Sorry, item is not available currently ${state.message}');
            return const Text('');
          } else {
            print("2");

            return const Center(
              child: Text("Error caught! Try again"),
            );
          }
        },
      ),
    );
  }
}


// return SizedBox(
//                 height: 300.0, // Change as per your requirement
//                 width: 300.0, // Change as per your requirement
//                 child: Column(
//                   children: [
//                     Expanded(
//                       flex: 3,
//                       child: ListView.builder(
//                         itemCount: rackList.length,
//                         itemBuilder: (BuildContext context, index) {
//                           return CheckboxListTile(
//                             title: Text(rackList[index].title),
//                             value: rackList[index].isSelected,
//                             onChanged: (bool? value) {
//                               setState(() {
//                                 rackList[index].isSelected = value!;
//                                 if (rackList[index].isSelected) {
//                                   widget.selected.add(rackList[index].title);
//                                 } else if (!rackList[index].isSelected) {
//                                   widget.selected.remove(rackList[index].title);
//                                 }
//                                 print(widget.selected);
//                               });
//                               // List<String> update = widget.selected;
//                               widget.setString(widget.selected);
//                             },
//                             controlAffinity: ListTileControlAffinity.leading,
//                             activeColor: Colors.blue,
//                             checkColor: Colors.white,
//                           );
//                         },
//                       ),
//                     ),
//                     TextButton(
//                         onPressed: () {
//                           context.read<FirestoreCubit>().addBook(
//                               context,
//                               "${widget.isbn}",
//                               "${bookModel.volumeInfo!.imageLinks}",
//                               "${bookModel.volumeInfo!.categories}",
//                               "${bookModel.volumeInfo!.title}",
//                               widget.selected);
//                         },
//                         child: Text("Lesgoo"))
//                   ],
//                 ),
//               );