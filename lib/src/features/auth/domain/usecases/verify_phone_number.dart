import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class VerifyPhoneNumber extends UseCaseWithParams<void, String> {
  const VerifyPhoneNumber(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call(String param) =>
      _repo.verifyPhoneNumber(phoneNumber: param);
}
