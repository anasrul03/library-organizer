// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:lib_org/Components/Categories.dart';
import 'package:meta/meta.dart';

import 'auth_state.dart';
import 'firestore_cubit.dart';

part 'user_libraries_state.dart';

class UserLibrariesCubit extends Cubit<UserLibrariesState> {
  final AuthState authState;

  UserLibrariesCubit(this.authState)
      : super(UserLibrariesInitial(rackName: ''));

  final db = FirebaseFirestore.instance;

  Future<void> fetchUserLibraries(String value) async {
    emit(UserLibrariesLoading(rackName: ''));

    try {
      final user = authState.user;
      if (user == null) {
        emit(UserLibrariesError("User not logged in", rackName: ''));
        return;
      }

      final docRef = db.collection("UserRack").doc(user.email);
      final docSnapshot = await docRef.get();
      // print(docSnapshot);
      if (docSnapshot.exists) {
        // print("snapshot is exist");
        final data = docSnapshot.data() as Map<String, dynamic>;
        final rack = data[value];
        // print(bookLibraries);
        if (rack != null) {
          final bookLibrariesList = List<Map<String, dynamic>>.from(rack);
          emit(UserLibrariesFetchSuccess(RackList(bookLibrariesList),
              rackName: value));
        } else {
          // 'bookLibraries' is null
          emit(UserLibrariesError("Data not exist", rackName: ''));
        }
      } else {
        // Document does not exist
        emit(UserLibrariesError("Data not exist", rackName: ''));
      }
    } catch (error) {
      emit(UserLibrariesError(error.toString(), rackName: ''));
      print("GOT ERROR IDIOT: $error");
    }
  }

  Future<void> addRack() async {
    List<String> rackList = ['MyLibrary'];
    try {
      final user = authState.user;
      // print(user);
      if (user == null) {
        emit(UserLibrariesError("User not logged in", rackName: ''));
        return;
      }
      // Create a new document in the "bookLibraries" collection with a user email
      final docRef = db.collection("UserRack").doc(user.email);
      DocumentSnapshot doc = await docRef.get();

      final rackDetails = {
        'RackName': state.rackName,
        'isSelected': false,
      };
      if (doc.exists) {
        for (String rackName in rackList) {
          await docRef.update({
            "myRack": FieldValue.arrayUnion([rackDetails])
          });
          print("Added Rack to Your Library: $rackName");
        }
      } else {
        for (String rackName in rackList) {
          await docRef.set({
            "myRack": [rackDetails]
          });
          print("Added Rack to Your Library: $rackName");
        }
      }
    } catch (error) {
      emit(UserLibrariesError(error.toString(), rackName: ''));
      print("got error: $error");
      // snackBar(error.toString(), Colors.red, Colors.white, context);
    }
  }

  Future<void> addDefaultRack() async {
    List<String> rackList = ['Science', 'Geo', 'Cat'];

    try {
      final user = authState.user;
      // print(user);
      if (user == null) {
        emit(UserLibrariesError("User not logged in", rackName: ''));
        return;
      }
      // Create a new document in the "bookLibraries" collection with a user email
      final docRef = db.collection("UserRack").doc(user.email);
      DocumentSnapshot doc = await docRef.get();

      // final rackDetails = {
      //   'RackName': "Fiction",
      // };
      if (doc.exists) {
        print("running set");
        for (String rack in rackList) {
          await docRef.update({
            "myRack": FieldValue.arrayUnion([
              {'RackName': rack, 'isSelected': false}
            ])
          });
          print("Added Rack to Your Library: $rack");
        }
      } else {
        for (String rack in rackList) {
          await docRef.set({
            "myRack": [
              {'RackName': rack, 'isSelected': false}
            ]
          });
          print("Added Rack to Your Library: $rack");
        }
      }
    } catch (error) {
      emit(UserLibrariesError(error.toString(), rackName: ''));
      print("got error: $error");
      // snackBar(error.toString(), Colors.red, Colors.white, context);
    }
  }

  void rackNameChanged(String value) {
    emit(state.copyWith(rackName: value));
  }
}
