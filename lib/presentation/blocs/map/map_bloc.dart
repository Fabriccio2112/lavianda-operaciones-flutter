import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:equatable/equatable.dart';
import '../../../core/network/websocket_client.dart';
import '../../../domain/usecases/get_user_locations_usecase.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetUserLocationsUseCase getUserLocationsUseCase;
  final WebSocketClient websocketClient;
  StreamSubscription? _trackingSubscription;

  MapBloc({
    required this.getUserLocationsUseCase,
    required this.websocketClient,
  }) : super(MapInitial()) {
    on<InitializeMapEvent>(_onInitializeMap);
    on<LoadAllUserLocationsEvent>(_onLoadAllUserLocations);
    on<SubscribeToTrackingEvent>(_onSubscribeToTracking);
    on<UnsubscribeFromTrackingEvent>(_onUnsubscribeFromTracking);
    on<LocationUpdateReceivedEvent>(_onLocationUpdateReceived);
    on<CenterMapOnUserEvent>(_onCenterMapOnUser);
    on<ToggleUserVisibilityEvent>(_onToggleUserVisibility);
    on<UpdateMapCameraEvent>(_onUpdateMapCamera);
  }

  // ===== INICIALIZAR MAPA =====
  Future<void> _onInitializeMap(
    InitializeMapEvent event,
    Emitter<MapState> emit,
  ) async {
    emit(MapLoading());
    
    try {
      // Inicializar WebSocket
      await websocketClient.init();
      
      // Cargar ubicaciones iniciales
      add(LoadAllUserLocationsEvent());
      
      // Suscribirse a tracking en tiempo real
      add(SubscribeToTrackingEvent());
    } catch (e) {
      emit(MapError('Error al inicializar mapa: $e'));
    }
  }

  // ===== CARGAR TODAS LAS UBICACIONES =====
  Future<void> _onLoadAllUserLocations(
    LoadAllUserLocationsEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      final result = await getUserLocationsUseCase.call();
      
      result.fold(
        (failure) => emit(MapError(failure.message)),
        (locations) {
          final Map<int, UserLocationMarker> userMarkers = {};
          
          // Agrupar ubicaciones por usuario y tomar la más reciente
          for (final location in locations) {
            if (!userMarkers.containsKey(location.userId) ||
                location.timestamp.isAfter(userMarkers[location.userId]!.timestamp)) {
              userMarkers[location.userId] = UserLocationMarker(
                userId: location.userId,
                userName: location.userName,
                latitude: location.latitude,
                longitude: location.longitude,
                accuracy: location.accuracy,
                speed: location.speed,
                heading: location.heading,
                timestamp: location.timestamp,
              );
            }
          }

          final markers = _createMarkers(userMarkers);
          
          emit(MapLoaded(
            userMarkers: userMarkers,
            markers: markers,
            centerPosition: userMarkers.isNotEmpty
                ? userMarkers.values.first.position
                : null,
            isTrackingEnabled: true,
            lastUpdate: DateTime.now(),
          ));
        },
      );
    } catch (e) {
      emit(MapError('Error al cargar ubicaciones: $e'));
    }
  }

  // ===== SUSCRIBIRSE A TRACKING EN TIEMPO REAL =====
  Future<void> _onSubscribeToTracking(
    SubscribeToTrackingEvent event,
    Emitter<MapState> emit,
  ) async {
    try {
      final stream = websocketClient.subscribeToTracking();
      
      _trackingSubscription = stream.listen((data) {
        print('📍 Ubicación recibida por WebSocket: $data');
        
        add(LocationUpdateReceivedEvent(
          userId: data['user_id'],
          userName: data['user_name'],
          latitude: data['latitude'].toDouble(),
          longitude: data['longitude'].toDouble(),
          accuracy: data['accuracy']?.toDouble(),
          speed: data['speed']?.toDouble(),
          heading: data['heading']?.toDouble(),
          timestamp: DateTime.parse(data['timestamp']),
        ));
      });
      
      print('✅ Suscrito a tracking en tiempo real');
    } catch (e) {
      print('❌ Error al suscribirse a tracking: $e');
    }
  }

  // ===== DESUSCRIBIRSE DE TRACKING =====
  Future<void> _onUnsubscribeFromTracking(
    UnsubscribeFromTrackingEvent event,
    Emitter<MapState> emit,
  ) async {
    await _trackingSubscription?.cancel();
    _trackingSubscription = null;
    websocketClient.unsubscribe('tracking');
    print('🔕 Desuscrito de tracking');
  }

  // ===== RECIBIR ACTUALIZACIÓN DE UBICACIÓN =====
  void _onLocationUpdateReceived(
    LocationUpdateReceivedEvent event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final updatedMarkers = Map<int, UserLocationMarker>.from(currentState.userMarkers);

      // Actualizar o añadir marcador del usuario
      updatedMarkers[event.userId] = UserLocationMarker(
        userId: event.userId,
        userName: event.userName,
        latitude: event.latitude,
        longitude: event.longitude,
        accuracy: event.accuracy,
        speed: event.speed,
        heading: event.heading,
        timestamp: event.timestamp,
        isVisible: updatedMarkers[event.userId]?.isVisible ?? true,
      );

      final markers = _createMarkers(updatedMarkers);

      emit(currentState.copyWith(
        userMarkers: updatedMarkers,
        markers: markers,
        lastUpdate: DateTime.now(),
      ));

      print('✅ Marcador actualizado para usuario ${event.userId}: ${event.userName}');
    }
  }

  // ===== CENTRAR MAPA EN USUARIO =====
  void _onCenterMapOnUser(
    CenterMapOnUserEvent event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final userMarker = currentState.userMarkers[event.userId];

      if (userMarker != null) {
        emit(currentState.copyWith(
          centerPosition: userMarker.position,
        ));
      }
    }
  }

  // ===== TOGGLE VISIBILIDAD DE USUARIO =====
  void _onToggleUserVisibility(
    ToggleUserVisibilityEvent event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      final updatedMarkers = Map<int, UserLocationMarker>.from(currentState.userMarkers);

      if (updatedMarkers.containsKey(event.userId)) {
        final marker = updatedMarkers[event.userId]!;
        updatedMarkers[event.userId] = marker.copyWith(
          isVisible: !marker.isVisible,
        );

        final markers = _createMarkers(updatedMarkers);

        emit(currentState.copyWith(
          userMarkers: updatedMarkers,
          markers: markers,
        ));
      }
    }
  }

  // ===== ACTUALIZAR CÁMARA DEL MAPA =====
  void _onUpdateMapCamera(
    UpdateMapCameraEvent event,
    Emitter<MapState> emit,
  ) {
    if (state is MapLoaded) {
      final currentState = state as MapLoaded;
      emit(currentState.copyWith(
        centerPosition: LatLng(event.latitude, event.longitude),
      ));
    }
  }

  // ===== HELPER: CREAR MARCADORES =====
  Set<Marker> _createMarkers(Map<int, UserLocationMarker> userMarkers) {
    return userMarkers.values
        .where((marker) => marker.isVisible)
        .map((marker) => Marker(
              markerId: MarkerId('user_${marker.userId}'),
              position: marker.position,
              infoWindow: InfoWindow(
                title: marker.userName,
                snippet: '${marker.statusText}${marker.speed != null ? " • ${marker.speed!.toStringAsFixed(1)} km/h" : ""}',
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                marker.isOnline
                    ? BitmapDescriptor.hueGreen
                    : BitmapDescriptor.hueRed,
              ),
              rotation: marker.heading ?? 0,
              anchor: const ui.Offset(0.5, 0.5),
            ))
        .toSet();
  }

  @override
  Future<void> close() {
    _trackingSubscription?.cancel();
    return super.close();
  }
}
