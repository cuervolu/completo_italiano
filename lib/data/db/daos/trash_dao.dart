import 'package:completo_italiano/data/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'trash_dao.g.dart';

@DriftAccessor(
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
  ],
)
class TrashDao extends DatabaseAccessor<AppDatabase> with _$TrashDaoMixin {
  TrashDao(super.db);

  Future<int> moveToTrash<T extends Table, D>(
    TableInfo<T, D> table,
    int id,
  ) async {
    return customUpdate(
      'UPDATE ${table.actualTableName} SET deleted_at = ? WHERE id = ?',
      variables: [Variable.withDateTime(DateTime.now()), Variable.withInt(id)],
      updates: {table},
    );
  }

  Future<int> restoreFromTrash<T extends Table, D>(
    TableInfo<T, D> table,
    int id,
  ) async {
    return customUpdate(
      'UPDATE ${table.actualTableName} SET deleted_at = NULL WHERE id = ?',
      variables: [Variable.withInt(id)],
      updates: {table},
    );
  }
  Future<List<Future<D>>> getTrashItems<T extends Table, D>(TableInfo<T, D> table) {
    return (customSelect(
      'SELECT * FROM ${table.actualTableName} WHERE deleted_at IS NOT NULL',
      readsFrom: {table},
    )).map(table.mapFromRow).get();
  }

  Future<int> permanentlyDelete<T extends Table, D>(
    TableInfo<T, D> table,
    int id,
  ) {
    return customUpdate(
      'DELETE FROM ${table.actualTableName} WHERE id = ?',
      variables: [Variable.withInt(id)],
      updates: {table},
    );
  }
}
