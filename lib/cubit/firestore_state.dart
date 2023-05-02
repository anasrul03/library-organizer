part of 'firestore_cubit.dart';

abstract class FirestoreState extends Equatable {
  const FirestoreState();

  @override
  List<Object> get props => [];
}

class FirestoreInitial extends FirestoreState {}

class FirestoreLoading extends FirestoreState {}

class FirestoreError extends FirestoreState {
  final String errorMessage;

  const FirestoreError(this.errorMessage);
}

class FirestoreSuccess extends FirestoreState {
  final String successMessage;

  const FirestoreSuccess(this.successMessage);
}

class FirestoreFetchSuccess extends FirestoreState {
  final BookLibraries bookLibraries;

  const FirestoreFetchSuccess(this.bookLibraries);

  // @override
  // List<Object> get props => [favoriteWords];
}

class BookLibraries {
  final List<Map<String, dynamic>> myBooks;

  const BookLibraries(this.myBooks);
}
