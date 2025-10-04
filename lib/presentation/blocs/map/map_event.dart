import 'package:equatable/equatable.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();

  @override
  List<Object?> get props => [];
}

class InitializeMapEvent extends MapEvent {}

class LoadAllUserLocationsEvent extends MapEvent {}

class SubscribeToTrackingEvent extends MapEvent {}

class UnsubscribeFromTrackingEvent extends MapEvent {}

class LocationUpdateReceivedEvent extends MapEvent {
  final int userId;
  final String userName;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final DateTime timestamp;

  const LocationUpdateReceivedEvent({
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [userId, latitude, longitude, timestamp];
}

class CenterMapOnUserEvent extends MapEvent {
  final int userId;

  const CenterMapOnUserEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class CenterMapOnCurrentLocationEvent extends MapEvent {}

class ToggleUserVisibilityEvent extends MapEvent {
  final int userId;

  const ToggleUserVisibilityEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateMapCameraEvent extends MapEvent {
  final double latitude;
  final double longitude;
  final double zoom;

  const UpdateMapCameraEvent({
    required this.latitude,
    required this.longitude,
    required this.zoom,
  });

  @override
  List<Object?> get props => [latitude, longitude, zoom];
}
