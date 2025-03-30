import 'package:completo_italiano/providers/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: theme.colorScheme.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Completo Italiano',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tu biblioteca de personajes',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Icon(
                      Icons.brightness_4,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Tema',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const Spacer(),
                    ThemeModeButton(
                      mode: ThemeMode.light,
                      icon: Icons.wb_sunny_outlined,
                    ),
                    ThemeModeButton(
                      mode: ThemeMode.dark,
                      icon: Icons.nights_stay_outlined,
                    ),
                    ThemeModeButton(
                      mode: ThemeMode.system,
                      icon: Icons.brightness_auto,
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Inicio (Dashboard)
                _buildDrawerItem(
                  context: context,
                  icon: Icons.home,
                  title: 'Inicio',
                  route: '/',
                  currentRoute: currentRoute,
                ),

                // Historias
                _buildDrawerItem(
                  context: context,
                  icon: Icons.book,
                  title: 'Historias',
                  route: '/stories',
                  currentRoute: currentRoute,
                ),

                // Personajes
                _buildDrawerItem(
                  context: context,
                  icon: Icons.people,
                  title: 'Personajes',
                  route: '/characters',
                  currentRoute: currentRoute,
                ),

                // Favoritos
                _buildDrawerItem(
                  context: context,
                  icon: Icons.star,
                  title: 'Favoritos',
                  route: '/favorites',
                  currentRoute: currentRoute,
                ),

                const Divider(),

                // Papelera
                _buildDrawerItem(
                  context: context,
                  icon: Icons.delete_outline,
                  title: 'Papelera',
                  route: '/trash',
                  currentRoute: currentRoute,
                ),

                // Configuración
                _buildDrawerItem(
                  context: context,
                  icon: Icons.settings,
                  title: 'Configuración',
                  route: '/settings',
                  currentRoute: currentRoute,
                ),
              ],
            ),
          ),

          // Pie del drawer
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Row(
              children: [
                Text(
                  'v0.1.0',
                  style: TextStyle(
                    color: theme.textTheme.bodySmall?.color?.withValues(
                      alpha: 0.6,
                    ),
                    fontSize: 12,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.help_outline, size: 20),
                  onPressed: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Completo Italiano',
                      applicationVersion: '0.1.0',
                      applicationIcon: const FlutterLogo(),
                      applicationLegalese: '© 2025',
                      children: [
                        const SizedBox(height: 16),
                        const Text(
                          'Una aplicación para gestionar personajes de historias.',
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required String currentRoute,
  }) {
    final isSelected = currentRoute == route;
    final theme = Theme.of(context);

    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
      ),
      title: Text(
        title,
        style: TextStyle(
          color:
              isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyLarge?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      selectedColor: theme.colorScheme.primary,
      onTap: () {
        if (!isSelected) {
          Navigator.pop(context);
          context.go(route);
        }
      },
    );
  }
}

class ThemeModeButton extends ConsumerWidget {
  final ThemeMode mode;
  final IconData icon;

  const ThemeModeButton({super.key, required this.mode, required this.icon});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: Icon(icon, size: 20, color: Colors.white),
      onPressed: () {
        updateThemeMode(ref, mode);
      },
    );
  }
}
