import 'package:completo_italiano/config/theme/app_theme.dart';
import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:drift/drift.dart';
import 'package:flutter/material.dart';

class SettingsRepository {
  final SettingsDao _settingsDao;

  SettingsRepository({required SettingsDao settingsDao})
    : _settingsDao = settingsDao;

  Future<AppSetting?> getSettings() {
    return _settingsDao.getSettings();
  }

  Future<int> saveSettings({
    String? defaultBackgroundImage,
    String? themeColor,
    AppFont? fontStyle,
    ThemeMode? themeMode,
    int? lastOpenedStoryId,
  }) async {
    final settings = await _settingsDao.getSettings();

    String? themeModeString;
    if (themeMode != null) {
      switch (themeMode) {
        case ThemeMode.light:
          themeModeString = 'light';
          break;
        case ThemeMode.dark:
          themeModeString = 'dark';
          break;
        case ThemeMode.system:
          themeModeString = 'system';
          break;
      }
    }

    final companion = AppSettingsCompanion(
      defaultBackgroundImage:
          defaultBackgroundImage != null
              ? Value(defaultBackgroundImage)
              : Value.absent(),
      themeColor: themeColor != null ? Value(themeColor) : Value.absent(),
      fontStyle: fontStyle != null ? Value(fontStyle.name) : Value.absent(),
      themeMode:
          themeModeString != null ? Value(themeModeString) : Value.absent(),
      lastOpenedStoryId:
          lastOpenedStoryId != null ? Value(lastOpenedStoryId) : Value.absent(),
      updatedAt: Value(DateTime.now()),
    );

    if (settings != null) {
      final updatedCompanion = companion.copyWith(id: Value(settings.id));
      return _settingsDao.saveSettings(updatedCompanion);
    } else {
      return _settingsDao.saveSettings(companion);
    }
  }

  Future<int> updateLastOpenedStory(int storyId) {
    return _settingsDao.updateLastOpenedStory(storyId);
  }

  Future<int> setThemeMode(ThemeMode mode) async {
    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      default:
        modeString = 'system';
        break;
    }

    final settings = await _settingsDao.getSettings();

    if (settings != null) {
      return _settingsDao.saveSettings(
        AppSettingsCompanion(
          id: Value(settings.id),
          themeMode: Value(modeString),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      return _settingsDao.saveSettings(
        AppSettingsCompanion(
          themeMode: Value(modeString),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }

  Future<int> setFontStyle(AppFont font) async {
    final settings = await _settingsDao.getSettings();

    if (settings != null) {
      return _settingsDao.saveSettings(
        AppSettingsCompanion(
          id: Value(settings.id),
          fontStyle: Value(font.name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      return _settingsDao.saveSettings(
        AppSettingsCompanion(
          fontStyle: Value(font.name),
          updatedAt: Value(DateTime.now()),
        ),
      );
    }
  }
}
