import 'dart:io';

import 'package:dartz/dartz.dart';
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
  ResultFuture<void> updateUserProfile({
    required String userId,
    required String fullName,
    required String avatarUrl,
    required String email,
    required File? newImage,
  }) async {
    try {
      await _remoteDataSource.updateUserProfile(
        userId: userId,
        fullName: fullName,
        email: email,
        avatarUrl: avatarUrl,
        newImage: newImage,
      );

      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
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
