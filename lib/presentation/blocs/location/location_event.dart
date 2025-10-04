import 'package:equatable/equatable.dart';
import '../../../data/models/location_model.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class StartLocationTrackingEvent extends LocationEvent {
  const StartLocationTrackingEvent();
}

class StopLocationTrackingEvent extends LocationEvent {
  const StopLocationTrackingEvent();
}

class UpdateLocationEvent extends LocationEvent {
  final LocationModel location;

  const UpdateLocationEvent({required this.location});

  @override
  List<Object?> get props => [location];
}

class CheckInEvent extends LocationEvent {
  final double latitude;
  final double longitude;

  const CheckInEvent({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class LoadUserLocationsEvent extends LocationEvent {
  const LoadUserLocationsEvent();
}
