import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class ResetPassword extends UseCaseWithParams<void, ResetPasswordParams> {
  const ResetPassword(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(ResetPasswordParams param) => _repo.resetPassword(
        newPassword: param.newPassword,
        token: param.token,
      );
}

class ResetPasswordParams extends Equatable {
  const ResetPasswordParams({
    required this.newPassword,
    required this.token,
  });

  final String newPassword;
  final String token;

  @override
  List<String> get props => [token, newPassword];
}
