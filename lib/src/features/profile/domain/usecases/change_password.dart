import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/repos/user_profile_repo.dart';

@lazySingleton
class ChangePassword extends UsecaseWithParams<void, ChangePasswordParams> {
  final UserRepo _repo;

  ChangePassword(this._repo);

  @override
  ResultFuture<void> call(ChangePasswordParams param) => _repo.changePassword(
      oldPassword: param.oldPassword, newPassword: param.newPassword);
}

class ChangePasswordParams {
  final String oldPassword;
  final String newPassword;

  ChangePasswordParams({required this.oldPassword, required this.newPassword});
}
