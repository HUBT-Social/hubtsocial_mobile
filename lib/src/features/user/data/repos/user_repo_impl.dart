import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/features/user/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/api/errors/exceptions.dart';
import '../../../../core/api/errors/failure.dart';
import '../../../../core/utils/typedefs.dart';
import '../../domain/entities/user.dart';
import '../../domain/repos/user_repo.dart';
import '../datasources/user_profile_remote_datasource.dart';

@LazySingleton(
  as: UserRepo,
)
class UserRepoImpl implements UserRepo {
  final UserProfileRemoteDataSource _remoteDataSource;

  UserRepoImpl(this._remoteDataSource);

  @override
  ResultFuture<User> initUserProfile() async {
    try {
      final result = await _remoteDataSource.initUserProfile();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserModel> getUserByUsername({required String userName}) async {
    try {
      final result = await _remoteDataSource.initUserProfile();

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUserName({
    // required String userId,
    required String firstName,
    required String lastName,
  }) async {
    try {
      await _remoteDataSource.updateUserName(
        // userId: userId,
        firstName: firstName,
        lastName: lastName,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUserAvatar({
    required File newImage,
  }) async {
    try {
      await _remoteDataSource.updateUserAvatar(
        // userId: userId,
        newImage: newImage,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String avatarUrl,
    required String email,
    required File? newImage,
  }) async {
    // This method is now deprecated as we have separate methods for name and avatar.
    // It's kept for compatibility but should ideally be replaced with calls
    // to updateUserName and updateUserAvatar where appropriate.
    try {
      // Depending on what fields are provided, you might call the specific updates.
      // For simplicity, I'll assume this method is no longer the primary update path.
      // If you still need combined updates, you'd add logic here to call
      // the appropriate data source methods based on non-null parameters.
      throw UnimplementedError(
          'updateUserProfile is deprecated. Use updateUserName or updateUserAvatar instead.');
    } catch (e) {
      // Handle potential errors if the above throws or if you implement logic here.
      rethrow;
    }
  }

  @override
  ResultFuture<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
