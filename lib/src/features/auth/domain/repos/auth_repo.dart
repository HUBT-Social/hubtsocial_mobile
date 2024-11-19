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

  ResultFuture<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  });

  ResultFuture<UserResponse> verifyEmail({
    required String postcode,
  });

  ResultFuture<void> resetPassword({
    required String newPassword,
    required String token,
  });
  ResultFuture<void> signOut();
}
