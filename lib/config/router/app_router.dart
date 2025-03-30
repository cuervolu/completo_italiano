import 'package:completo_italiano/config/logger/app_logger.dart';
import 'package:completo_italiano/core/widgets/app_shell.dart';
import 'package:completo_italiano/screens/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

// Mapeo de rutas a títulos para mantener consistencia
Map<String, String> routeTitles = {
  '/': 'Inicio',
  '/stories': 'Historias',
  '/stories/new': 'Nueva Historia',
  '/characters': 'Personajes',
  '/characters/new': 'Nuevo Personaje',
  '/settings': 'Configuración',
  '/favorites': 'Favoritos',
  '/trash': 'Papelera',
  '/search': 'Búsqueda',
};

// Función para obtener título según la ubicación
String getTitleForLocation(String location) {
  // Para rutas dinámicas como '/stories/:id'
  if (location.startsWith('/stories/') && !location.endsWith('/new')) {
    return 'Detalles de Historia';
  }
  if (location.startsWith('/characters/') && !location.endsWith('/new')) {
    return 'Detalles de Personaje';
  }

  return routeTitles[location] ?? 'Completo Italiano';
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    // Shell Route que aplicará AppShell a todas las rutas hijas
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        // Determinar título basado en la ubicación
        final location = state.matchedLocation;
        final title = getTitleForLocation(location);

        // Determinar si mostrar botón de retroceso
        final showBackButton =
            location != '/' &&
            location != '/stories' &&
            location != '/characters' &&
            location != '/settings';

        // Habilitar FAB solo en pantallas principales
        final enableFab =
            location == '/' ||
            location == '/stories' ||
            location == '/characters';

        return AppShell(
          title: title,
          showBackButton: showBackButton,
          enableFab: enableFab,
          child: child,
        );
      },
      routes: [
        // Pantalla de inicio (Dashboard)
        GoRoute(
          path: '/',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),

        // Rutas para historias (carpetas)
        GoRoute(
          path: '/stories',
          name: 'stories',
          builder:
              (context, state) =>
                  const Center(child: Text('Lista de Historias (Pendiente)')),
          routes: [
            GoRoute(
              path: 'new',
              name: 'new_story',
              builder:
                  (context, state) => const Center(
                    child: Text('Crear Nueva Historia (Pendiente)'),
                  ),
            ),
            GoRoute(
              path: ':id',
              name: 'story_detail',
              builder: (context, state) {
                final storyId = state.pathParameters['id'];
                return Center(
                  child: Text('Detalle de Historia $storyId (Pendiente)'),
                );
              },
            ),
          ],
        ),

        // Rutas para personajes
        GoRoute(
          path: '/characters',
          name: 'characters',
          builder:
              (context, state) =>
                  const Center(child: Text('Lista de Personajes (Pendiente)')),
          routes: [
            GoRoute(
              path: 'new',
              name: 'new_character',
              builder:
                  (context, state) => const Center(
                    child: Text('Crear Nuevo Personaje (Pendiente)'),
                  ),
            ),
            GoRoute(
              path: ':id',
              name: 'character_detail',
              builder: (context, state) {
                final characterId = state.pathParameters['id'];
                return Center(
                  child: Text('Detalle de Personaje $characterId (Pendiente)'),
                );
              },
            ),
          ],
        ),

        // Favoritos
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          builder:
              (context, state) =>
                  const Center(child: Text('Favoritos (Pendiente)')),
        ),

        // Papelera
        GoRoute(
          path: '/trash',
          name: 'trash',
          builder:
              (context, state) =>
                  const Center(child: Text('Papelera (Pendiente)')),
        ),

        // Búsqueda
        GoRoute(
          path: '/search',
          name: 'search',
          builder:
              (context, state) =>
                  const Center(child: Text('Búsqueda (Pendiente)')),
        ),

        // Configuración
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder:
              (context, state) =>
                  const Center(child: Text('Configuración (Pendiente)')),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    logger.e('Error de navegación: ${state.error}');
    return AppShell(
      title: 'Error',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada: ${state.uri.toString()}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al Inicio'),
            ),
          ],
        ),
      ),
    );
  },
);
