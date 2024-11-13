import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class SentOTPVerification
    extends UseCaseWithParams<String, SentOTPVerificationParams> {
  const SentOTPVerification(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<String> call(SentOTPVerificationParams param) =>
      _repo.sentOTPVerification(phoneNumber: param.phoneNumber, otp: param.otp);
}

class SentOTPVerificationParams extends Equatable {
  const SentOTPVerificationParams({
    required this.phoneNumber,
    required this.otp,
  });

  const SentOTPVerificationParams.empty()
      : phoneNumber = '',
        otp = '';

  final String phoneNumber;
  final String otp;

  @override
  List<String> get props => [phoneNumber, otp];
}
