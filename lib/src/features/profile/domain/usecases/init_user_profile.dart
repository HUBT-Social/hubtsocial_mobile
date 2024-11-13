import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/entities/user.dart';
import 'package:hubtsocial_mobile/src/features/profile/domain/repos/user_profile_repo.dart';

@LazySingleton()
class InitUserProfile extends UseCaseWithoutParams<LocalUser> {
  const InitUserProfile(this._repo);

  final UserRepo _repo;

  @override
  ResultFuture<LocalUser> call() => _repo.initUserProfile();
}
