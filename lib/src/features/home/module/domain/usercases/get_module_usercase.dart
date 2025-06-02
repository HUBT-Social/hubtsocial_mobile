import 'package:equatable/equatable.dart';
import 'package:hubtsocial_mobile/src/core/data/domain/usecases/usecases.dart';
import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';
import 'package:hubtsocial_mobile/src/features/home/module/domain/repos/module_repo.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class GetModuleUserCase extends UseCaseWithParams<void, GetModuleParams> {
  const GetModuleUserCase(this._repo);
  final ModuleRepo _repo;
  @override
  ResultFuture<List<ModuleResponseModel>> call(GetModuleParams param) =>
      _repo.getModule();
}

class GetModuleParams extends Equatable {
  const GetModuleParams();

  @override
  List<String> get props => [];
}
