import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../entities/user_token.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class SignIn extends UsecaseWithParams<UserToken, SignInParams> {
  const SignIn(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserToken> call(SignInParams param) => _repo.signIn(
        phoneNumber: param.phoneNumber,
        password: param.password,
      );
}

class SignInParams extends Equatable {
  const SignInParams({
    required this.phoneNumber,
    required this.password,
  });

  const SignInParams.empty()
      : phoneNumber = '',
        password = '';

  final String phoneNumber;
  final String password;

  @override
  List<String> get props => [phoneNumber, password];
}
