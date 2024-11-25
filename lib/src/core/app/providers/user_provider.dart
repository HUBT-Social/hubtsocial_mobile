import 'package:flutter/material.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';

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
}
