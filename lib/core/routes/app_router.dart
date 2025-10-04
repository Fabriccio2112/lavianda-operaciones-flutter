import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/map/map_screen.dart';
import '../../presentation/screens/asistencia/asistencia_screen.dart';
import '../../presentation/screens/formularios/formularios_list_screen.dart';
import '../../presentation/screens/formularios/crear_formulario_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      // Auth routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app routes
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Map
      GoRoute(
        path: '/map',
        name: 'map',
        builder: (context, state) => const MapScreen(),
      ),

      // Asistencia
      GoRoute(
        path: '/asistencia',
        name: 'asistencia',
        builder: (context, state) => const AsistenciaScreen(),
      ),

      // Formularios
      GoRoute(
        path: '/formularios',
        name: 'formularios',
        builder: (context, state) => const FormulariosListScreen(),
        routes: [
          GoRoute(
            path: 'crear',
            name: 'formularios-crear',
            builder: (context, state) => const CrearFormularioScreen(),
          ),
          GoRoute(
            path: 'detalle/:id',
            name: 'formularios-detalle',
            builder: (context, state) {
              final id = state.pathParameters['id'];
              return Scaffold(
                appBar: AppBar(title: Text('Formulario #$id')),
                body: Center(child: Text('Detalle del formulario #$id')),
              );
            },
          ),
        ],
      ),

      // Admin (TODO: implement)
      GoRoute(
        path: '/admin',
        name: 'admin',
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: const Text('Panel Admin')),
          body: const Center(child: Text('Panel de Administración')),
        ),
      ),
    ],

    // Error page
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '¡Oops! Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.error?.toString() ?? 'Error desconocido'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Ir al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
}
