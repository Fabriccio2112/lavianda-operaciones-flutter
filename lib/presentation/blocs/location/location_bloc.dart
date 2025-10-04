import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/usecases/get_user_locations_usecase.dart';
import '../../../domain/usecases/track_location_usecase.dart';
import '../../../data/models/location_model.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final TrackLocationUseCase trackLocationUseCase;
  final GetUserLocationsUseCase getUserLocationsUseCase;
  
  StreamSubscription<Position>? _positionStreamSubscription;
  Timer? _trackingTimer;

  LocationBloc({
    required this.trackLocationUseCase,
    required this.getUserLocationsUseCase,
  }) : super(const LocationInitial()) {
    on<StartLocationTrackingEvent>(_onStartLocationTracking);
    on<StopLocationTrackingEvent>(_onStopLocationTracking);
    on<UpdateLocationEvent>(_onUpdateLocation);
    on<CheckInEvent>(_onCheckIn);
    on<LoadUserLocationsEvent>(_onLoadUserLocations);
  }

  Future<void> _onStartLocationTracking(
    StartLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    // Verificar permisos
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final requestPermission = await Geolocator.requestPermission();
      if (requestPermission == LocationPermission.denied) {
        emit(const LocationError(message: 'Permisos de ubicación denegados'));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      emit(const LocationError(
        message: 'Permisos de ubicación denegados permanentemente',
      ));
      return;
    }

    // Iniciar tracking
    emit(const LocationTrackingActive(isTracking: true));

    // Escuchar cambios de posición
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Actualizar cada 10 metros
      ),
    ).listen((Position position) {
      // Enviar ubicación cada 30 segundos
      _trackingTimer ??= Timer.periodic(const Duration(seconds: 30), (_) {
        add(UpdateLocationEvent(
          location: LocationModel(
            userId: 0, // Se obtendrá del auth
            userName: 'Usuario', // Se obtendrá del auth
            latitude: position.latitude,
            longitude: position.longitude,
            accuracy: position.accuracy,
            speed: position.speed,
            heading: position.heading,
            timestamp: DateTime.now(),
            type: 'tracking',
          ),
        ));
      });
    });
  }

  Future<void> _onStopLocationTracking(
    StopLocationTrackingEvent event,
    Emitter<LocationState> emit,
  ) async {
    _positionStreamSubscription?.cancel();
    _trackingTimer?.cancel();
    _positionStreamSubscription = null;
    _trackingTimer = null;

    emit(const LocationInitial());
  }

  Future<void> _onUpdateLocation(
    UpdateLocationEvent event,
    Emitter<LocationState> emit,
  ) async {
    final result = await trackLocationUseCase.call(event.location);

    result.fold(
      (failure) {
        // No emitir error, solo registrar
        print('Error al guardar ubicación: ${failure.message}');
      },
      (_) {
        if (state is LocationTrackingActive) {
          emit((state as LocationTrackingActive).copyWith(
            currentLocation: event.location.toEntity(),
          ));
        }
      },
    );
  }

  Future<void> _onCheckIn(CheckInEvent event, Emitter<LocationState> emit) async {
    final currentState = state;
    emit(const LocationLoading());

    // Aquí deberías implementar el check-in en el repository
    // Por ahora solo emitimos éxito
    
    await Future.delayed(const Duration(seconds: 1));
    emit(const LocationCheckInSuccess());
    
    // Volver al estado anterior si estaba trackeando
    if (currentState is LocationTrackingActive) {
      emit(currentState);
    }
  }

  Future<void> _onLoadUserLocations(
    LoadUserLocationsEvent event,
    Emitter<LocationState> emit,
  ) async {
    emit(const LocationLoading());

    final result = await getUserLocationsUseCase.call();

    result.fold(
      (failure) => emit(LocationError(message: failure.message)),
      (locations) => emit(LocationsLoaded(locations: locations)),
    );
  }

  @override
  Future<void> close() {
    _positionStreamSubscription?.cancel();
    _trackingTimer?.cancel();
    return super.close();
  }
}
