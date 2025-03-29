import 'package:completo_italiano/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'development_dao.g.dart';

@DriftAccessor(tables: [CharacterDevelopment])
class DevelopmentDao extends DatabaseAccessor<AppDatabase> with _$DevelopmentDaoMixin {
  DevelopmentDao(super.db);

  Future<List<CharacterDevelopmentData>> getDevelopmentByCharacterId(
    int characterId,
  ) {
    return (select(characterDevelopment)
          ..where(
            (tbl) =>
                tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.stageOrder)]))
        .get();
  }

  Future<List<CharacterDevelopmentData>> getDevelopmentByStageType(
    int characterId,
    String stageType,
  ) {
    return (select(characterDevelopment)
          ..where(
            (tbl) =>
                tbl.characterId.equals(characterId) &
                tbl.stageType.equals(stageType) &
                tbl.deletedAt.isNull(),
          )
          ..orderBy([(t) => OrderingTerm(expression: t.stageOrder)]))
        .get();
  }

  Future<int> insertDevelopment(CharacterDevelopmentCompanion data) {
    return into(characterDevelopment).insert(data);
  }

  Future<bool> updateDevelopment(CharacterDevelopmentCompanion data) {
    return update(characterDevelopment).replace(data);
  }

  Future<int> deleteDevelopment(int id) {
    return db.trashDao.moveToTrash(characterDevelopment, id);
  }
}