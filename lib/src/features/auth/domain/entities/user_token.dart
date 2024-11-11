import 'package:hive_flutter/adapters.dart';

part 'user_token.g.dart';

@HiveType(typeId: 0)
class UserToken extends HiveObject {
  @HiveField(0)
  final String tokenType;
  @HiveField(1)
  final String accessToken;
  @HiveField(2)
  final int expiresIn;
  @HiveField(3)
  final String refreshToken;

  UserToken({
    required this.tokenType,
    required this.accessToken,
    required this.expiresIn,
    required this.refreshToken,
  });

  @override
  String toString() {
    return 'UserToken(tokenType: $tokenType, accessToken: $accessToken, expiresIn: $expiresIn, refreshToken: $refreshToken)';
  }
}
