import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<UserToken> signIn({
    required String phoneNumber,
    required String password,
  });

  ResultFuture<void> signUp({
    required String phoneNumber,
    required String password,
    required String fullName,
    required String token,
  });

  ResultFuture<void> verifyPhoneNumber({
    required String phoneNumber,
  });

  ResultFuture<String> sentOTPVerification({
    required String phoneNumber,
    required String otp,
  });

  ResultFuture<void> resetPassword({
    required String newPassword,
    required String token,
  });
  ResultFuture<void> signOut();
}
