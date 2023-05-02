// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lib_org/cubit/auth_state.dart';

// import '../../components/snackbar.dart';

part './firestore_state.dart';

class FirestoreCubit extends Cubit<FirestoreState> {
  final AuthState authState;

  FirestoreCubit(this.authState) : super(FirestoreInitial());

  final db = FirebaseFirestore.instance;

  Future<void> addBook(isbn, imageLinks, categories) async {
    try {
      final user = authState.user;
      // print(user);
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }

      // Create a new document in the "favorites" collection with a unique ID
      final docRef = db.collection("bookLibraries").doc(user.email);

      DocumentSnapshot doc = await docRef.get();

      final bookLibraries = {
        'ISBN': isbn,
        'imageLinks': imageLinks,
        'categories': categories,
      };

      if (doc.exists) {
        await docRef.update({
          categories: FieldValue.arrayUnion([bookLibraries])
        });
      } else {
        await docRef.set({
          categories: [bookLibraries]
        });
      }

      // Emit a new state to indicate that the favorite word has been successfully added
      // emit(FirestoreFetchSuccess(bookLibraries));

      fetchData();
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

      final docRef = db.collection("bookLibraries").doc("test@gmail.com");
      final docSnapshot = await docRef.get();
      print(docSnapshot);
      if (docSnapshot.exists) {
        print("snapshot is exist");
        final data = docSnapshot.data() as Map<String, dynamic>;
        final bookLibraries = data['Fiction'];
        print(bookLibraries);
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

  Future<void> removeFavorite(isbn, imageLinks, categories) async {
    emit(FirestoreLoading());

    try {
      final user = authState.user;
      if (user == null) {
        emit(const FirestoreError("User not logged in"));
        return;
      }

      final docRef = db.collection("bookLibraries").doc(user.uid);

      final bookLibraries = {
        'ISBN': isbn,
        'imageLinks': imageLinks,
        'categories': categories,
      };

      await docRef.update({
        categories: FieldValue.arrayRemove([bookLibraries])
      });

      // emit(const FirestoreSuccess("Successfully deleted"));

      fetchData();
    } catch (error) {
      emit(FirestoreError(error.toString()));
    }
  }
}
