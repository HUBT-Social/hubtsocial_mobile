import 'dart:io';

import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/entities/user.dart';

abstract class UserRepo {
  const UserRepo();

  ResultFuture<LocalUser> initUserProfile();
  ResultFuture<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String email,
    required String avatarUrl,
    required File? newImage,
  });

  ResultFuture<void> changePassword({
    required String oldPassword,
    required String newPassword,
  });
}
