//dev
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_dev.dart'
    as firebaseDev;
//prod
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_prod.dart'
    as firebaseProd;

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/my_app.dart';
import 'package:hubtsocial_mobile/src/constants/environment.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/models/class_schedule.dart';

import 'src/core/injections/injections.dart';
import 'src/core/local_storage/local_storage_key.dart';
import 'src/core/logger/logger.dart';
import 'src/core/notification/notification_service.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/hive/hive_registrar.g.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Future.wait([
    dotenv.load(fileName: Environment.fileName),
    configureDependencies(),
  ]);

  await Future.wait([
    _initUniqueDeviceId(),
    _initFirebase(),
    _initLocalStorage(),
  ]);

  runApp(MyApp());

  await _initNotification();
}

Future<void> _initLocalStorage() async {
  await Hive.initFlutter();

  Hive.registerAdapters();

  // Mở các box
  await Future.wait([
    Hive.openBox(LocalStorageKey.localStorage),
    Hive.openBox(LocalStorageKey.token),
    Hive.openBox<NotificationModel>(
      'notifications',
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
    ),
    Hive.openBox<ClassSchedule>(
      'class_schedules',
      compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
    ),
  ]).then((_) {
    print("Đã mở tất cả các box thành công");
  }).catchError((error) {
    print("Lỗi khi mở box: $error");
  });
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
  try {
    // Initialize NotificationService
    final notificationService = NotificationService();
    if (NavigationService.navigatorKey.currentContext != null) {
      await notificationService
          .initialize(NavigationService.navigatorKey.currentContext!);
      logger.i('Notification service initialized');

      logger.i('Timetable service initialized');
    } else {
      logger.w('Context not available for notification initialization');
    }
  } catch (e) {
    logger.e('Error initializing notifications: $e');
  }
}
