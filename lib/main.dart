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
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';

import 'package:path_provider/path_provider.dart';
import 'src/core/constants/hive_type_id.dart';
import 'src/core/injections/injections.dart';
import 'src/core/local_storage/local_storage_key.dart';
import 'src/core/logger/logger.dart';
import 'src/core/notification/firebase_message.dart';
import 'src/core/notification/local_message.dart';
import 'src/features/auth/data/models/user_token_model.dart';
import 'src/features/user/data/models/user_model.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await dotenv.load(fileName: Environment.fileName);

  await configureDependencies();

  await Future.wait([
    _initUniqueDeviceId(),
    _initFirebase(),
    _initLocalStorage(),
  ]);

  await _initNotification();

  runApp(const MyApp());
}

Future<void> _initLocalStorage() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(appDocumentDirectory.path);

  // Đăng ký adapter
  if (!Hive.isAdapterRegistered(HiveTypeId.notification)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }

  // Đăng ký các adapter khác
  registerAdapters();

  // Mở các box cơ bản
  await Hive.openBox(LocalStorageKey.localStorage);
  await Hive.openBox(LocalStorageKey.token);

  // Mở box notifications với compact mode
  print("Đang mở box notifications");
  try {
    final box = await Hive.openBox<NotificationModel>('notifications',
        compactionStrategy: (entries, deletedEntries) => deletedEntries > 50);
    print("Đã mở box notifications thành công: ${box.name}");
  } catch (e) {
    print("Lỗi khi mở box notifications: $e");
  }
}

// Tách riêng hàm registerAdapters
void registerAdapters() {
  if (!Hive.isAdapterRegistered(HiveTypeId.notification)) {
    Hive.registerAdapter(NotificationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeId.userTokenModel)) {
    Hive.registerAdapter(UserTokenModelAdapter());
  }
  if (!Hive.isAdapterRegistered(HiveTypeId.userModel)) {
    Hive.registerAdapter(UserModelAdapter());
  }
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

  logger.d("AppLocalStorage.uniqueDeviceId: ${AppLocalStorage.uniqueDeviceId}");
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

  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };

  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

  final fcmToken = await FirebaseMessaging.instance.getToken();

  logger.d("fcmToken : $fcmToken");
}

Future<void> _initNotification() async {
  FirebaseMessage().initNotification();
  LocalMessage().initLocalNotifications();
}
