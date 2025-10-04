import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/location_remote_datasource.dart';
import '../../data/datasources/location_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/track_location_usecase.dart';
import '../../domain/usecases/get_user_locations_usecase.dart';
import '../../presentation/blocs/auth/auth_bloc.dart';
import '../../presentation/blocs/location/location_bloc.dart';
import '../../presentation/blocs/map/map_bloc.dart';
import '../network/api_client.dart';
import '../network/websocket_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // =====================
  // Blocs
  // =====================
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    authRepository: sl(),
  ));
  sl.registerFactory(() => LocationBloc(
    trackLocationUseCase: sl(),
    getUserLocationsUseCase: sl(),
  ));
  sl.registerFactory(() => MapBloc(
    getUserLocationsUseCase: sl(),
    websocketClient: sl(),
  ));

  // =====================
  // Use Cases
  // =====================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => TrackLocationUseCase(sl()));
  sl.registerLazySingleton(() => GetUserLocationsUseCase(sl()));

  // =====================
  // Repositories
  // =====================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), secureStorage: sl()),
  );
  sl.registerLazySingleton<LocationRepository>(
    () => LocationRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // =====================
  // Data Sources
  // =====================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      apiClient: sl(),
      secureStorage: sl(),
    ),
  );
  sl.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<LocationLocalDataSource>(
    () => LocationLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // =====================
  // Core
  // =====================
  sl.registerLazySingleton(() => ApiClient(dio: sl(), secureStorage: sl()));
  sl.registerLazySingleton(() => WebSocketClient(secureStorage: sl()));
  
  // =====================
  // External
  // =====================
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  
  sl.registerLazySingleton(() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });
}
