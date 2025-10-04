import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/app_constants.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;

  ApiClient({required this.dio, required this.secureStorage}) {
    _configureDio();
  }

  void _configureDio() {
    dio.options.baseUrl = AppConstants.apiUrl;
    dio.options.connectTimeout = AppConstants.connectionTimeout;
    dio.options.receiveTimeout = AppConstants.receiveTimeout;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Interceptor para agregar token automáticamente
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await secureStorage.read(key: AppConstants.tokenKey);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expirado - hacer logout
          await secureStorage.delete(key: AppConstants.tokenKey);
          await secureStorage.delete(key: AppConstants.userKey);
        }
        return handler.next(error);
      },
    ));
  }

  // ===== AUTH =====
  Future<Response> login(String email, String password) {
    return dio.post(ApiEndpoints.login, data: {
      'email': email,
      'password': password,
    });
  }

  Future<Response> register(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.register, data: data);
  }

  Future<Response> logout() {
    return dio.post(ApiEndpoints.logout);
  }

  Future<Response> getUser() {
    return dio.get(ApiEndpoints.user);
  }

  // ===== LOCATION =====
  Future<Response> saveLocation(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.locations, data: data);
  }

  Future<Response> getLocations({int? limit}) {
    return dio.get(ApiEndpoints.locations, queryParameters: {
      if (limit != null) 'limit': limit,
    });
  }

  Future<Response> checkIn(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.checkin, data: data);
  }

  Future<Response> getLastCheckIn() {
    return dio.get(ApiEndpoints.lastCheckin);
  }

  // ===== FORMULARIOS =====
  Future<Response> getFormularios({int page = 1}) {
    return dio.get(ApiEndpoints.formularios, queryParameters: {
      'page': page,
      'per_page': AppConstants.itemsPerPage,
    });
  }

  Future<Response> createFormulario(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.createFormulario, data: data);
  }

  Future<Response> getFormulario(int id) {
    return dio.get('${ApiEndpoints.formularios}/$id');
  }

  Future<Response> updateFormulario(int id, Map<String, dynamic> data) {
    return dio.put('${ApiEndpoints.formularios}/$id', data: data);
  }

  // ===== EMPRESAS =====
  Future<Response> getEmpresas() {
    return dio.get(ApiEndpoints.empresas);
  }

  Future<Response> createEmpresa(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.createEmpresa, data: data);
  }

  // ===== REGISTROS =====
  Future<Response> getRegistros({int page = 1}) {
    return dio.get(ApiEndpoints.registros, queryParameters: {
      'page': page,
      'per_page': AppConstants.itemsPerPage,
    });
  }

  Future<Response> createRegistro(Map<String, dynamic> data) {
    return dio.post(ApiEndpoints.createRegistro, data: data);
  }

  // ===== ADMIN =====
  Future<Response> getUsers() {
    return dio.get(ApiEndpoints.users);
  }

  Future<Response> getUserTracking(int userId, {String? date}) {
    return dio.get('${ApiEndpoints.tracking}/$userId', queryParameters: {
      if (date != null) 'date': date,
    });
  }

  Future<Response> getAllUsersLocations() {
    return dio.get('${ApiEndpoints.tracking}/all');
  }
}
