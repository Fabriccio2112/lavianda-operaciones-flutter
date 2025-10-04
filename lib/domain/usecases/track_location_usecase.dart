import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../data/models/location_model.dart';
import '../repositories/location_repository.dart';

class TrackLocationUseCase {
  final LocationRepository repository;

  TrackLocationUseCase(this.repository);

  Future<Either<Failure, void>> call(LocationModel location) async {
    return await repository.saveLocation(location);
  }
}
