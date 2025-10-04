import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/location_model.dart';
import '../entities/location.dart';

abstract class LocationRepository {
  /// Obtiene todas las ubicaciones de los usuarios
  Future<Either<Failure, List<LocationEntity>>> getUserLocations();
  
  /// Guarda una ubicación nueva
  Future<Either<Failure, void>> saveLocation(LocationModel location);
  
  /// Hace check-in en una ubicación
  Future<Either<Failure, void>> checkIn(double lat, double lng);
  
  /// Obtiene el historial de ubicaciones de un usuario específico
  Future<Either<Failure, List<LocationEntity>>> getUserLocationHistory(int userId);
  
  /// Obtiene las ubicaciones en caché (offline)
  Future<Either<Failure, List<LocationEntity>>> getCachedLocations();
}
