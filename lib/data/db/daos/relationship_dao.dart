import 'package:completo_italiano/data/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'relationship_dao.g.dart';

@DriftAccessor(tables: [CharacterRelationships])
class RelationshipDao extends DatabaseAccessor<AppDatabase> with _$RelationshipDaoMixin {
  RelationshipDao(super.db);

  Future<List<CharacterRelationship>> getRelationshipsByCharacterId(
    int characterId,
  ) {
    return (select(characterRelationships)..where(
      (tbl) => tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<List<CharacterRelationship>> getRelationshipsWithCharacterId(
    int characterId,
  ) {
    return (select(characterRelationships)..where(
      (tbl) =>
          tbl.relatedCharacterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<int> insertRelationship(CharacterRelationshipsCompanion data) {
    return into(characterRelationships).insert(data);
  }

  Future<bool> updateRelationship(CharacterRelationshipsCompanion data) {
    return update(characterRelationships).replace(data);
  }

  Future<int> deleteRelationship(int id) {
    return db.trashDao.moveToTrash(characterRelationships, id);
  }
}