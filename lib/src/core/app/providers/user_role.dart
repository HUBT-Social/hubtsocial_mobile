import 'package:flutter/material.dart';

enum UserRole {
  none,
  user,
  admin,
  teacher;

  static UserRole? fromString(String role) {
    switch (role.toUpperCase()) {
      case 'USER':
        return user;
      case 'ADMIN':
        return admin;
      case 'TEACHER':
        return teacher;
      default:
        return none;
    }
  }
}

extension UserRoleExtension on UserRole {
  IconData get icon {
    switch (this) {
      case UserRole.user:
        return Icons.school;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.teacher:
        return Icons.co_present;
      case UserRole.none:
        throw Icons.person;
    }
  }
}
