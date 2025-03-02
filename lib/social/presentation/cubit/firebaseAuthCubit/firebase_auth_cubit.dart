import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fc_social_fitness/social/domain/entities/registered_user.dart';
import 'package:fc_social_fitness/social/domain/use_cases/auth/log_in_auth_usecase.dart';
import '../../../domain/use_cases/auth/sign_out_auth_usecase.dart';
import '../../../domain/use_cases/auth/sign_up_auth_usecase.dart';
part 'firebase_auth_state.dart';

class FirebaseAuthCubit extends Cubit<FirebaseAuthCubitState> {
  SignUpAuthUseCase signUpAuthUseCase;
  LogInAuthUseCase logInAuthUseCase;
  SignOutAuthUseCase signOutAuthUseCase;
  User? user;

  FirebaseAuthCubit(
      this.signUpAuthUseCase, this.logInAuthUseCase, this.signOutAuthUseCase)
      : super(CubitInitial());

  static FirebaseAuthCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<User?> signUp(RegisteredUser newUserInfo) async {
    emit(CubitAuthConfirming());
    await signUpAuthUseCase(params: newUserInfo).then((newUser) {
      emit(CubitAuthConfirmed(newUser));
      user = newUser;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
    return user;
  }

  Future<void> logIn(RegisteredUser userInfo) async {
    emit(CubitAuthConfirming());
    await logInAuthUseCase(params: userInfo).then((user) {
      emit(CubitAuthConfirmed(user));
      this.user = user;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }

  Future<void> signOut({required String userId}) async {
    emit(CubitAuthConfirming());
    await signOutAuthUseCase.call(params: userId).then((value) async {
      emit(CubitAuthSignOut());
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }
}
