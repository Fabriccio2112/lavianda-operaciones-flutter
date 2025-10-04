import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/api_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(String name, String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FlutterSecureStorage secureStorage;
  
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.secureStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.login({
        'email': email,
        'password': password,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Guardar token
        if (data['token'] != null) {
          await secureStorage.write(key: _tokenKey, value: data['token']);
        }
        
        // Crear modelo de usuario
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Guardar usuario
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Credenciales inválidas');
      }
    } catch (e) {
      throw AuthException('Error al hacer login: $e');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await apiClient.dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        
        // Guardar token
        if (data['token'] != null) {
          await secureStorage.write(key: _tokenKey, value: data['token']);
        }
        
        // Crear modelo de usuario
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Guardar usuario
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Error al registrar usuario');
      }
    } catch (e) {
      throw AuthException('Error al registrar: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Llamar al endpoint de logout
      await apiClient.logout();
      
      // Eliminar token y datos de usuario
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _userKey);
    } catch (e) {
      // Aunque falle la petición, eliminar datos locales
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _userKey);
      throw AuthException('Error al hacer logout: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.getProfile();
      
      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Actualizar usuario guardado
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Error al obtener perfil');
      }
    } catch (e) {
      throw AuthException('Error al obtener usuario actual: $e');
    }
  }
}
