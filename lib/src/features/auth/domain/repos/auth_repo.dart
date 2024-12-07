import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../entities/user_response.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<UserResponse> signIn({
    required String usernameOrEmail,
    required String password,
  });

  ResultFuture<UserResponse> twoFactor({
    required String postcode,
  });
  ResultFuture<UserResponse> twoFactorPassword({
    required String otpPassword,
  });

  ResultFuture<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  });
  ResultFuture<void> informationUser({
    required String firstName,
    required String lastName,
    required String birthOfDate,
    required String gender,
    required String phoneNumber,
  });
  ResultFuture<UserResponse> verifyEmail({
    required String postcode,
  });
  ResultFuture<void> verifyPassword({
    required String postcode,
  });
  ResultFuture<void> setNewPassword({
    required String newPassword,
    required String confirmNewPassword,
  });
  ResultFuture<ForgotPasswordResponseModel> forgotPassword({
    required String usernameOrEmail,
  });

  ResultFuture<void> resetPassword({
    required String newPassword,
    required String token,
  });
  ResultFuture<void> signOut();
}
