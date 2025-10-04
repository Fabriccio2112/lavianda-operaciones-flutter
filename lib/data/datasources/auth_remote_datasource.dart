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
  static const String _userKey = 'auth_user';

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    required this.secureStorage,
  });

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await apiClient.login(email, password);
      
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'] ?? data['access_token'];
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Guardar token y usuario
        await secureStorage.write(key: _tokenKey, value: token);
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Error al hacer login');
      }
    } catch (e) {
      throw AuthException('Error al hacer login: $e');
    }
  }

  @override
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await apiClient.dio.post('/api/register', data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['token'] ?? data['access_token'];
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Guardar token y usuario
        await secureStorage.write(key: _tokenKey, value: token);
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Error al registrar');
      }
    } catch (e) {
      throw AuthException('Error al registrar: $e');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.dio.post('/api/logout');
      
      // Eliminar token y usuario guardado
      await secureStorage.delete(key: _tokenKey);
      await secureStorage.delete(key: _userKey);
      
      // Eliminar también de SharedPreferences si existe
      await secureStorage.delete(key: 'jwt_token');
      await secureStorage.delete(key: 'user_data');
    } catch (e) {
      throw AuthException('Error al hacer logout: $e');
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await apiClient.dio.get('/api/user/profile');
      
      if (response.statusCode == 200) {
        final data = response.data;
        final user = UserModel.fromJson(data['user'] ?? data);
        
        // Actualizar usuario guardado
        await secureStorage.write(key: _userKey, value: user.toJson().toString());
        
        return user;
      } else {
        throw AuthException('Error al obtener usuario');
      }
    } catch (e) {
      throw AuthException('Error al obtener usuario: $e');
    }
  }
}
