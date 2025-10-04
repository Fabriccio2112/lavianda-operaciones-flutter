import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final int id;
  final int userId;
  final String userName;
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? speed;
  final double? heading;
  final DateTime timestamp;
  final String? address;
  final String type;

  const LocationEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.speed,
    this.heading,
    required this.timestamp,
    this.address,
    this.type = 'tracking',
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        latitude,
        longitude,
        accuracy,
        speed,
        heading,
        timestamp,
        address,
        type,
      ];

  bool get isOnline {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inMinutes < 5;
  }

  LocationEntity copyWith({
    int? id,
    int? userId,
    String? userName,
    double? latitude,
    double? longitude,
    double? accuracy,
    double? speed,
    double? heading,
    DateTime? timestamp,
    String? address,
    String? type,
  }) {
    return LocationEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      address: address ?? this.address,
      type: type ?? this.type,
    );
  }
}
