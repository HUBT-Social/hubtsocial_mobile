import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/message_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../../core/api/api_request.dart';

typedef ReceiveChatCallback = void Function(MessageResponseModel message);

class ChatHubConnection {
  ChatHubConnection._();

  static Future<String> getAccessTokenFactory() async {
    UserToken userToken = await APIRequest.getUserToken(Hive);
    return userToken.accessToken;
  }

  static final httpOptions =
      HttpConnectionOptions(accessTokenFactory: getAccessTokenFactory);

  static final chatHubConnection = HubConnectionBuilder()
      .withUrl(
        EndPoint.chatHub,
        options: httpOptions,
      )
      // .withHubProtocol()
      .withAutomaticReconnect()
      // .withAutomaticReconnect()
      .build();

  static ReceiveChatCallback? _onReceiveChatCallback;

  static Future<void> initHubConnection(
      {ReceiveChatCallback? onReceiveChat}) async {
    _onReceiveChatCallback = onReceiveChat;
    await chatHubConnection.start();

    chatHubConnection.onclose(({Exception? error}) {
      logger.w("Connection closed: ${error?.toString()}");
    });

    if (chatHubConnection.state == HubConnectionState.Connected) {
      chatHubConnection.on("ReceiveChat", _handleReceiveChat);
      chatHubConnection.on("ReceiveProcess", _handleReceiveProcess);
    }
  }

  static Future<void> stopHubConnection() async {
    await chatHubConnection.stop();
  }

  static void _handleReceiveChat(List<Object?>? arguments) {
    final message =
        MessageResponseModel.fromJson(arguments![0] as Map<String, dynamic>);
    _onReceiveChatCallback?.call(message);
  }

  static void _handleReceiveProcess(List<Object?>? arguments) {
    logger.i(arguments);
  }

  static Future<void> invokeSendItemChat(
      SendChatRequestModel sendChatRequestModel) async {
    chatHubConnection
        .invoke("SendItemChat", args: [sendChatRequestModel.toJson()]);
  }
}
