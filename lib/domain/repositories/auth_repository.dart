import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login de usuario
  Future<Either<Failure, UserEntity>> login(String email, String password);
  
  /// Registro de nuevo usuario
  Future<Either<Failure, UserEntity>> register(String name, String email, String password);
  
  /// Logout de usuario
  Future<Either<Failure, void>> logout();
  
  /// Obtiene el usuario actual
  Future<Either<Failure, UserEntity>> getCurrentUser();
  
  /// Verifica si hay un token guardado
  Future<bool> hasToken();
  
  /// Guarda el token
  Future<void> saveToken(String token);
  
  /// Elimina el token
  Future<void> deleteToken();
}
