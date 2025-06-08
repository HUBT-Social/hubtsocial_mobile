import 'package:flutter/material.dart';

enum UserRole {
  user,
  student,
  admin,
  teacher;

  static UserRole? fromString(String role) {
    switch (role.toUpperCase()) {
      case 'STUDENT':
        return user;
      case 'ADMIN':
        return admin;
      case 'TEACHER':
        return teacher;
      default:
        return user;
    }
  }
}

extension UserRoleExtension on UserRole {
  IconData get icon {
    switch (this) {
      case UserRole.student:
        return Icons.school;
      case UserRole.admin:
        return Icons.admin_panel_settings;
      case UserRole.teacher:
        return Icons.co_present;
      case UserRole.user:
        return Icons.person;
    }
  }
}
