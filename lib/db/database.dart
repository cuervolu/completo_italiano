import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'daos/daos.dart';
import 'tables.dart';


part 'database.g.dart';

@DriftDatabase(
  tables: [
    Stories,
    Characters,
    CharacterImages,
    Concepts,
    Opinions,
    CharacterRelationships,
    CharacterDevelopment,
    CharacterRoles,
    StoryBoards,
    AppSettings,
  ],
  daos: [
    StoryDao,
    CharacterDao,
    RelationshipDao,
    DevelopmentDao,
    ImagesDao,
    ConceptsDao,
    OpinionsDao,
    StoryboardDao,
    SettingsDao,
    TrashDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'completo_italiano',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}