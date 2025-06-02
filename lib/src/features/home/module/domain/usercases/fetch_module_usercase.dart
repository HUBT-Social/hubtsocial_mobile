import 'package:chatview/chatview.dart';
import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/domain/repos/module_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class FetchModuleUserCase extends UseCaseWithParams<void, FetchModuleParams> {
  const FetchModuleUserCase(this._repo);
  final ModuleRepo _repo;
  @override
  ResultFuture<List<Message>> call(FetchModuleParams param) =>
      _repo.fetchModule(roomId: param.roomId);
}

class FetchModuleParams extends Equatable {
  const FetchModuleParams({
    required this.roomId,
  });
  const FetchModuleParams.empty() : roomId = "";
  final String roomId;

  @override
  List<String> get props => [roomId];
}
