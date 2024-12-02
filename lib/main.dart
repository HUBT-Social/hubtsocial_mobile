//dev
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_dev.dart'
    as firebaseDev;
//prod
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_prod.dart'
    as firebaseProd;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/my_app.dart';
import 'package:hubtsocial_mobile/src/core/configs/environment.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:loggy/loggy.dart';
import 'package:path_provider/path_provider.dart';
import 'src/core/injections/injections.dart';
import 'src/core/local_storage/local_storage_key.dart';
import 'src/core/notification/notification_service.dart';
import 'src/features/auth/data/models/user_token_model.dart';
import 'src/features/user/data/models/user_model.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await dotenv.load(fileName: Environment.fileName);

  await Future.wait([
    _initUniqueDeviceId(),
    _initLocalStorage(),
    _initLoggy(),
    _initNotification(),
    _initFirebase(),
  ]);

  await configureDependencies();

  runApp(const MyApp());
}

void registerAdapters() {
  Hive.registerAdapter(UserTokenModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
}

String _readAndroidDeviceInfo(AndroidDeviceInfo data) {
  return data.version.release +
      data.version.previewSdkInt.toString() +
      data.version.incremental +
      data.version.codename +
      data.brand +
      data.device +
      data.host +
      data.id +
      data.model +
      data.supportedAbis.toString();
}

String _readIosDeviceInfo(IosDeviceInfo data) {
  return data.name +
      data.systemName +
      data.systemVersion +
      data.model +
      data.localizedModel +
      data.identifierForVendor.toString() +
      data.isPhysicalDevice.toString() +
      data.utsname.sysname +
      data.utsname.nodename +
      data.utsname.release +
      data.utsname.version +
      data.utsname.machine;
}

Future<void> _initUniqueDeviceId() async {
  var deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    var iosDeviceInfo = await deviceInfo.iosInfo;
    AppLocalStorage.uniqueDeviceId =
        _readIosDeviceInfo(iosDeviceInfo).toString(); // unique ID on iOS
  } else if (Platform.isAndroid) {
    var androidDeviceInfo = await deviceInfo.androidInfo;
    AppLocalStorage.uniqueDeviceId = _readAndroidDeviceInfo(androidDeviceInfo);
  }
  AppLocalStorage.uniqueDeviceId =
      AppLocalStorage.uniqueDeviceId.replaceAll(RegExp(r"[^a-zA-Z0-9\s]"), "");
  logDebug("AppLocalStorage.uniqueDeviceId: ${AppLocalStorage.uniqueDeviceId}");
}

Future<void> _initLocalStorage() async {
  await Hive.initFlutter();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  registerAdapters();

  await Hive.openBox(LocalStorageKey.localStorage);
  await Hive.openBox('token');
  // await Hive.openBox('notification');
}

Future<void> _initLoggy() async {
  Loggy.initLoggy(
    logOptions: const LogOptions(
      LogLevel.all,
      stackTraceLevel: LogLevel.warning,
    ),
    logPrinter: const PrettyPrinter(showColors: true),
  );
}

Future<void> _initFirebase() async {
  if (kReleaseMode) {
    await Firebase.initializeApp(
      options: firebaseProd.DefaultFirebaseOptions.currentPlatform,
    );
  } else {
    await Firebase.initializeApp(
      options: firebaseDev.DefaultFirebaseOptions.currentPlatform,
    );
  }

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  final fcmToken = await FirebaseMessaging.instance.getToken();
  logDebug("fcmToken : $fcmToken");
}

Future<void> _initNotification() async {
  //FirebaseMessagingService().initialize();
  // AwesomeNotificationService.initialize();
  NotificationService.initialize();
}
