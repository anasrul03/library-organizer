import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lib_org/cubit/auth_cubit.dart';
import 'package:meta/meta.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final AuthRepo _authRepo;
  // late BuildContext context;

  SignupCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(SignupState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(email: value, status: SignupStatus.initial));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, status: SignupStatus.initial));
  }

  void signupWithCredentials(BuildContext context) async {
    if (!state.isValid) return;
    try {
      print("isVALID");
      await _authRepo.signUp(context, state.email, state.password);
      emit(state.copyWith(status: SignupStatus.success));
    } catch (_) {
      print(_);
    }
  }
}
