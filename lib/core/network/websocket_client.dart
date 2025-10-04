import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../constants/app_constants.dart';

// Clase para definir los nombres de canales WebSocket
class WebSocketChannels {
  static const String tracking = 'tracking';
  static const String operaciones = 'operaciones';
  static const String adminDashboard = 'admin-dashboard';
  static String registro(int id) => 'registro.$id';
  static String formulario(int id) => 'formulario.$id';
}

class WebSocketClient {
  final FlutterSecureStorage secureStorage;
  late PusherChannelsFlutter pusher;
  bool _isInitialized = false;
  final Map<String, StreamController> _channelControllers = {};

  WebSocketClient({required this.secureStorage});

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      pusher = PusherChannelsFlutter.getInstance();

      await pusher.init(
        apiKey: AppConstants.wsAppKey,
        cluster: '', // No usado con servidor custom
        onConnectionStateChange: onConnectionStateChange,
        onError: onError,
        onSubscriptionSucceeded: onSubscriptionSucceeded,
        onEvent: onEvent,
        onSubscriptionError: onSubscriptionError,
        onDecryptionFailure: onDecryptionFailure,
        onMemberAdded: onMemberAdded,
        onMemberRemoved: onMemberRemoved,
        onAuthorizer: onAuthorizer,
        activityTimeout: 120000,
        pongTimeout: 30000,
      );

      await pusher.connect();
      _isInitialized = true;
      print('🔌 WebSocket conectado');
    } catch (e) {
      print('❌ Error inicializando WebSocket: $e');
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await pusher.disconnect();
      _isInitialized = false;
      _channelControllers.forEach((key, controller) {
        controller.close();
      });
      _channelControllers.clear();
      print('🔌 WebSocket desconectado');
    } catch (e) {
      print('❌ Error desconectando WebSocket: $e');
    }
  }

  // ===== SUSCRIPCIÓN A CANALES =====
  
  Stream<dynamic> subscribeToTracking() {
    return _subscribeToChannel(WebSocketChannels.tracking);
  }

  Stream<dynamic> subscribeToOperaciones() {
    return _subscribeToChannel(WebSocketChannels.operaciones);
  }

  Stream<dynamic> subscribeToAdminDashboard() {
    return _subscribeToChannel(WebSocketChannels.adminDashboard);
  }

  Stream<dynamic> subscribeToRegistro(int registroId) {
    return _subscribeToChannel(WebSocketChannels.registro(registroId));
  }

  Stream<dynamic> _subscribeToChannel(String channelName) {
    if (_channelControllers.containsKey(channelName)) {
      return _channelControllers[channelName]!.stream;
    }

    final controller = StreamController<dynamic>.broadcast();
    _channelControllers[channelName] = controller;

    pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        if (!controller.isClosed) {
          controller.add(jsonDecode(event.data));
        }
      },
    );

    print('📡 Suscrito al canal: $channelName');
    return controller.stream;
  }

  void unsubscribe(String channelName) {
    pusher.unsubscribe(channelName: channelName);
    _channelControllers[channelName]?.close();
    _channelControllers.remove(channelName);
    print('📡 Desuscrito del canal: $channelName');
  }

  // ===== CALLBACKS =====

  void onConnectionStateChange(dynamic currentState, dynamic previousState) {
    print('🔄 Estado conexión cambió: $previousState -> $currentState');
  }

  void onError(String message, int? code, dynamic e) {
    print('❌ Error WebSocket: $message (code: $code)');
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    print('✅ Suscripción exitosa: $channelName');
  }

  void onEvent(PusherEvent event) {
    print('📢 Evento recibido: ${event.eventName} en ${event.channelName}');
  }

  void onSubscriptionError(String message, dynamic e) {
    print('❌ Error de suscripción: $message');
  }

  void onDecryptionFailure(String event, String reason) {
    print('❌ Error de descifrado: $event - $reason');
  }

  void onMemberAdded(String channelName, PusherMember member) {
    print('👤 Miembro añadido en $channelName: ${member.userInfo}');
  }

  void onMemberRemoved(String channelName, PusherMember member) {
    print('👤 Miembro removido de $channelName: ${member.userInfo}');
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options) async {
    final token = await secureStorage.read(key: AppConstants.tokenKey);
    
    return {
      "auth": "",
      "channel_data": null,
      "shared_secret": null,
    };
  }
}
