import 'package:completo_italiano/config/logger/app_logger.dart';
import 'package:completo_italiano/config/router/app_router.dart';
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

    return MaterialApp.router(
      title: 'Completo Italiano',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
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
          logger.e('Error loading theme mode!');
          return ThemeMode.system;
        },
      ),
    );
  }
}
