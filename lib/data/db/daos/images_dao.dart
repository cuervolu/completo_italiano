import 'package:completo_italiano/data/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'images_dao.g.dart';

@DriftAccessor(tables: [CharacterImages])
class ImagesDao extends DatabaseAccessor<AppDatabase> with _$ImagesDaoMixin {
  ImagesDao(super.db);

  Future<List<CharacterImage>> getImagesByCharacterId(int characterId) {
    return (select(characterImages)..where(
      (tbl) => tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).get();
  }

  Future<CharacterImage?> getMainImageByCharacterId(int characterId) {
    return (select(characterImages)..where(
      (tbl) =>
          tbl.characterId.equals(characterId) &
          tbl.isMainImage.equals(true) &
          tbl.deletedAt.isNull(),
    )).getSingleOrNull();
  }

  Future<int> insertImage(CharacterImagesCompanion data) {
    return into(characterImages).insert(data);
  }

  Future<bool> updateImage(CharacterImagesCompanion data) {
    return update(characterImages).replace(data);
  }

  Future<int> deleteImage(int id) {
    return db.trashDao.moveToTrash(characterImages, id);
  }

  Future<int> setMainImage(int imageId, int characterId) async {
    // First reset all images for this character
    await (update(characterImages)..where(
      (tbl) => tbl.characterId.equals(characterId) & tbl.deletedAt.isNull(),
    )).write(const CharacterImagesCompanion(isMainImage: Value(false)));

    // Then set the new main image
    return (update(characterImages)..where(
      (tbl) => tbl.id.equals(imageId),
    )).write(const CharacterImagesCompanion(isMainImage: Value(true)));
  }
}