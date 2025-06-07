import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.config.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  // Register Logger before getIt.init()
  getIt.registerLazySingleton<Logger>(() => Logger());

  getIt.init();
}
