import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../logger/logger.dart';
import 'aes_cipher.dart';

class DeviceId {
  static String _uniqueDeviceId = "";

  static String getUniqueDeviceId() {
    return _uniqueDeviceId;
  }

  static String _readAndroidDeviceInfo(AndroidDeviceInfo data) {
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

  static String _readIosDeviceInfo(IosDeviceInfo data) {
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

  static Future<void> setupUniqueDeviceId() async {
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      _uniqueDeviceId =
          _readIosDeviceInfo(iosDeviceInfo).toString(); // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      _uniqueDeviceId = _readAndroidDeviceInfo(androidDeviceInfo);
    }

    var key = await FirebaseMessaging.instance.getToken();
    final cipher = AESCipher(key!);

    _uniqueDeviceId = cipher.encryptText(_uniqueDeviceId);

    logger.d("uniqueDeviceId: $_uniqueDeviceId");
  }
}
