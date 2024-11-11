import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/user_token.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/sent_otp_verification.dart';
import '../../domain/usecases/sign_in.dart';
import '../../domain/usecases/sign_out.dart';
import '../../domain/usecases/sign_up.dart';
import '../../domain/usecases/verify_phone_number.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@Injectable()
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required SignIn signIn,
    required SignUp signUp,
    required VerifyPhoneNumber verifyPhoneNumber,
    required SentOTPVerification sentOTPVerification,
    required ResetPassword resetPassword,
    required SignOut signOut,
  })  : _signIn = signIn,
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
    on<SignUpEvent>(_signUpHandler);
    on<VerifyPhoneNumberEvent>(_verifyPhoneNumberHandler);
    on<SentOTPVerificationEvent>(_sentOTPVerificationHandler);
    on<ResetPasswordEvent>(_resetPasswordHandler);
    on<SignOutEvent>(_signOutHandler);
  }

  final SignIn _signIn;
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
        phoneNumber: event.phoneNumber,
        password: event.password,
      ),
    );
    result.fold(
      (failure) {
        switch (int.parse(failure.statusCode)) {
          case 401:
            emit(AuthError("unauthorized"));
            break;
          default:
            emit(AuthError("serverError"));
            break;
        }
      },
      (token) => emit(SignedIn(token)),
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

  Future<void> _verifyPhoneNumberHandler(
    VerifyPhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyPhoneNumber(event.phoneNumber);
    result.fold(
      (failure) => emit(VerifyError("serverError")),
      (_) => emit(const Verifying()),
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
            emit(VerifyError("verifyError"));
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
