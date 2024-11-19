import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class TwoFactorUserCase extends UseCaseWithParams<UserResponse, OtpParams> {
  const TwoFactorUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserResponse> call(OtpParams param) => _repo.twoFactor(
        postcode: param.postcode,
      );
}

@LazySingleton()
class VerifyEmailUserCase extends UseCaseWithParams<UserResponse, OtpParams> {
  const VerifyEmailUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<UserResponse> call(OtpParams param) => _repo.verifyEmail(
        postcode: param.postcode,
      );
}

class OtpParams extends Equatable {
  const OtpParams({
    required this.postcode,
  });

  const OtpParams.empty() : postcode = '';

  final String postcode;

  @override
  List<String> get props => [
        postcode,
      ];
}
