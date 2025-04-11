import 'environment.dart';

class EndPoint {
  static String get apiUrl => "${Environment.getApiUrl}/api";
  static String get chatHub => Environment.getChatHub;

  static String get _auth => "$apiUrl/auth";
  static String get authSignIn => "$_auth/sign-in";
  static String get authSignInTwoFactor => "$_auth/sign-in/verify-two-factor";
  static String get twoFactorPassword => "$_auth/sign-in/verify-two-factor";
  static String get authSignUp => "$_auth/sign-up";
  static String get authSignUpVerifyEmail => "$_auth/sign-up/verify-otp";
  static String get authVerifyPassword =>
      "$_auth/forgot-password/password-verification";
  static String get authSetNewPassword =>
      "$_auth/forgot-password/change-password";
  static String get authRegister => "$_auth/register";
  static String get authConfirmCode => "$_auth/confirm-code";
  static String get authForgotPassword => "$_auth/forgot-password";
  static String get authRefreshToken => "$_auth/refresh-token";
  static String get authDeleteToken => "$_auth/delete-token";

  static String get _user => "$apiUrl/user";
  static String get userGetUser => _user;
  static String get informationUser => "$_user/add-info-user";
  static String get updateFcmToken => "$_user/update/fcm-token";

  static String get _chat => "$apiUrl/chat";
  static String get chatView => "$_chat/load-rooms";
  static String get roomHistory => "$_chat/room/get-history";
  static String get roomInfo => "$_chat/room/info";

  static String get _schooldata => "$_user/schooldata";
  static String get checkVersion => "$_schooldata/check-version";
  static String get timetable => "$_schooldata/timetable";
  static String get timetableInfo => "$_schooldata/timetable-info";
}
