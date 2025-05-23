import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';

class ChatHubConnection {
  ChatHubConnection._();

  static final HubConnection _chatHubConnection = HubConnectionBuilder()
      .withUrl(
        EndPoint.chatHub,
        options: HttpConnectionOptions(
          accessTokenFactory: getAccessTokenFactory,
          requestTimeout: 60000,
        ),
      )
      .withAutomaticReconnect()
      .build();

  static final DioClient _dioClient = getIt<DioClient>();

  static bool _isInitialized = false;
  static bool _isReconnecting = false;

  static Future<String> getAccessTokenFactory() async {
    try {
      final token = await _dioClient.getUserToken();
      return token.toString();
    } catch (e) {
      logger.e("❌ Error retrieving access token: $e");
      return "";
    }
  }

  static Future<void> initHubConnection() async {
    if (_isInitialized) {
      logger.w("⚠️ Hub already initialized");
      return;
    }
    _isInitialized = true;

    logger.i("🔌 Initializing SignalR hub connection to: ${EndPoint.chatHub}");

    _chatHubConnection.onclose(({Exception? error}) {
      logger
          .w("📴 Connection closed. Reason: ${error?.toString() ?? 'Unknown'}");
      _attemptReconnect();
    });

    _chatHubConnection.onreconnecting(({error}) {
      logger.w("🔁 Reconnecting... Error: ${error?.toString()}");
    });

    _chatHubConnection.onreconnected(({connectionId}) {
      logger.i("✅ Reconnected successfully. ConnectionId: $connectionId");
      _isReconnecting = false;
    });

    await _startConnection();
  }

  static Future<void> _startConnection() async {
    final state = _chatHubConnection.state;
    logger.d("📡 HubConnection state before start: $state");

    if (state == HubConnectionState.Connected ||
        state == HubConnectionState.Connecting) {
      logger.w("⏳ Already connecting or connected.");
      return;
    }

    try {
      logger.i("▶️ Starting SignalR connection...");
      await _chatHubConnection.start();
      logger.i("✅ SignalR connected. State: ${_chatHubConnection.state}");
    } catch (e) {
      logger.e("❌ Failed to start SignalR connection: $e");
    }
  }

  static Future<void> _attemptReconnect() async {
    if (_isReconnecting) {
      logger.w("🔁 Already attempting reconnect. Skipping...");
      return;
    }
    _isReconnecting = true;

    logger.d("🕒 Waiting 5 seconds to reconnect...");
    await Future.delayed(Duration(seconds: 5));

    try {
      if (_chatHubConnection.state == HubConnectionState.Disconnected) {
        logger.d("🔁 Reconnect: stopping any lingering connection...");
        await _chatHubConnection.stop(); // Ensure fully stopped
        logger.d("🔁 Reconnect: attempting fresh start...");
        await _chatHubConnection.start();
        logger.i("✅ Reconnect successful. State: ${_chatHubConnection.state}");
      }
    } catch (e) {
      logger.e("❌ Reconnect failed: $e");
    } finally {
      _isReconnecting = false;
    }
  }

  static Future<void> stopHubConnection() async {
    try {
      if (_chatHubConnection.state != HubConnectionState.Disconnected) {
        logger.d("🛑 Stopping SignalR connection...");
        await _chatHubConnection.stop();
        logger.d("✅ SignalR connection stopped.");
      } else {
        logger.i("⚠️ Hub was already stopped.");
      }
    } catch (e) {
      logger.e("❌ Failed to stop SignalR connection: $e");
    }
  }

  static Future<void> invokeSendItemChat(SendChatRequestModel model) async {
    try {
      logger.d("📤 Attempting to send message...");
      if (_chatHubConnection.state == HubConnectionState.Connected) {
        await _chatHubConnection.invoke("SendItemChat", args: [model.toJson()]);
        logger.d("✅ Message sent via SignalR.");
      } else {
        logger.w("⚠️ Cannot send message. Connection is not active.");
      }
    } catch (e) {
      logger.e("❌ Failed to send chat item: $e");
    }
  }

  static HubConnection get connection => _chatHubConnection;
}
