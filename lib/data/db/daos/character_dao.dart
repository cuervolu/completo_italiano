import 'package:completo_italiano/data/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'character_dao.g.dart';

@DriftAccessor(tables: [Characters, CharacterRoles])
class CharacterDao extends DatabaseAccessor<AppDatabase>
    with _$CharacterDaoMixin {
  CharacterDao(super.db);

  Future<List<Character>> getAllCharacters() {
    return (select(characters)..where((tbl) => tbl.deletedAt.isNull())).get();
  }

  Future<List<Character>> getCharactersByStory(int storyId) {
    return (select(characters)..where(
      (tbl) => tbl.storyId.equals(storyId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<Character?> getCharacterById(int id) {
    return (select(characters)..where(
      (tbl) => tbl.id.equals(id) & tbl.deletedAt.isNull(),
    )).getSingleOrNull();
  }

  Future<List<Character>> getCharactersByRole(int roleId) {
    return (select(characters)..where(
      (tbl) => tbl.roleId.equals(roleId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<List<Character>> getFavoriteCharacters() {
    return (select(characters)..where(
      (tbl) => tbl.isFavorite.equals(true) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<List<Character>> searchCharacters(String query) {
    return (select(characters)..where(
      (tbl) => tbl.name.like('%$query%') & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<List<Character>> searchCharactersByStory(String query, int storyId) {
    return (select(characters)..where(
      (tbl) =>
          tbl.name.like('%$query%') &
          tbl.storyId.equals(storyId) &
          tbl.deletedAt.isNull(),
    )).get();
  }

  Future<int> insertCharacter(CharactersCompanion data) {
    return into(characters).insert(data);
  }

  Future<bool> updateCharacter(CharactersCompanion data) {
    return update(characters).replace(data);
  }

  Future<int> deleteCharacter(int id) {
    return db.trashDao.moveToTrash(characters, id);
  }

  Future<int> restoreCharacter(int id) {
    return db.trashDao.restoreFromTrash(characters, id);
  }

  Future<List<Future<Character>>> getDeletedCharacters() {
    return db.trashDao.getTrashItems(characters);
  }

  Future<int> toggleFavorite(int id) async {
    final character = await getCharacterById(id);
    if (character == null) return 0;

    return (update(characters)..where((tbl) => tbl.id.equals(id))).write(
      CharactersCompanion(
        isFavorite: Value(!character.isFavorite),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> updateCharacterPosition(int id, double x, double y) {
    return (update(characters)..where((tbl) => tbl.id.equals(id))).write(
      CharactersCompanion(
        xPosition: Value(x),
        yPosition: Value(y),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // CHARACTER ROLES METHODS
  Future<List<CharacterRole>> getAllRoles() {
    return (select(characterRoles)
      ..where((tbl) => tbl.deletedAt.isNull())).get();
  }

  Future<CharacterRole?> getRoleById(int id) {
    return (select(characterRoles)..where(
      (tbl) => tbl.id.equals(id) & tbl.deletedAt.isNull(),
    )).getSingleOrNull();
  }

  Future<int> insertRole(CharacterRolesCompanion data) {
    return into(characterRoles).insert(data);
  }

  Future<bool> updateRole(CharacterRolesCompanion data) {
    return update(characterRoles).replace(data);
  }

  Future<int> deleteRole(int id) {
    return db.trashDao.moveToTrash(characterRoles, id);
  }
}
