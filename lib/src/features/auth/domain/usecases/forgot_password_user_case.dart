import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/data/domain/usecases/usecases.dart';

import '../../../../core/utils/typedefs.dart';
import '../../data/models/forgot_password_response_model.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class ForgotPasswordUserCase
    extends UseCaseWithParams<void, ForgotPasswordParams> {
  const ForgotPasswordUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<ForgotPasswordResponseModel> call(ForgotPasswordParams param) =>
      _repo.forgotPassword(
        usernameOrEmail: param.usernameOrEmail,
      );
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({
    required this.usernameOrEmail,
  });

  const ForgotPasswordParams.empty() : usernameOrEmail = '';

  final String usernameOrEmail;

  @override
  List<String> get props => [usernameOrEmail];
}
