import 'package:hubtsocial_mobile/src/core/utils/typedefs.dart';
import 'package:hubtsocial_mobile/src/features/home/module/data/models/module_response_model.dart';

abstract class ModuleRepo {
  const ModuleRepo();

  ResultFuture<List<ModuleResponseModel>> getModule();
}
