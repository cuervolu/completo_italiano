import 'package:completo_italiano/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'concepts_dao.g.dart';

@DriftAccessor(tables: [Concepts])
class ConceptsDao extends DatabaseAccessor<AppDatabase> with _$ConceptsDaoMixin {
  ConceptsDao(super.db);

  Future<List<Concept>> getConceptsByCharacterId(int characterId) {
    return (select(concepts)..where(
      (tbl) => tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<int> insertConcept(ConceptsCompanion data) {
    return into(concepts).insert(data);
  }

  Future<bool> updateConcept(ConceptsCompanion data) {
    return update(concepts).replace(data);
  }

  Future<int> deleteConcept(int id) {
    return db.trashDao.moveToTrash(concepts, id);
  }
}