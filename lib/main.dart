import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hubtsocial_mobile/src/core/app/my_app.dart';
import 'package:hubtsocial_mobile/src/core/configs/environment.dart';
import 'package:loggy/loggy.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

//dev
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_dev.dart'
    as firebaseDev;
//prod
import 'package:hubtsocial_mobile/src/core/firebase/firebase_options_prod.dart'
    as firebaseProd;

import 'src/core/local_storage/local_storage_key.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: Environment.fileName);

  await _initLoggy();

  await _initFirebase();

  await _initLocalStorage();

  runApp(const MyApp());
}

Future<void> _initLocalStorage() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.openBox(LocalStorageKey.localStorage);
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
