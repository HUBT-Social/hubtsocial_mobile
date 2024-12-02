import 'package:hive_flutter/adapters.dart';

import 'local_storage_key.dart';

class AppLocalStorage {
  static String currentLanguageCode = "";
  static String uniqueDeviceId = "";
  static final localBox = Hive.box(LocalStorageKey.localStorage);

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

  String removeSpecialCharacters(String str) {
    return str.replaceAll(RegExp(r"[^a-zA-Z0-9\s]"), "");
  }

  static String getNowTime() {
    return DateTime.now().toString();
  }
}
