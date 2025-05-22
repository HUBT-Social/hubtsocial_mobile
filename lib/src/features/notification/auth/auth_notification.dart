import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_ce/hive.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/local_storage/local_storage_key.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';

@singleton
class AuthNotification {
  final DioClient _dioClient;

  AuthNotification(this._dioClient);

  Future<void> registerForNotifications() async {
    try {
      // Request notification permissions
      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      // Get FCM token
      final fcmToken = await FirebaseMessaging.instance.getToken();
      logger.d('FCM Token after login: $fcmToken');

      // Get user token from local storage
      var tokenBox = Hive.box(LocalStorageKey.token);
      if (tokenBox.containsKey(LocalStorageKey.userToken)) {
        UserToken userToken = tokenBox.get(LocalStorageKey.userToken);

        // Send FCM token to backend
        final response = await _dioClient.put(
          EndPoint.updateFcmToken,
          data: {"fcmToken": fcmToken},
          options: Options(
            headers: {'Authorization': 'Bearer ${userToken.accessToken}'},
          ),
        );

        if (response.statusCode == 200) {
          logger.i('FCM token successfully sent to backend');
        } else {
          logger
              .e('Failed to send FCM token to backend: ${response.statusCode}');
        }
      } else {
        logger.e('User token not found in local storage');
      }
    } catch (e) {
      logger.e('Error registering notifications: $e');
      rethrow;
    }
  }
}
