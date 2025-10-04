import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/location.dart';
import '../repositories/location_repository.dart';

class GetUserLocationsUseCase {
  final LocationRepository repository;

  GetUserLocationsUseCase(this.repository);

  Future<Either<Failure, List<LocationEntity>>> call() async {
    return await repository.getUserLocations();
  }
}
