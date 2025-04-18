import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/repos/auth_repo.dart';

@LazySingleton()
class SignOut extends UseCaseWithoutParams<void> {
  const SignOut(this._repo);

  final AuthRepo _repo;

  @override
  ResultFuture<void> call() => _repo.signOut();
}
