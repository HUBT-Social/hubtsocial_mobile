import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/forgot_password_user_case.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/usecases/otp_user_case.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/information_user_case.dart';
import '../../domain/usecases/reset_password.dart';
import '../../domain/usecases/set_new_password_user_case.dart';
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
    required VerifyPasswordUserCase password,
    required ForgotPasswordUserCase forgotPassword,
    required VerifyEmailUserCase verifyEmail,
    required SignUpUserCase signUp,
    required ResetPassword resetPassword,
    required VerifyPasswordUserCase verifyPassword,
    required SetNewPasswordUserCase setnewpassword,
    required SignOut signOut,
    required InformationUserCase informationUserCase,
  })  : _signIn = signIn,
        _twoFactor = twoFactor,
        _forgotPassword = forgotPassword,
        _verifyEmail = verifyEmail,
        _signUp = signUp,
        _resetPassword = resetPassword,
        _verifyPassword = verifyPassword,
        _setnewpassword = setnewpassword,
        _signOut = signOut,
        _informationUserCase = informationUserCase,
        super(const AuthInitial()) {
    on<AuthEvent>((event, emit) {
      emit(const AuthLoading());
    });
    on<SignInEvent>(_signInHandler);
    on<SetNewPasswordEvent>(_setnewpasswordHandler);
    on<VerifyPasswordEvent>(_verifyPasswordHandler);
    on<TwoFactorEvent>(_twoFactorHandler);
    on<ForgotPasswordEvent>(_forgotPasswordHandler);
    on<VerifyEmailEvent>(_verifyEmailHandler);
    on<SignUpEvent>(_signUpHandler);
    on<SignOutEvent>(_signOutHandler);
    on<SignUpInformationEvent>(_signUpInformationHandler);
  }

  final SignInUserCase _signIn;
  final TwoFactorUserCase _twoFactor;
  final ForgotPasswordUserCase _forgotPassword;
  final VerifyEmailUserCase _verifyEmail;
  final VerifyPasswordUserCase _verifyPassword;
  final SetNewPasswordUserCase _setnewpassword;
  final SignUpUserCase _signUp;
  final ResetPassword _resetPassword;
  final SignOut _signOut;
  final InformationUserCase _informationUserCase;

  Future<void> _signUpInformationHandler(
    SignUpInformationEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _informationUserCase(
      InformationUserParams(
        firstName: event.firstName,
        lastName: event.lastName,
        birthOfDate: event.birthOfDate,
        gender: event.gender,
        phoneNumber: event.phoneNumber,
      ),
    );
    result.fold(
      (failure) {
        emit(AuthError(failure.message));
      },
      (_) => emit(InformationUserSuccess()),
    );
  }

  Future<void> _setnewpasswordHandler(
    SetNewPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _setnewpassword(
      SetNewPasswordParams(
        newPassword: event.newPassword,
        confirmNewPassword: event.confirmNewPassword,
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
        emit(SetNewPasswordSuccess());
      },
    );
  }

  Future<void> _verifyPasswordHandler(
    VerifyPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await _verifyPassword(
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
        emit(VerifyForgotPasswordSuccess());
      },
    );
  }

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

  Future<void> _forgotPasswordHandler(
      ForgotPasswordEvent event, Emitter<AuthState> emit) async {
    final result = await _forgotPassword(
      ForgotPasswordParams(
        usernameOrEmail: event.usernameOrEmail,
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
        emit(VerifyForgotPassword(response.email ?? ""));
      },
    );
  }

  // Future<void> _updateEmailHandler(
  //     UpdateEmailEvent event, Emitter<AuthState> emit) async {
  //   final result = await _forgotPassword(
  //     ForgotPasswordParams(
  //       usernameOrEmail: event.email,
  //     ),
  //   );
  //   result.fold(
  //     (failure) {
  //       switch (int.parse(failure.statusCode)) {
  //         case 401:
  //           emit(AuthError(failure.message));
  //           break;
  //         default:
  //           emit(AuthError(failure.message));
  //           break;
  //       }
  //     },
  //     (response) {
  //       emit(VerifyForgotPassword());
  //     },
  //   );
  // }
}
