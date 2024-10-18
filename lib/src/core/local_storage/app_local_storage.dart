import 'package:hive/hive.dart';

import 'local_storage_key.dart';

class AppLocalStorage {
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
}
