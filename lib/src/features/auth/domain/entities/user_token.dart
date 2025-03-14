import 'package:hive_ce_flutter/adapters.dart';

import '../../../../core/local_storage/local_storage_type_id.dart';

part 'user_token.g.dart';

@HiveType(typeId: LocalStorageTypeId.userToken)
class UserToken extends HiveObject {
  @HiveField(0)
  final String accessToken;
  @HiveField(1)
  final String refreshToken;
  @HiveField(2)
  final int expiresIn;
  @HiveField(3)
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
}
