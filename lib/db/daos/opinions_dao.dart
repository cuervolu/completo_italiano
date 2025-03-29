import 'package:completo_italiano/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'opinions_dao.g.dart';

@DriftAccessor(tables: [Opinions])
class OpinionsDao extends DatabaseAccessor<AppDatabase> with _$OpinionsDaoMixin {
  OpinionsDao(super.db);

  Future<List<Opinion>> getOpinionsByCharacterId(int characterId) {
    return (select(opinions)..where(
      (tbl) => tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<List<Opinion>> getOpinionsAboutCharacter(int aboutCharacterId) {
    return (select(opinions)..where(
      (tbl) =>
          tbl.aboutCharacterId.equals(aboutCharacterId) &
          tbl.deletedAt.isNull(),
    )).get();
  }

  Future<Opinion?> getSpecificOpinion(int characterId, int aboutCharacterId) {
    return (select(opinions)..where(
      (tbl) =>
          tbl.characterId.equals(characterId) &
          tbl.aboutCharacterId.equals(aboutCharacterId) &
          tbl.deletedAt.isNull(),
    )).getSingleOrNull();
  }

  Future<int> insertOpinion(OpinionsCompanion data) {
    return into(opinions).insert(data);
  }

  Future<bool> updateOpinion(OpinionsCompanion data) {
    return update(opinions).replace(data);
  }

  Future<int> deleteOpinion(int id) {
    return db.trashDao.moveToTrash(opinions, id);
  }
}