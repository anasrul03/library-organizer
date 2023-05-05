// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Future<void> updateDisplayName(BuildContext context, updatedName) async {
    try {
      final user = authState.user;
      // print(user);
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }
      // Create a new document in the "bookLibraries" collection with a user email
      final docRef = db.collection("userInfo").doc(user.email);
      DocumentSnapshot doc = await docRef.get();

      final userDetails = {
        'displayName': updatedName,
      };
      if (doc.exists) {
        print("Running update");
        await docRef.update({
          "userInfo": FieldValue.arrayUnion([userDetails['displayName']])
        });
        print("Changed user name to ${userDetails['displayName']}");
      } else {
        print("Running update");

        await docRef.set({
          "userInfo": [userDetails['displayName']]
        });
        print("Changed user name to ${userDetails['displayName']}");
      }

      // fetchData();

      Fluttertoast.showToast(
          msg: "Changed name to $updatedName.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("got error: $error");
      // snackBar(error.toString(), Colors.red, Colors.white, context);
    }
  }

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

      // fetchData();

      Fluttertoast.showToast(
          msg: "Added to Library",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          // backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     duration: Duration(seconds: 1),
      //     action: SnackBarAction(
      //         label: "Dismiss",
      //         onPressed: () {
      //           ScaffoldMessenger.of(context).clearSnackBars();
      //         }),
      //     backgroundColor: Colors.indigo,
      //     content: Text("Added to Library")));
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("got error: $error");
      // snackBar(error.toString(), Colors.red, Colors.white, context);
    }
  }

  Future<void> fetchData(value) async {
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
        final bookLibraries = data[value];
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

      // fetchData();
    } catch (error) {
      emit(FirestoreError(error.toString()));
    }
  }

  Future<void> deleteBook(
      String isbn, imageLinks, categories, title, value) async {
    final String tableName = "Reading";
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

        switch (value) {
          case 0:
            final books = data["Reading"] as List<dynamic>;
            final updatedBooks = List<Map<String, dynamic>>.from(books)
              ..removeWhere((book) => book['ISBN'] == isbn);
            await docRef.update({"Reading": updatedBooks});
            print("deleting from Reading");
            tableName == "Reading";
            break;
          case 1:
            final books = data["Wishlist"] as List<dynamic>;
            final updatedBooks = List<Map<String, dynamic>>.from(books)
              ..removeWhere((book) => book['ISBN'] == isbn);
            await docRef.update({"Wishlist": updatedBooks});
            print("deleting from Wishlist");
            tableName == "Wishlist";

            break;
          case 2:
            final books = data["Completed"] as List<dynamic>;
            final updatedBooks = List<Map<String, dynamic>>.from(books)
              ..removeWhere((book) => book['ISBN'] == isbn);
            await docRef.update({"Completed": updatedBooks});
            print("deleting from Completed");
            tableName == "Completed";

            break;
          case 3:
            final books = data["Favorites"] as List<dynamic>;
            final updatedBooks = List<Map<String, dynamic>>.from(books)
              ..removeWhere((book) => book['ISBN'] == isbn);
            await docRef.update({"Favorites": updatedBooks});
            print("deleting from Favorites");
            tableName == "Favorites";

            break;
          default:
        }

        fetchData(tableName);
      } else {
        emit(const FirestoreError("Data not exist"));
      }
    } catch (error) {
      emit(FirestoreError(error.toString()));
      print("got error: $error");
    }
  }
}
