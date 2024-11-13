import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class SignUp extends UseCaseWithParams<void, SignUpParams> {
  const SignUp(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(SignUpParams param) => _repo.signUp(
        phoneNumber: param.phoneNumber,
        password: param.password,
        fullName: param.fullName,
        token: param.token,
      );
}

class SignUpParams extends Equatable {
  const SignUpParams({
    required this.phoneNumber,
    required this.password,
    required this.fullName,
    required this.token,
  });

  // const SignUpParams.empty()
  //     : this(phoneNumber: '', password: '', fullName: '');

  final String phoneNumber;
  final String password;
  final String fullName;
  final String token;

  @override
  List<String> get props => [phoneNumber, password, fullName];
}
