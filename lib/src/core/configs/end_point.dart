import 'environment.dart';

class EndPoint {
  static String get account => "${Environment.getApiUrl}/Account";

  static String get accountLogin => "$account/login";
  static String get accountRegister => "$account/register";
  static String get accountConfirmCode => "$account/confirm-code";
}
