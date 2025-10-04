/// Constantes de la aplicación
class AppConstants {
  // API - Servidor en Producción
  static const String baseUrl = 'https://operaciones.lavianda.com.co';
  static const String apiUrl = '$baseUrl/api';
  static const String storageUrl = '$baseUrl/storage';
  
  // Google Maps
  static const String googleMapsApiKey = 'AIzaSyBrbXX5PmDsDY2O6COmRmevJj1R1IC1L7E';
  
  // WebSocket (Laravel Reverb) - Servidor en Producción
  static const String wsHost = 'operaciones.lavianda.com.co';
  static const int wsPort = 8080;
  static const String wsAppKey = 'operaciones-key-2025';
  static const String wsAppId = 'operaciones-app';
  static const String wsAppSecret = 'operaciones-secret-2025';
  static const String wsScheme = 'wss'; // WebSocket Secure (HTTPS)
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String rememberMeKey = 'remember_me';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Map
  static const double defaultZoom = 15.0;
  static const double trackingZoom = 18.0;
  
  // Location
  static const int locationUpdateInterval = 30000; // 30 segundos
  static const double minimumDistanceFilter = 10.0; // metros
  
  // Cache
  static const Duration cacheTimeout = Duration(minutes: 5);
  
  // Image
  static const int maxImageSize = 1024; // KB
  static const int imageQuality = 85;
  
  // PDF
  static const String pdfTitle = 'Acta de Inicio - LaVianda';
  static const String pdfAuthor = 'LaVianda Operaciones';
}

/// Endpoints de la API
class ApiEndpoints {
  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String refreshToken = '/refresh';
  
  // Profile
  static const String updateProfile = '/profile';
  static const String updatePhoto = '/profile/photo';
  
  // Empresas
  static const String empresas = '/empresas';
  static const String createEmpresa = '/empresas';
  
  // Registros
  static const String registros = '/registros-clientes';
  static const String createRegistro = '/registros-clientes';
  
  // Formularios
  static const String formularios = '/formularios-acta-inicio';
  static const String createFormulario = '/formularios-acta-inicio';
  
  // Location
  static const String locations = '/locations';
  static const String checkin = '/checkin';
  static const String lastCheckin = '/last-checkin';
  
  // Admin
  static const String users = '/admin/users';
  static const String tracking = '/admin/user-tracking';
  
  // WebSocket Auth
  static const String broadcasting = '/broadcasting/auth';
}

/// Canales de WebSocket
class WebSocketChannels {
  static const String operaciones = 'operaciones';
  static const String asistencias = 'asistencias';
  static const String adminDashboard = 'admin-dashboard';
  static const String onlineUsers = 'online-users';
  
  static String registro(int id) => 'registro.$id';
  static String formulario(int id) => 'formulario.$id';
}

/// Eventos de WebSocket
class WebSocketEvents {
  static const String formularioCreado = 'formulario.creado';
  static const String formularioActualizado = 'formulario.actualizado';
  static const String asistenciaMarcada = 'asistencia.marcada';
}
