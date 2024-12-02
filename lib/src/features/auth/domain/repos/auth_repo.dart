import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
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

  ResultFuture<UserResponse> verifyEmail({
    required String postcode,
  });
  ResultFuture<void> verifyPassword({
    required String postcode,
  });
  ResultFuture<void> setnewpassword({
    required String newPassword,
    required String confirmNewPassword,
  });
  ResultFuture<void> forgotPassword({
    required String usernameOrEmail,
  });

  ResultFuture<void> resetPassword({
    required String newPassword,
    required String token,
  });
  ResultFuture<void> signOut();
}
