import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/otp_user_case.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sign_in_user_case.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up_user_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUserCase signIn,
    required TwoFactorUserCase twoFactor,
    required VerifyEmailUserCase verifyEmail,
    required SignUpUserCase signUp,
    required ResetPassword resetPassword,
    required SignOut signOut,
  })  : _signIn = signIn,
        _twoFactor = twoFactor,
        _verifyEmail = verifyEmail,
        _signUp = signUp,
        _resetPassword = resetPassword,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<TwoFactorEvent>(_twoFactorHandler);
    on<VerifyEmailEvent>(_verifyEmailHandler);
    on<SignUpEvent>(_signUpHandler);
    on<SignOutEvent>(_signOutHandler);
  }

  final SignInUserCase _signIn;
  final TwoFactorUserCase _twoFactor;
  final VerifyEmailUserCase _verifyEmail;
  final SignUpUserCase _signUp;
  final ResetPassword _resetPassword;
  final SignOut _signOut;

  Future<void> _signInHandler(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signIn(
      SignInParams(
        usernameOrEmail: event.usernameOrEmail,
        password: event.password,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(AuthError(failure.message));
            break;
          default:
            emit(AuthError(failure.message));
            break;
        }
      },
      (response) {
        if (response.requiresTwoFactor!) {
          emit(VerifyTwoFactor());
        } else {
          emit(SignedIn());
        }
      },
    );
  }

  Future<void> _twoFactorHandler(
    TwoFactorEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _twoFactor(
      OtpParams(
        postcode: event.postcode,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(AuthError(failure.message));
            break;
          default:
            emit(AuthError(failure.message));
            break;
        }
      },
      (response) {
        emit(SignedIn());
      },
    );
  }

  Future<void> _verifyEmailHandler(
    VerifyEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyEmail(
      OtpParams(
        postcode: event.postcode,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(AuthError(failure.message));
            break;
          default:
            emit(AuthError(failure.message));
            break;
        }
      },
      (response) {
        emit(SignedIn());
      },
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        userName: event.userName,
        email: event.email,
        password: event.password,
        confirmPassword: event.confirmPassword,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(ExpiredToken(failure.message));
            break;
          default:
            emit(AuthError(failure.message));
            break;
        }
      },
      (_) => emit(const VerifyEmail()),
    );
  }

  Future<void> _signOutHandler(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signOut();
    result.fold(
      (failure) => emit(AuthError("serverError")),
      (token) => emit(const SignedOut()),
    );
  }
}
