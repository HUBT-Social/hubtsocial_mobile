import 'environment.dart';

class EndPoint {
  static String get apiUrl => Environment.getApiUrl;
  static String get auth => "$apiUrl/auth";

  static String get authSignIn => "$auth/sign-in";
  static String get authSignInTwoFactor => "$auth/sign-in/verify-two-factor";
  static String get authSignUp => "$auth/sign-up";
  static String get authSignUpVerifyEmail => "$auth/sign-up/verify-otp";
  static String get authRegister => "$auth/register";
  static String get authConfirmCode => "$auth/confirm-code";
}