import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../../../features/auth/domain/entities/user_token.dart';
import '../../local_storage/local_storage_key.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  void initUser(User? user) {
    _user = user;
    Future.delayed(Duration.zero, notifyListeners);
  }

  set user(User? user) {
    _user = user;
    Future.delayed(Duration.zero, notifyListeners);
  }

  static List<String> get role {
    var tokenBox = Hive.box(LocalStorageKey.token);
    if (tokenBox.isNotEmpty &&
        tokenBox.containsKey(LocalStorageKey.userToken)) {
      UserToken token = tokenBox.get(LocalStorageKey.userToken);

      var payload = jwtDecode(token.refreshToken).payload;
      List<String> role = payload['role'] as List<String>;
      return role;
    }
    return [];
  }

  static bool get isUser {
    return role.contains('USER');
  }

  static bool get isAdmin {
    return role.contains('ADMIN');
  }
}
