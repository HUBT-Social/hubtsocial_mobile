import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class SignUpUserCase extends UseCaseWithParams<void, SignUpParams> {
  const SignUpUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams param) => _repo.signUp(
        userName: param.userName,
        email: param.email,
        password: param.password,
        confirmPassword: param.confirmPassword,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.userName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  final String userName;
  final String email;
  final String password;
  final String confirmPassword;

  @override
  List<String> get props => [userName, email, password, confirmPassword];
}
