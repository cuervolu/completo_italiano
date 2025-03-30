import 'package:completo_italiano/config/theme/app_theme.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/providers/database_provider.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_providers.g.dart';

@riverpod
SettingsDao settingsDao(Ref ref) {
  final database = ref.watch(databaseProvider);
  return database.settingsDao;
}

@riverpod
Future<AppSetting?> appSettings(Ref ref) {
  final settingsDao = ref.watch(settingsDaoProvider);
  return settingsDao.getSettings();
}

@riverpod
Future<AppFont> selectedFont(Ref ref) async {
  final settings = await ref.watch(appSettingsProvider.future);

  if (settings == null || settings.fontStyle == null) {
    return AppFont.nunito;
  }

  try {
    return AppFont.values.firstWhere(
      (font) => font.name == settings.fontStyle,
      orElse: () => AppFont.nunito,
    );
  } catch (_) {
    return AppFont.nunito;
  }
}

@riverpod
Future<ThemeMode> themeMode(Ref ref) async {
  final settings = await ref.watch(appSettingsProvider.future);

  if (settings == null || settings.themeMode == null) {
    return ThemeMode.system;
  }

  switch (settings.themeMode) {
    case 'dark':
      return ThemeMode.dark;
    case 'light':
      return ThemeMode.light;
    default:
      return ThemeMode.system;
  }
}

@riverpod
Future<ThemeData> lightThemeWithFont(Ref ref) async {
  final font = await ref.watch(selectedFontProvider.future);
  return AppTheme.lightTheme(font: font);
}

@riverpod
Future<ThemeData> darkThemeWithFont(Ref ref) async {
  final font = await ref.watch(selectedFontProvider.future);
  return AppTheme.darkTheme(font: font);
}

Future<void> updateSelectedFont(WidgetRef ref, AppFont font) async {
  final settingsDao = ref.read(settingsDaoProvider);
  final settings = await ref.read(appSettingsProvider.future);

  if (settings != null) {
    await settingsDao.saveSettings(
      AppSettingsCompanion(
        id: drift.Value(settings.id),
        fontStyle: drift.Value(font.name),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  } else {
    await settingsDao.saveSettings(
      AppSettingsCompanion(fontStyle: drift.Value(font.name)),
    );
  }

  ref.invalidate(appSettingsProvider);
  ref.invalidate(selectedFontProvider);
}

Future<void> updateThemeMode(WidgetRef ref, ThemeMode mode) async {
  final settingsDao = ref.read(settingsDaoProvider);
  final settings = await ref.read(appSettingsProvider.future);

  String modeString;
  switch (mode) {
    case ThemeMode.dark:
      modeString = 'dark';
      break;
    case ThemeMode.light:
      modeString = 'light';
      break;
    default:
      modeString = 'system';
  }

  if (settings != null) {
    await settingsDao.saveSettings(
      AppSettingsCompanion(
        id: drift.Value(settings.id),
        themeMode: drift.Value(modeString),
        updatedAt: drift.Value(DateTime.now()),
      ),
    );
  } else {
    await settingsDao.saveSettings(
      AppSettingsCompanion(themeMode: drift.Value(modeString)),
    );
  }

  ref.invalidate(appSettingsProvider);
  ref.invalidate(themeModeProvider);
}
