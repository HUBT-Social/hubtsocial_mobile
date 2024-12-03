import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../local_storage/local_storage_key.dart';
import '../../presentation/dialog/app_dialog.dart';

class HiveProvider {
  static Future<Box> openNotiBox() async {
    if (!await Hive.boxExists('notification')) {
      await Hive.openBox('notification');
    }
    if (!Hive.isBoxOpen('notification')) {
      await Hive.openBox('notification');
    }
    return Hive.box('notification');
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
    var tokenBox = Hive.box(LocalStorageKey.token);
    AppDialog.showLoadingDialog(message: 'Logging out');
    tokenBox.clear().then((_) {
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
