import 'package:flutter_bloc/flutter_bloc.dart';

import '../ApiServices/ApiBookList.dart';

abstract class BookListStates {}

class BookListInitial extends BookListStates {}

class BookListLoading extends BookListStates {}

class BookListLoaded extends BookListStates {
  final ApiBookList apiBookList;

  BookListLoaded({required this.apiBookList});
}

class BookListError extends BookListStates {
  final String message;

  BookListError({required this.message});
}

class BookListCubit extends Cubit<BookListStates> {
  BookListCubit() : super(BookListLoading());

  Future<void> fetchBookList(
      [String? genre, int? startIndex, int? maxResults]) async {
    BookListService bookListService = BookListService();
    emit(BookListLoading());

    try {
      ApiBookList apiBookList = await bookListService.fetchBookList(
          genre ?? 'fiction', startIndex ?? 0, maxResults ?? 20);

      emit(BookListLoaded(apiBookList: apiBookList));
    } catch (e) {
      emit(BookListError(message: e.toString()));
    }
  }

  // Future<void> fetchBookList(
  //     String? selectedGenre, int startIndex, int maxResults) async {
  //   BookListService bookListService = BookListService();
  //   emit(BookListLoading());
  //   try {
  //     final ApiBookList apiBookList = await bookListService.fetchBookList(
  //         selectedGenre ?? '', startIndex, maxResults);
  //     final totalItems = apiBookList.totalItems;
  //     final totalPages =
  //         totalItems ~/ maxResults + (totalItems % maxResults > 0 ? 1 : 0);
  //     final items = apiBookList.items;
  //     emit(BookListLoaded(apiBookList: apiBookList));
  //     if (startIndex >= totalPages) {
  //       startIndex = 0;
  //     }
  //   } catch (e) {
  //     emit(BookListError(message: e.toString()));
  //   }
  // }
}
