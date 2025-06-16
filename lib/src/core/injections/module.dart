import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';

@module
abstract class RegisterModule {
  @LazySingleton()
  HiveInterface get hive => Hive;

  @LazySingleton()
  FirebaseMessaging get firebaseMessaging => FirebaseMessaging.instance;

  @LazySingleton()
  Dio get dio {
    final dio = Dio();
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        var tokenBox = Hive.box(LocalStorageKey.token);
        if (tokenBox.containsKey(LocalStorageKey.userToken)) {
          UserToken token = tokenBox.get(LocalStorageKey.userToken);
          options.headers['Authorization'] = 'Bearer ${token.accessToken}';
        }
        return handler.next(options);
      },
    ));
    return dio;
  }

  @LazySingleton()
  Logger get logger => Logger();
}

class $RegisterModule extends RegisterModule {}
