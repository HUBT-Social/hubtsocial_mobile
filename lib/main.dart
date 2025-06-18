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
import 'package:timezone/data/latest.dart' as tz;

import 'src/core/injections/injections.dart';
import 'src/core/logger/logger.dart';

import 'package:hubtsocial_mobile/src/core/notification/FirebaseMessage.dart';
import 'package:hubtsocial_mobile/src/features/timetable/services/timetable_notification_service.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
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

  final timetableNotificationService = getIt<TimetableNotificationService>();
  await timetableNotificationService.scheduleNotificationsFromHive();

  runApp(const MyApp());
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

  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    }
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    return true;
  };

  final fcmToken = await FirebaseMessaging.instance.getToken();
  isInitializedFirebase = true;
  logger.d("fcmToken : $fcmToken");
}

Future<void> _initNotification() async {
  try {
    final firebaseMessage = FirebaseMessage();
    await firebaseMessage.initialize();
    logger.i('Firebase message service initialized');

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
