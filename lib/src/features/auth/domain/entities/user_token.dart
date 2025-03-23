import 'package:hive_ce_flutter/adapters.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

class UserToken extends HiveObject {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  UserToken({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  @override
  String toString() {
    return 'UserToken(tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, refreshToken: $refreshToken)';
  }

  List<String> get role {
    var payload = jwtDecode(accessToken).payload;
    List<String> role = payload['role'] as List<String>;
    return role;
  }

  bool get isUser {
    return role.contains('USER');
  }

  bool get isAdmin {
    return role.contains('ADMIN');
  }
}
