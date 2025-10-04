import 'package:equatable/equatable.dart';
import '../../../domain/entities/location.dart';

abstract class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object?> get props => [];
}

class LocationInitial extends LocationState {
  const LocationInitial();
}

class LocationLoading extends LocationState {
  const LocationLoading();
}

class LocationTrackingActive extends LocationState {
  final LocationEntity? currentLocation;
  final bool isTracking;

  const LocationTrackingActive({
    this.currentLocation,
    this.isTracking = true,
  });

  @override
  List<Object?> get props => [currentLocation, isTracking];

  LocationTrackingActive copyWith({
    LocationEntity? currentLocation,
    bool? isTracking,
  }) {
    return LocationTrackingActive(
      currentLocation: currentLocation ?? this.currentLocation,
      isTracking: isTracking ?? this.isTracking,
    );
  }
}

class LocationError extends LocationState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object?> get props => [message];
}

class LocationCheckInSuccess extends LocationState {
  const LocationCheckInSuccess();
}

class LocationsLoaded extends LocationState {
  final List<LocationEntity> locations;

  const LocationsLoaded({required this.locations});

  @override
  List<Object?> get props => [locations];
}
