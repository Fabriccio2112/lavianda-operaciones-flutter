import 'package:dartz/dartz.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/location.dart';
import '../../domain/repositories/location_repository.dart';
import '../datasources/location_local_datasource.dart';
import '../datasources/location_remote_datasource.dart';
import '../models/location_model.dart';

class LocationRepositoryImpl implements LocationRepository {
  final LocationRemoteDataSource remoteDataSource;
  final LocationLocalDataSource localDataSource;

  LocationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, List<LocationEntity>>> getUserLocations() async {
    try {
      final locations = await remoteDataSource.getUserLocations();
      
      // Guardar en caché
      await localDataSource.cacheLocations(locations);
      
      return Right(locations.map((location) => location.toEntity()).toList());
    } on ServerException catch (e) {
      // Si falla la petición, intentar obtener de caché
      try {
        final cachedLocations = await localDataSource.getCachedLocations();
        if (cachedLocations.isNotEmpty) {
          return Right(cachedLocations.map((location) => location.toEntity()).toList());
        }
        return Left(ServerFailure(e.message));
      } on CacheException {
        return Left(ServerFailure(e.message));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error inesperado: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveLocation(LocationModel location) async {
    try {
      await remoteDataSource.saveLocation(location);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al guardar ubicación: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> checkIn(double lat, double lng) async {
    try {
      await remoteDataSource.checkIn(lat, lng);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al hacer check-in: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getUserLocationHistory(int userId) async {
    try {
      final locations = await remoteDataSource.getUserLocationHistory(userId);
      return Right(locations.map((location) => location.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Error al obtener historial: $e'));
    }
  }

  @override
  Future<Either<Failure, List<LocationEntity>>> getCachedLocations() async {
    try {
      final cachedLocations = await localDataSource.getCachedLocations();
      return Right(cachedLocations.map((location) => location.toEntity()).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure('Error al obtener caché: $e'));
    }
  }
}
