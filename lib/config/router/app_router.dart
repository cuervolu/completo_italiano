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

String getTitleForLocation(String location) {
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
  debugLogDiagnostics: false,
  initialLocation: '/',
  redirect: (context, state) {
    return null;
  },
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
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const Center(
                  child: Text('Crear Nueva Historia (Pendiente)'),
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: ':id',
              name: 'story_detail',
              pageBuilder: (context, state) {
                final storyId = state.pathParameters['id'];
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: Center(
                    child: Text('Detalle de Historia $storyId (Pendiente)'),
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
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
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const Center(
                  child: Text('Crear Nuevo Personaje (Pendiente)'),
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
            GoRoute(
              path: ':id',
              name: 'character_detail',
              pageBuilder: (context, state) {
                final characterId = state.pathParameters['id'];
                return CustomTransitionPage(
                  key: state.pageKey,
                  child: Center(
                    child: Text('Detalle de Personaje $characterId (Pendiente)'),
                  ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                );
              },
            ),
          ],
        ),

        // Favoritos
        GoRoute(
          path: '/favorites',
          name: 'favorites',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Center(child: Text('Favoritos (Pendiente)')),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        // Papelera
        GoRoute(
          path: '/trash',
          name: 'trash',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Center(child: Text('Papelera (Pendiente)')),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        // Búsqueda
        GoRoute(
          path: '/search',
          name: 'search',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Center(child: Text('Búsqueda (Pendiente)')),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        ),

        // Configuración
        GoRoute(
          path: '/settings',
          name: 'settings',
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const Center(child: Text('Configuración (Pendiente)')),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
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