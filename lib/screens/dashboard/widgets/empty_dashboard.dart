import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EmptyDashboard extends StatelessWidget {
  const EmptyDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ícono o ilustración
          Icon(
            Icons.folder_open,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 24),

          // Mensaje principal
          Text(
            '¡Bienvenido a Completo Italiano!',
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Mensaje secundario
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              'No tienes ninguna historia creada todavía.\n'
              'Crea tu primera historia usando el botón inferior.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),

          // Botón opcional para crear historia directamente desde aquí
          OutlinedButton.icon(
            onPressed: () {
              // Navegar a la pantalla de creación de historia
              context.pushNamed('new_story');
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear Primera Historia'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
