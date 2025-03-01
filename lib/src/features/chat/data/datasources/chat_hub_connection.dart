import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/auth/domain/entities/user_token.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/message_response_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:hubtsocial_mobile/src/features/chat/presentation/bloc/receive_chat/receive_chat_cubit.dart';
import 'package:hubtsocial_mobile/src/router/router.import.dart';
import 'package:signalr_netcore/signalr_client.dart';

import '../../../../core/api/api_request.dart';

class ChatHubConnection {
  ChatHubConnection._();

  static Future<String> getAccessTokenFactory() async {
    UserToken userToken = await APIRequest.getUserToken(Hive);
    return userToken.accessToken;
  }

  static final httpOptions = HttpConnectionOptions(
      accessTokenFactory: getAccessTokenFactory, requestTimeout: 1000000000);

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

      if (chatHubConnection.state == HubConnectionState.Connected) {
        chatHubConnection.on("ReceiveChat", _handleReceiveChat);
        chatHubConnection.on("ReceiveProcess", _handleReceiveProcess);
      }
    } catch (e) {
      logger.e(e);
    }
  }

  static Future<void> stopHubConnection() async {
    await chatHubConnection.stop();
  }

  static void _handleReceiveChat(List<Object?>? arguments) {
    final message =
        MessageResponseModel.fromJson(arguments![0] as Map<String, dynamic>);

    navigatorKey.currentContext
        ?.read<ReceiveChatCubit>()
        .receiveMessage(message);
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
