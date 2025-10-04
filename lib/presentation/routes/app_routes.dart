import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/map/map_screen.dart';
import '../screens/asistencia/asistencia_screen.dart';
import '../screens/formularios/formularios_list_screen.dart';
import '../screens/formularios/crear_formulario_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String map = '/map';
  static const String asistencia = '/asistencia';
  static const String formularios = '/formularios';
  static const String formulariosCrear = '/formularios/crear';
  static const String formulariosDetalle = '/formularios/detalle';

  static Map<String, WidgetBuilder> get routes => {
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        home: (context) => const HomeScreen(),
        map: (context) => const MapScreen(),
        asistencia: (context) => const AsistenciaScreen(),
        formularios: (context) => const FormulariosListScreen(),
        formulariosCrear: (context) => const CrearFormularioScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case formulariosDetalle:
        final id = settings.arguments as int?;
        if (id == null) {
          return null;
        }
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: Text('Formulario #$id')),
            body: Center(child: Text('Detalle del formulario #$id')),
          ),
        );
      default:
        return null;
    }
  }

  static String get initialRoute => login;
}
