import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/sign_in_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class SignInUserCase extends UseCaseWithParams<SignInResponse, SignInParams> {
  const SignInUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<SignInResponse> call(SignInParams param) => _repo.signIn(
        usernameOrEmail: param.usernameOrEmail,
        password: param.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.usernameOrEmail,
    required this.password,
  });

  const SignInParams.empty()
      : usernameOrEmail = '',
        password = '';

  final String usernameOrEmail;
  final String password;

  @override
  List<String> get props => [usernameOrEmail, password];
}
