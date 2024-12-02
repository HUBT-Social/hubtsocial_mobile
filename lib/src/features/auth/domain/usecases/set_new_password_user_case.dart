import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';
import 'package:hubtsocial_mobile/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';

@LazySingleton()
class SetNewPasswordUserCase
    extends UseCaseWithParams<void, SetNewPasswordParams> {
  const SetNewPasswordUserCase(this._repo);
  final AuthRepo _repo;
  @override
  ResultFuture<void> call(SetNewPasswordParams param) => _repo.setnewpassword(
      newpassword: param.newpassword,
      confirmNewPassword: param.confirmNewPassword);
}

class SetNewPasswordParams extends Equatable {
  const SetNewPasswordParams({
    required this.newpassword,
    required this.confirmNewPassword,
  });
  const SetNewPasswordParams.empty()
      : newpassword = '',
        confirmNewPassword = '';
  final String newpassword;
  final String confirmNewPassword;

  List<String> get props => [newpassword, confirmNewPassword];
}
