import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  getIt.init();
}
