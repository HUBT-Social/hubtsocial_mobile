import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

@module
abstract class RegisterModule {
  @LazySingleton()
  HiveInterface get hive => Hive;

  @LazySingleton()
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  // @LazySingleton()
  // FirebaseStorage get firebaseStorage => FirebaseStorage.instance;
}

class $RegisterModule extends RegisterModule {}
