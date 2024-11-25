import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/entities/user.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/repos/user_repo.dart';

@LazySingleton()
class InitUserUserCase extends UseCaseWithoutParams<User> {
  const InitUserUserCase(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<User> call() => _repo.initUserProfile();
}
