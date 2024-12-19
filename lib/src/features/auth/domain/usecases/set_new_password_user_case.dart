import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/data/domain/usecases/usecases.dart';

@LazySingleton()
class SetNewPasswordUserCase
    extends UseCaseWithParams<void, SetNewPasswordParams> {
  const SetNewPasswordUserCase(this._repo);
  final AuthRepo _repo;
  @override
  ResultFuture<void> call(SetNewPasswordParams param) => _repo.setNewPassword(
      newPassword: param.newPassword,
      confirmNewPassword: param.confirmNewPassword);
}

class SetNewPasswordParams extends Equatable {
  const SetNewPasswordParams({
    required this.newPassword,
    required this.confirmNewPassword,
  });
  const SetNewPasswordParams.empty()
      : newPassword = '',
        confirmNewPassword = '';
  final String newPassword;
  final String confirmNewPassword;

  @override
  List<String> get props => [newPassword, confirmNewPassword];
}
