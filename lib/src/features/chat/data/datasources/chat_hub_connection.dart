import 'package:hubtsocial_mobile/src/constants/end_point.dart';
import 'package:hubtsocial_mobile/src/core/logger/logger.dart';
import 'package:hubtsocial_mobile/src/features/chat/data/models/send_chat_request_model.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../../../../core/api/dio_client.dart';
import 'package:hubtsocial_mobile/src/core/injections/injections.dart';

class ChatHubConnection {
  ChatHubConnection._();

  static final _httpConnectionOptions = HttpConnectionOptions(
    accessTokenFactory: getAccessTokenFactory,
    // requestTimeout: 1000,
  );

  static final HubConnection _chatHubConnection = HubConnectionBuilder()
      .withUrl(
        EndPoint.chatHub,
        options: _httpConnectionOptions,
      )
      .withAutomaticReconnect()
      .build();

  static final DioClient _dioClient = getIt<DioClient>();

  static bool _isReconnecting = false;

  static final Map<String, List<MethodInvocationFunc>> _registeredEvents = {};

  static Future<String> getAccessTokenFactory() async {
    try {
      final token = await _dioClient.getUserToken();
      return token.toString();
    } catch (e) {
      logger.e("❌ Error retrieving access token: $e");
      return "";
    }
  }

  // Đăng ký sự kiện và lưu lại
  static void on(String methodName, MethodInvocationFunc callback) {
    if (_chatHubConnection.state != HubConnectionState.Disconnected) {
      initHubConnection();
    }
    _chatHubConnection.on(methodName, callback);
    if (_registeredEvents[methodName] == null) {
      _registeredEvents[methodName] = [];
    }
    _registeredEvents[methodName]?.add(callback);
  }

  // Hủy đăng ký sự kiện và xóa khỏi map
  static void off(String methodName, {MethodInvocationFunc? method}) {
    _chatHubConnection.off(methodName, method: method);

    if (_registeredEvents.containsKey(methodName)) {
      if (method != null) {
        _registeredEvents[methodName]?.remove(method);
      } else {
        _registeredEvents.remove(methodName);
      }
    }
  }

  // Nạp lại các sự kiện đã lưu
  static void _reloadRegisteredEvents() {
    _registeredEvents.forEach((event, listCallbacks) {
      for (var callback in listCallbacks) {
        _chatHubConnection.on(event, callback);
      }
    });
  }

  static Future<void> initHubConnection() async {
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
      _reloadRegisteredEvents(); // Nạp lại các sự kiện khi kết nối lại
    });

    await _startConnection();
    _reloadRegisteredEvents(); // Nạp lại các sự kiện khi kết nối thành công lần đầu
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
      _reloadRegisteredEvents(); // Nạp lại các sự kiện sau khi start thành công
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
    await Future.delayed(const Duration(seconds: 5));

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
}
