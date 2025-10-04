import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../models/location_model.dart';

abstract class LocationLocalDataSource {
  Future<List<LocationModel>> getCachedLocations();
  Future<void> cacheLocations(List<LocationModel> locations);
  Future<void> clearCache();
}

class LocationLocalDataSourceImpl implements LocationLocalDataSource {
  static const String _cachedLocationsKey = 'cached_locations';
  final SharedPreferences sharedPreferences;

  LocationLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<LocationModel>> getCachedLocations() async {
    try {
      final jsonString = sharedPreferences.getString(_cachedLocationsKey);
      
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> jsonList = jsonDecode(jsonString);
        return jsonList
            .map((json) => LocationModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      throw CacheException('Error al obtener ubicaciones en caché: $e');
    }
  }

  @override
  Future<void> cacheLocations(List<LocationModel> locations) async {
    try {
      final jsonList = locations.map((location) => location.toJson()).toList();
      final jsonString = jsonEncode(jsonList);
      await sharedPreferences.setString(_cachedLocationsKey, jsonString);
    } catch (e) {
      throw CacheException('Error al guardar ubicaciones en caché: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await sharedPreferences.remove(_cachedLocationsKey);
    } catch (e) {
      throw CacheException('Error al limpiar caché: $e');
    }
  }
}
