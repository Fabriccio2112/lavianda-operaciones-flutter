import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/location_model.dart';

abstract class LocationRemoteDataSource {
  Future<List<LocationModel>> getUserLocations();
  Future<void> saveLocation(LocationModel location);
  Future<void> checkIn(double lat, double lng);
  Future<List<LocationModel>> getUserLocationHistory(int userId);
}

class LocationRemoteDataSourceImpl implements LocationRemoteDataSource {
  final ApiClient apiClient;

  LocationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<LocationModel>> getUserLocations() async {
    try {
      final response = await apiClient.getAllUsersLocations();
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Manejar diferentes estructuras de respuesta
        List<dynamic> locationsJson;
        if (data is List) {
          locationsJson = data;
        } else if (data is Map<String, dynamic>) {
          locationsJson = data['locations'] ?? data['data'] ?? [];
        } else {
          locationsJson = [];
        }
        
        return locationsJson
            .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Error al obtener ubicaciones: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error al obtener ubicaciones: $e');
    }
  }

  @override
  Future<void> saveLocation(LocationModel location) async {
    try {
      final response = await apiClient.saveLocation(location.toJson());
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Error al guardar ubicación: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error al guardar ubicación: $e');
    }
  }

  @override
  Future<void> checkIn(double lat, double lng) async {
    try {
      final response = await apiClient.checkIn({
        'latitude': lat,
        'longitude': lng,
        'timestamp': DateTime.now().toIso8601String(),
      });
      
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Error al hacer check-in: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error al hacer check-in: $e');
    }
  }

  @override
  Future<List<LocationModel>> getUserLocationHistory(int userId) async {
    try {
      // Asumiendo que hay un endpoint para obtener historial
      final response = await apiClient.dio.get('/locations/user/$userId');
      
      if (response.statusCode == 200) {
        final data = response.data;
        List<dynamic> locationsJson;
        if (data is List) {
          locationsJson = data;
        } else if (data is Map<String, dynamic>) {
          locationsJson = data['locations'] ?? data['data'] ?? [];
        } else {
          locationsJson = [];
        }
        
        return locationsJson
            .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException('Error al obtener historial: ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error al obtener historial: $e');
    }
  }
}
