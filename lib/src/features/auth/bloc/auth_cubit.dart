import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/logger/loggy_types.dart';
import '../../user/model/user.dart';
import '../../user/repository/user_repository.dart';
import '../repository/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> with BlocLoggy {
  AuthCubit({
    required this.authRepository,
    required this.userRepository,
  }) : super(const AuthInitial());

  final AuthRepository authRepository;
  final UserRepository userRepository;

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());

    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthSuccess(user: user));
    } catch (e, s) {
      loggy.error('signUpWithEmailAndPassword error', e, s);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      emit(AuthSuccess(user: user));
    } catch (e, s) {
      loggy.error('signInWithEmailAndPassword error', e, s);
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }
}
