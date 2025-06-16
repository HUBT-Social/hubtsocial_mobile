import 'package:hubtsocial_mobile/src/features/user/data/models/user_model.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/user/domain/repos/user_repo.dart';

@lazySingleton
class GetUserByUsernameUserCase
    extends UseCaseWithParams<void, GetUserByUsernameParams> {
  final UserRepo _repo;

  GetUserByUsernameUserCase(this._repo);

  @override
  ResultFuture<UserModel> call(GetUserByUsernameParams param) =>
      _repo.getUserByUsername(userName: param.username);
}

class GetUserByUsernameParams {
  final String username;

  GetUserByUsernameParams({required this.username});
}
