import 'package:completo_italiano/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [AppSettings])
class SettingsDao extends DatabaseAccessor<AppDatabase> with _$SettingsDaoMixin {
  SettingsDao(super.db);

  Future<AppSetting?> getSettings() {
    return (select(appSettings)..limit(1)).getSingleOrNull();
  }

  Future<int> saveSettings(AppSettingsCompanion data) async {
    final settings = await getSettings();
    if (settings != null) {
      return (update(appSettings)
        ..where((tbl) => tbl.id.equals(settings.id))).write(data);
    } else {
      return into(appSettings).insert(data);
    }
  }

  Future<int> updateLastOpenedStory(int storyId) async {
    final settings = await getSettings();
    if (settings != null) {
      return (update(appSettings)
        ..where((tbl) => tbl.id.equals(settings.id))).write(
        AppSettingsCompanion(
          lastOpenedStoryId: Value(storyId),
          updatedAt: Value(DateTime.now()),
        ),
      );
    } else {
      return into(
        appSettings,
      ).insert(AppSettingsCompanion(lastOpenedStoryId: Value(storyId)));
    }
  }
}