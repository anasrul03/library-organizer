// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lib_org/Pages/Home_Page.dart';
import 'package:lib_org/cubit/auth_state.dart';
import '../Components/Categories.dart';
import '../main.dart';
// import '../../components/snackbar.dart';

part './firestore_state.dart';

class FirestoreCubit extends Cubit<FirestoreState> {
  final AuthState authState;

  FirestoreCubit(this.authState) : super(FirestoreInitial());

  final db = FirebaseFirestore.instance;

  // void checkUserInput(categoriesList) {
  //   List<Categories> tmpArray = [];
  //   categoriesList.forEach((value) {
  //     if (value == true) {
  //       tmpArray.add(value);
  //     }
  //   });
  //   for (Categories category in categoriesList) {
  //     // print('${category.title}: ${category.isSelected}');
  //     print(tmpArray.toList());
  //   }
  // }

  Future<void> addBook(BuildContext context, isbn, imageLinks, categories,
      title, categoriesList) async {
    try {
      final user = authState.user;
      // print(user);
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }
      // Create a new document in the "bookLibraries" collection with a user email
      final docRef = db.collection("bookLibraries").doc(user.email);
      DocumentSnapshot doc = await docRef.get();

      final bookLibraries = {
        'ISBN': isbn,
        'imageLinks': imageLinks,
        'categories': categories,
        'title': title,
      };
      if (doc.exists) {
        for (String categoriesName in categoriesList) {
          await docRef.update({
            categoriesName: FieldValue.arrayUnion([bookLibraries])
          });
          print("Added Book to Rack: ${categoriesName}");
        }
      } else {
        for (String categoriesName in categoriesList) {
          await docRef.set({
            categoriesName: [bookLibraries]
          });
          print("Added Book to Rack: ${categoriesName}");
        }
      }

      fetchData();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          action: SnackBarAction(
              label: "Dismiss",
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }),
          backgroundColor: Colors.indigo,
          content: Text("Added to Library")));
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("got error: $error");
      // snackBar(error.toString(), Colors.red, Colors.white, context);
    }
  }

  Future<void> fetchData() async {
    emit(FirestoreLoading());

    try {
      final user = authState.user;
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }

      final docRef = db.collection("bookLibraries").doc(user.email);
      final docSnapshot = await docRef.get();
      // print(docSnapshot);
      if (docSnapshot.exists) {
        // print("snapshot is exist");
        final data = docSnapshot.data() as Map<String, dynamic>;
        final bookLibraries = data['flutter'];
        // print(bookLibraries);
        if (bookLibraries != null) {
          final bookLibrariesList =
              List<Map<String, dynamic>>.from(bookLibraries);
          emit(FirestoreFetchSuccess(BookLibraries(bookLibrariesList)));
        } else {
          // 'bookLibraries' is null
          emit(const FirestoreError("Data not exist"));
        }
      } else {
        // Document does not exist
        emit(const FirestoreError("Data not exist"));
      }
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("GOT ERROR IDIOT: $error");
    }
  }

  Future<void> removeBook(isbn, imageLinks, categories, title) async {
    emit(FirestoreLoading());

    try {
      final user = authState.user;
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }

      final docRef = db
          .collection("bookLibraries")
          .doc(user.uid)
          .collection("flutter")
          .doc(isbn);

      final bookLibraries = {
        'ISBN': isbn,
        'imageLinks': imageLinks,
        'categories': categories,
        'title': title,
      };

      await docRef.delete();

      emit(const FirestoreSuccess("Successfully deleted"));

      fetchData();
    } catch (error) {
      emit(FirestoreError(error.toString()));
    }
  }

  Future<void> deleteBook(String isbn, imageLinks, categories, title) async {
    try {
      final user = authState.user;
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }
      final docRef = db.collection("bookLibraries").doc(user.email);
      DocumentSnapshot doc = await docRef.get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final books = data["flutter"] as List<dynamic>;
        final updatedBooks = List<Map<String, dynamic>>.from(books)
          ..removeWhere((book) => book['ISBN'] == isbn);
        await docRef.update({"flutter": updatedBooks});
        fetchData();
      } else {
        emit(const FirestoreError("Data not exist"));
      }
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("got error: $error");
    }
  }
}
