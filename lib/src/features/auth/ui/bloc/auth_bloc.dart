import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/two_factor_usercase.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/sign_in_response.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sent_otp_verification.dart';
import '../../domain/usecases/sign_in_usercase.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/verify_phone_number.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignInUserCase signIn,
    required TwoFactorUserCase twoFactor,
    required SignUp signUp,
    required VerifyPhoneNumber verifyPhoneNumber,
    required SentOTPVerification sentOTPVerification,
    required ResetPassword resetPassword,
    required SignOut signOut,
  })  : _signIn = signIn,
        _twoFactor = twoFactor,
        _signUp = signUp,
        _verifyPhoneNumber = verifyPhoneNumber,
        _sentOTPVerification = sentOTPVerification,
        _resetPassword = resetPassword,
        _signOut = signOut,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<TwoFactorEvent>(_twoFactorHandler);
    on<SignUpEvent>(_signUpHandler);
    on<VerifyTwoFactorEvent>(_verifyTwoFactorHandler);
    on<SentOTPVerificationEvent>(_sentOTPVerificationHandler);
    on<ResetPasswordEvent>(_resetPasswordHandler);
    on<SignOutEvent>(_signOutHandler);
  }

  final SignInUserCase _signIn;
  final TwoFactorUserCase _twoFactor;
  final SignUp _signUp;
  final VerifyPhoneNumber _verifyPhoneNumber;
  final SentOTPVerification _sentOTPVerification;
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
          emit(VerifyingTwoFactor());
        } else {
          emit(SignedIn(response));
        }
      },
    );
  }

  Future<void> _twoFactorHandler(
    TwoFactorEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _twoFactor(
      TwoFactorParams(
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
        emit(SignedIn(response));
      },
    );
  }

  Future<void> _signUpHandler(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _signUp(
      SignUpParams(
        phoneNumber: event.phoneNumber,
        fullName: event.name,
        password: event.password,
        token: event.token,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(ExpiredToken("expiredToken"));
            break;
          default:
            emit(AuthError("serverError"));
            break;
        }
      },
      (_) => emit(const SignedUp()),
    );
  }

  Future<void> _verifyTwoFactorHandler(
    VerifyTwoFactorEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyPhoneNumber(event.phoneNumber);
    result.fold(
      (failure) => emit(VerifyTwoFactorError("serverError")),
      (_) => emit(const VerifyingTwoFactor()),
    );
  }

  Future<void> _sentOTPVerificationHandler(
    SentOTPVerificationEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _sentOTPVerification(
      SentOTPVerificationParams(
        phoneNumber: event.phoneNumber,
        otp: event.otp,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(VerifyTwoFactorError("verifyError"));
            break;
          default:
            emit(AuthError("serverError"));
            break;
        }
      },
      (token) => emit(VerifiedPhoneNumber(token)),
    );
  }

  Future<void> _resetPasswordHandler(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _resetPassword(
      ResetPasswordParams(
        newPassword: event.newPassword,
        token: event.token,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(ExpiredToken("expiredToken"));
            break;
          default:
            emit(AuthError("serverError"));
            break;
        }
      },
      (token) => emit(const PasswordReset()),
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
