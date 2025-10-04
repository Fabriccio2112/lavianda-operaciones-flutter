import '../../domain/entities/location.dart';

class LocationModel {
  final int? id;
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
  final String? sessionId;
  final String? deviceInfo;

  LocationModel({
    this.id,
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
    this.sessionId,
    this.deviceInfo,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'],
      userId: json['user_id'] ?? 0,
      userName: json['user_name'] ?? 
                (json['user'] != null ? json['user']['name'] : 'Usuario Desconocido'),
      latitude: (json['latitude'] ?? json['lat'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? json['lng'] ?? 0).toDouble(),
      accuracy: json['accuracy']?.toDouble(),
      speed: json['speed']?.toDouble(),
      heading: json['heading']?.toDouble(),
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'])
          : (json['recorded_at'] != null 
              ? DateTime.parse(json['recorded_at'])
              : DateTime.now()),
      address: json['address'],
      type: json['type'] ?? 'tracking',
      sessionId: json['session_id'],
      deviceInfo: json['device_info'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'latitude': latitude,
      'longitude': longitude,
      if (accuracy != null) 'accuracy': accuracy,
      if (speed != null) 'speed': speed,
      if (heading != null) 'heading': heading,
      'timestamp': timestamp.toIso8601String(),
      if (address != null) 'address': address,
      'type': type,
      if (sessionId != null) 'session_id': sessionId,
      if (deviceInfo != null) 'device_info': deviceInfo,
    };
  }

  LocationEntity toEntity() {
    return LocationEntity(
      id: id ?? 0,
      userId: userId,
      userName: userName,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      speed: speed,
      heading: heading,
      timestamp: timestamp,
      address: address,
      type: type,
    );
  }

  factory LocationModel.fromEntity(LocationEntity entity) {
    return LocationModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      accuracy: entity.accuracy,
      speed: entity.speed,
      heading: entity.heading,
      timestamp: entity.timestamp,
      address: entity.address,
      type: entity.type,
    );
  }

  LocationModel copyWith({
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
    String? sessionId,
    String? deviceInfo,
  }) {
    return LocationModel(
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
      sessionId: sessionId ?? this.sessionId,
      deviceInfo: deviceInfo ?? this.deviceInfo,
    );
  }
}
