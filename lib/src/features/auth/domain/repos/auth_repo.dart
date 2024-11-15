import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import '../entities/sign_in_response.dart';

abstract class AuthRepo {
  const AuthRepo();

  ResultFuture<SignInResponse> signIn({
    required String usernameOrEmail,
    required String password,
  });
  ResultFuture<SignInResponse> twoFactor({
    required String postcode,
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
