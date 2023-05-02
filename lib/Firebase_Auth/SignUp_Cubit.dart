import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data.auth/listeners/auth_signup_listener.dart';

import '../data.auth/repository/auth_repo.dart';

enum SignUpUserState { success, user_exists, weak_password, failed, initial }

class SignUpUserCubit extends Cubit<SignUpUserState>
    implements AuthSigUpListener {
  final _authRepository = AuthRepository();

  SignUpUserCubit(SignUpUserState initialState) : super(initialState);

  void registerUser({required String email, required String password}) {
    _authRepository.registerUser(
        email: email, password: password, authSignUpListener: this);
  }

  @override
  void failed() {
    emit(SignUpUserState.initial);
    emit(SignUpUserState.failed);
  }

  @override
  void success() {
    emit(SignUpUserState.success);
  }

  @override
  void userExists() {
    emit(SignUpUserState.initial);
    emit(SignUpUserState.user_exists);
  }

  @override
  void weakPassword() {
    emit(SignUpUserState.initial);
    emit(SignUpUserState.weak_password);
  }
}
