import 'package:completo_italiano/config/logger/app_logger.dart';
import 'package:completo_italiano/config/theme/app_theme.dart';
import 'package:completo_italiano/providers/theme_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch theme providers
    final themeModeAsync = ref.watch(themeModeProvider);
    final lightThemeAsync = ref.watch(lightThemeWithFontProvider);
    final darkThemeAsync = ref.watch(darkThemeWithFontProvider);

    return MaterialApp(
      title: 'Completo Italiano',
      debugShowCheckedModeBanner: false,
      // Use async values with fallback defaults
      theme: lightThemeAsync.when(
        data: (theme) => theme,
        loading: () => AppTheme.lightTheme(),
        error: (_, __) {
          logger.e('Error loading light theme');
          return AppTheme.lightTheme();
        },
      ),
      darkTheme: darkThemeAsync.when(
        data: (theme) => theme,
        loading: () => AppTheme.darkTheme(),
        error: (_, __) {
          logger.e('Error loading dark theme');
          return AppTheme.darkTheme();
        },
      ),
      themeMode: themeModeAsync.when(
        data: (mode) => mode,
        loading: () => ThemeMode.system,
        error: (_, __) {
          logger.e('Error loading theme mode');
          return ThemeMode.system;
        },
      ),
      home: const ThemeTestPage(),
    );
  }
}

class ThemeTestPage extends ConsumerWidget {
  const ThemeTestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFontAsync = ref.watch(selectedFontProvider);
    final themeModeAsync = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Completo Italiano'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Tema e Tipografía',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Theme mode selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selección de Tema:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      themeModeAsync.when(
                        data:
                            (currentMode) => Column(
                              children: [
                                _buildThemeButton(
                                  context,
                                  ref,
                                  'Claro',
                                  ThemeMode.light,
                                  currentMode,
                                ),
                                const SizedBox(height: 8),
                                _buildThemeButton(
                                  context,
                                  ref,
                                  'Oscuro',
                                  ThemeMode.dark,
                                  currentMode,
                                ),
                                const SizedBox(height: 8),
                                _buildThemeButton(
                                  context,
                                  ref,
                                  'Sistema',
                                  ThemeMode.system,
                                  currentMode,
                                ),
                              ],
                            ),
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('Error al cargar el tema'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Font selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tipografía:', style: TextStyle(fontSize: 18)),
                      const SizedBox(height: 16),
                      selectedFontAsync.when(
                        data:
                            (selectedFont) => DropdownButtonFormField<AppFont>(
                              value: selectedFont,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              items:
                                  AppFont.values.map((font) {
                                    return DropdownMenuItem<AppFont>(
                                      value: font,
                                      child: Text(font.displayName),
                                    );
                                  }).toList(),
                              onChanged: (newFont) {
                                if (newFont != null) {
                                  updateSelectedFont(ref, newFont);
                                }
                              },
                            ),
                        loading: () => const CircularProgressIndicator(),
                        error:
                            (_, __) => const Text('Error al cargar la fuente'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Sample text preview
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Vista Previa:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Completo Italiano - Gestor de Personajes',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta es una aplicación para gestionar personajes, sus relaciones, desarrollo y más.',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tamaño pequeño para textos informativos.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '¡Esta es una página de prueba para temas y fuentes!',
              ),
            ),
          );
        },
        child: const Icon(Icons.info_outline),
      ),
    );
  }

  Widget _buildThemeButton(
    BuildContext context,
    WidgetRef ref,
    String label,
    ThemeMode mode,
    ThemeMode currentMode,
  ) {
    final isSelected = mode == currentMode;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => updateThemeMode(ref, mode),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surface,
          foregroundColor:
              isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyLarge?.color,
        ),
        child: Text(label),
      ),
    );
  }
}
