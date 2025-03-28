// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/repos/user_repo.dart';

@LazySingleton()
class UpdateUserUserCase extends UseCaseWithParams<void, UpdateProfileParams> {
  const UpdateUserUserCase(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<void> call(UpdateProfileParams param) => _repo.updateUserProfile(
        userId: param.userId,
        fullName: param.fullName,
        email: param.email,
        avatarUrl: param.avatarUrl,
        newImage: param.newImage,
      );
}

class UpdateProfileParams extends Equatable {
  const UpdateProfileParams({
    required this.userId,
    required this.fullName,
    required this.email,
    required this.avatarUrl,
    required this.newImage,
  });

  final String userId;
  final String fullName;
  final String email;
  final String avatarUrl;
  final File? newImage;

  @override
  List<String> get props => [userId, fullName, email, avatarUrl];
}
