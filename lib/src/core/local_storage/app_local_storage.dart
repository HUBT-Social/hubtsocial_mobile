//dev
//prod

import 'package:hubtsocial_mobile/src/features/notification/model/notification_model.dart';
import 'package:hubtsocial_mobile/src/features/timetable/data/models/timetable_response_model.dart';

import '../logger/logger.dart';
import 'local_storage_key.dart';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/hive/hive_registrar.g.dart';

class AppLocalStorage {
  static String currentLanguageCode = "";
  static String uniqueDeviceId = "";
  static Box<dynamic> get localBox {
    if (!Hive.isBoxOpen(LocalStorageKey.localStorage)) {
      Hive.openBox(LocalStorageKey.localStorage);
    }
    return Hive.box(LocalStorageKey.localStorage);
  }

  static create(Map data) {
    localBox.add(data);
  }

  static dynamic get(dynamic key) {
    return localBox.get(key);
  }

  static update<E>(dynamic key, E data) {
    localBox.put(key, data);
  }

  static delete(dynamic key) {
    return localBox.delete(key);
  }

  static String getNowTime() {
    return DateTime.now().toString();
  }

  static bool isRegisterAdapters = false;

  Future<void> initLocalStorage() async {
    await Hive.initFlutter();
    if (!isRegisterAdapters) {
      Hive.registerAdapters();
      isRegisterAdapters = true;
    }

    // Mở các box
    await Future.wait([
      Hive.openBox(LocalStorageKey.localStorage),
      Hive.openBox(LocalStorageKey.token),
      Hive.openBox<NotificationModel>(
        LocalStorageKey.notification,
        compactionStrategy: (entries, deletedEntries) => deletedEntries > 50,
      ),
      Hive.openBox<TimetableResponseModel>(LocalStorageKey.timeTable),
    ]).then((_) {
      logger.d("Đã mở tất cả các box thành công");
    }).catchError((error) {
      logger.e("Lỗi khi mở box: $error");
    });
  }
}
