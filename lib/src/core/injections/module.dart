import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@module
abstract class RegisterModule {
  @preResolve
  @LazySingleton()
  Future<SharedPreferences> get prefs async => SharedPreferences.getInstance();

  @LazySingleton()
  HiveInterface get hive => Hive;

  @LazySingleton()
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  // @LazySingleton()
  // FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
}

class $RegisterModule extends RegisterModule {}
