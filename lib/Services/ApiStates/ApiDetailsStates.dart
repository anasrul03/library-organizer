import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lib_org/Services/ApiServices/ApiBookDetails.dart';

abstract class BookDetailsStates {}

class BookDetailsInitial extends BookDetailsStates {}

class BookDetailsLoading extends BookDetailsStates {}

class BookDetailsLoaded extends BookDetailsStates {
  final ApiBookDetails apiBookDetails;

  BookDetailsLoaded({required this.apiBookDetails});
}

class BookDetailsError extends BookDetailsStates {
  final String message;

  BookDetailsError({required this.message});
}

class BookDetailsCubit extends Cubit<BookDetailsStates> {
  BookDetailsCubit() : super(BookDetailsLoading());

  Future<void> fetchBookDetails([String? isbn]) async {
    BookDetailsService bookDetailsService = BookDetailsService();
    emit(BookDetailsLoading());

    try {
      ApiBookDetails apiBookDetails =
          await bookDetailsService.fetchBookDetails(isbn!);

      emit(BookDetailsLoaded(apiBookDetails: apiBookDetails));
    } catch (e) {
      emit(BookDetailsError(message: e.toString()));
    }
  }
}
