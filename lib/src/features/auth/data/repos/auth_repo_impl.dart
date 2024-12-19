import 'package:dartz/dartz.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/exceptions.dart';
import 'package:hubtsocial_mobile/src/core/api/errors/failure.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

import '../../../user/data/gender.dart';
import '../../domain/entities/user_response.dart';
import '../models/forgot_password_response_model.dart';

@LazySingleton(
  as: AuthRepo,
)
class AuthRepoImpl implements AuthRepo {
  const AuthRepoImpl(this._remoteDataSource);

  final AuthRemoteDataSource _remoteDataSource;

  @override
  ResultFuture<void> informationUser({
    required String firstName,
    required String lastName,
    required DateTime birthOfDate,
    required Gender gender,
    required String phoneNumber,
  }) async {
    try {
      await _remoteDataSource.informationUser(
        firstName: firstName,
        lastName: lastName,
        birthOfDate: birthOfDate,
        gender: gender,
        phoneNumber: phoneNumber,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

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
  ResultFuture<ForgotPasswordResponseModel> forgotPassword(
      {required String usernameOrEmail}) async {
    try {
      final result = await _remoteDataSource.forgotPassword(
        usernameOrEmail: usernameOrEmail,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<UserResponse> twoFactorPassword(
      {required String otpPassword}) async {
    try {
      final result = await _remoteDataSource.twoFactorPassword(
        otpPassword: otpPassword,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> verifyPassword({required String postcode}) async {
    try {
      final result = await _remoteDataSource.verifyPassword(
        postcode: postcode,
      );

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  ResultFuture<void> setNewPassword(
      {required String newPassword, required String confirmNewPassword}) async {
    try {
      final result = await _remoteDataSource.setNewPassword(
        newPassword: newPassword,
        confirmNewPassword: confirmNewPassword,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    }
  }
}
