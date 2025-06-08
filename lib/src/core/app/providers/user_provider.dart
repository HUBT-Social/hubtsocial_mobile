import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/core/app/providers/user_role.dart';
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

  List<UserRole> get roles {
    var tokenBox = Hive.box(LocalStorageKey.token);
    if (tokenBox.isNotEmpty &&
        tokenBox.containsKey(LocalStorageKey.userToken)) {
      UserToken token = tokenBox.get(LocalStorageKey.userToken);

      var payload = jwtDecode(token.refreshToken).payload;
      final roleField = payload['role'];

      if (roleField is String) {
        return [UserRole.fromString(roleField)].whereType<UserRole>().toList();
      } else if (roleField is List) {
        return roleField
            .map((e) => UserRole.fromString(e.toString()))
            .whereType<UserRole>()
            .toList();
      }
    }
    return [];
  }

  UserRole get mainRole {
    final allRoles = roles;

    if (allRoles.contains(UserRole.admin)) return UserRole.admin;
    if (allRoles.contains(UserRole.teacher)) return UserRole.teacher;
    if (allRoles.contains(UserRole.student)) return UserRole.student;

    return UserRole.user;
  }

  bool get isStudent => roles.contains(UserRole.student);
  bool get isAdmin => roles.contains(UserRole.admin);
  bool get isTeacher => roles.contains(UserRole.teacher);
}
