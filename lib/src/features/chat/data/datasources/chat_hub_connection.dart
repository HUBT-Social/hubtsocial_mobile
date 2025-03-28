import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../../core/api/api_request.dart';

class ChatHubConnection {
  ChatHubConnection._();

  static Future<String> getAccessTokenFactory() async {
    UserToken userToken = await APIRequest.getUserToken(Hive);
    return userToken.accessToken;
  }

  static final httpOptions = HttpConnectionOptions(
      accessTokenFactory: getAccessTokenFactory, requestTimeout: 10000000);

  static final chatHubConnection = HubConnectionBuilder()
      .withUrl(
        EndPoint.chatHub,
        options: httpOptions,
      )
      // .withHubProtocol()
      .withAutomaticReconnect()
      // .withAutomaticReconnect()
      .build();

  static Future<void> initHubConnection() async {
    try {
      await chatHubConnection.start();

      chatHubConnection.onclose(({Exception? error}) {
        logger.w("Connection closed: ${error?.toString()}");
      });
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> stopHubConnection() async {
    await chatHubConnection.stop();
  }

  static Future<void> invokeSendItemChat(
      SendChatRequestModel sendChatRequestModel) async {
    chatHubConnection
        .invoke("SendItemChat", args: [sendChatRequestModel.toJson()]);
  }
}
