import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/sign_in_response.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecases.dart';
import '../../../../core/utils/typedefs.dart';
import '../repos/auth_repo.dart';

@LazySingleton()
class TwoFactorUserCase
    extends UseCaseWithParams<SignInResponse, TwoFactorParams> {
  const TwoFactorUserCase(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<SignInResponse> call(TwoFactorParams param) => _repo.twoFactor(
        postcode: param.postcode,
      );
}

class TwoFactorParams extends Equatable {
  const TwoFactorParams({
    required this.postcode,
  });

  const TwoFactorParams.empty() : postcode = '';

  final String postcode;

  @override
  List<String> get props => [
        postcode,
      ];
}
