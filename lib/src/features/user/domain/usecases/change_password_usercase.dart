import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/repos/user_repo.dart';

@lazySingleton
class ChangePasswordUserCase
    extends UseCaseWithParams<void, ChangePasswordParams> {
  final UserRepo _repo;

  ChangePasswordUserCase(this._repo);

  @override
  ResultFuture<void> call(ChangePasswordParams param) => _repo.changePassword(
      oldPassword: param.oldPassword, newPassword: param.newPassword);
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}
