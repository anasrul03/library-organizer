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

  Future<void> fetchBookList([String? genre]) async {
    BookListService bookListService = BookListService();
    emit(BookListLoading());

    try {
      ApiBookList apiBookList =
          await bookListService.fetchBookList(genre ?? 'fiction');

      emit(BookListLoaded(apiBookList: apiBookList));
    } catch (e) {
      emit(BookListError(message: e.toString()));
    }
  }
}
