import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

import '../../domain/entities/user_response.dart';

@LazySingleton(
  as: AuthRepo,
)
class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<UserResponse> signIn({
    required String usernameOrEmail,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signIn(
        userName: usernameOrEmail,
        password: password,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signUp({
    required String userName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await _remoteDataSource.signUp(
        userName: userName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> resetPassword({
    required String newPassword,
    required String token,
  }) async {
    try {
      await _remoteDataSource.resetPassword(
        newPassword: newPassword,
        token: token,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserResponse> twoFactor({required String postcode}) async {
    try {
      final result = await _remoteDataSource.twoFactor(
        postcode: postcode,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserResponse> verifyEmail({required String postcode}) async {
    try {
      final result = await _remoteDataSource.verifyEmail(
        postcode: postcode,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> forgotPassword({required String usernameOrEmail}) async {
    try {
      final result = await _remoteDataSource.forgotPassword(
        usernameOrEmail: usernameOrEmail,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
