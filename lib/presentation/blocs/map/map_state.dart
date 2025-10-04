import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState extends Equatable {
  const MapState();

  @override
  List<Object?> get props => [];
}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final Map<int, UserLocationMarker> userMarkers;
  final Set<Marker> markers;
  final LatLng? centerPosition;
  final bool isTrackingEnabled;
  final DateTime lastUpdate;

  const MapLoaded({
    required this.userMarkers,
    required this.markers,
    this.centerPosition,
    required this.isTrackingEnabled,
    required this.lastUpdate,
  });

  MapLoaded copyWith({
    Map<int, UserLocationMarker>? userMarkers,
    Set<Marker>? markers,
    LatLng? centerPosition,
    bool? isTrackingEnabled,
    DateTime? lastUpdate,
  }) {
    return MapLoaded(
      userMarkers: userMarkers ?? this.userMarkers,
      markers: markers ?? this.markers,
      centerPosition: centerPosition ?? this.centerPosition,
      isTrackingEnabled: isTrackingEnabled ?? this.isTrackingEnabled,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }

  @override
  List<Object?> get props => [userMarkers, markers, centerPosition, isTrackingEnabled, lastUpdate];
}

class MapError extends MapState {
  final String message;

  const MapError(this.message);

  @override
  List<Object?> get props => [message];
}

// ===== MODELO DE DATOS =====

class UserLocationMarker extends Equatable {
  final int userId;
  final String userName;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final DateTime timestamp;
  final bool isVisible;

  const UserLocationMarker({
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    required this.timestamp,
    this.isVisible = true,
  });

  LatLng get position => LatLng(latitude, longitude);

  String get statusText {
    final age = DateTime.now().difference(timestamp);
    if (age.inMinutes < 1) return 'Activo ahora';
    if (age.inMinutes < 5) return 'Hace ${age.inMinutes} min';
    if (age.inMinutes < 60) return 'Hace ${age.inMinutes} min';
    return 'Hace ${age.inHours}h';
  }

  bool get isOnline => DateTime.now().difference(timestamp).inMinutes < 5;

  UserLocationMarker copyWith({
    String? userName,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speed,
    double? heading,
    DateTime? timestamp,
    bool? isVisible,
  }) {
    return UserLocationMarker(
      userId: userId,
      userName: userName ?? this.userName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  @override
  List<Object?> get props => [userId, latitude, longitude, timestamp, isVisible];
}
