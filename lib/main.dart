//dev
import 'package:hubtsocial_mobile/src/core/extensions/device_id.dart';
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_dev.dart'
    as firebaseDev;
//prod
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_prod.dart'
    as firebaseProd;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubtsocial_mobile/src/core/app/my_app.dart';
import 'package:hubtsocial_mobile/src/constants/environment.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/app_local_storage.dart';
import 'package:hubtsocial_mobile/src/core/notification/NotificationService.dart';

import 'src/core/injections/injections.dart';
import 'src/core/logger/logger.dart';

import 'package:hubtsocial_mobile/src/core/notification/FirebaseMessage.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;

  await Environment.initialize();
  await AppLocalStorage().initLocalStorage();

  await Future.wait([
    configureDependencies(),
    initFirebase(),
  ]);

  await Future.wait([
    DeviceId.setupUniqueDeviceId(),
    _initNotification(),
  ]);

  // Khởi tạo background service
  //await TimetableBackgroundService.initialize();
  //await TimetableBackgroundService.schedulePeriodicTask();

  getIt<TimetableNotificationService>().scheduleNotificationsFromHive();
  runApp(MyApp());
}

bool isInitializedFirebase = false;

Future<void> initFirebase() async {
  if (isInitializedFirebase) {
    logger.d("Firebase already initialized");
    return;
  }
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
  isInitializedFirebase = true;
  logger.d("fcmToken : $fcmToken");
}

Future<void> _initNotification() async {
  try {
    // Initialize FirebaseMessage first
    final firebaseMessage = FirebaseMessage();
    await firebaseMessage.initialize();
    logger.i('Firebase message service initialized');

    // Then initialize NotificationService
    final notificationService = NotificationService();
    if (NavigationService.navigatorKey.currentContext != null) {
      await notificationService
          .initialize(NavigationService.navigatorKey.currentContext!);
      logger.i('Notification service initialized');

      logger.i('Timetable service initialized');
    } else {
      logger.e('Context not available for notification initialization');
    }
  } catch (e) {
    logger.e('Error initializing notifications: $e');
  }
}
