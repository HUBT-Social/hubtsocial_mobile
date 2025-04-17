import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';

import '../../local_storage/app_local_storage.dart';
import '../../presentation/dialog/app_dialog.dart';

class HiveProvider {
  static Future<Box> openNotiBox() async {
    if (!await Hive.boxExists('notifications')) {
      await Hive.openBox('notifications');
    }
    if (!Hive.isBoxOpen('notifications')) {
      await Hive.openBox('notifications');
    }
    return Hive.box('notifications');
  }

  static void addNotification() async {
    var notiBox = await openNotiBox();
    if (!notiBox.containsKey('unReadNotiCount')) {
      notiBox.put('unReadNotiCount', 1);
    } else {
      notiBox.put('unReadNotiCount', notiBox.get('unReadNotiCount') + 1);
    }
  }

  static void subtractNotification() async {
    var notiBox = await openNotiBox();
    if (!notiBox.containsKey('unReadNotiCount')) {
      notiBox.put('unReadNotiCount', 0);
    } else {
      notiBox.put(
          'unReadNotiCount',
          notiBox.get('unReadNotiCount') != 0
              ? notiBox.get('unReadNotiCount') - 1
              : 0);
    }
  }

  static void clearAllNotification() async {
    var notiBox = await openNotiBox();
    notiBox.put('unReadNotiCount', 0);
  }

  static void initNotification(int count) async {
    var notiBox = await openNotiBox();
    notiBox.put('unReadNotiCount', count);
  }

  static void clearToken(VoidCallback callback) {
    AppDialog.showLoadingDialog(message: 'Logging out');

    Hive.deleteFromDisk().then((_) {
      AppLocalStorage().initLocalStorage();

      Timer(
        const Duration(seconds: 1),
        () {
          AppDialog.closeDialog();
          callback();
        },
      );
    });
  }
}
