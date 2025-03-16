import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Table for storing character information
/// Characters are the main entities in the app
@TableIndex(name: 'index_characters_name', unique: true, columns: {#name})
class Characters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text()();
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();
  TextColumn get personality => text().nullable()();
  TextColumn get background => text().nullable()();
  TextColumn get appearance => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Table for storing categories to organize characters
/// Each character can belong to one category
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
}

/// Table for storing character images
/// Each character can have multiple images in their gallery
class CharacterImages extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  TextColumn get imagePath => text()();
  TextColumn get caption => text().nullable()();
  BoolColumn get isMainImage => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table for storing character concepts and sketches
/// Contains ideas and drafts related to a character
class Concepts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text()();
  TextColumn get sketchPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table for storing opinions between characters
/// Represents what one character thinks about another
class Opinions extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Character who has the opinion
  IntColumn get characterId => integer().references(Characters, #id)();

  // Character who is the subject of the opinion
  IntColumn get aboutCharacterId => integer().references(Characters, #id)();

  TextColumn get content => text()();

  // Optional relationship level (1-10)
  IntColumn get relationshipLevel => integer().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

@DriftDatabase(
  tables: [Characters, Categories, CharacterImages, Concepts, Opinions],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Character>> getAllCharacters() => select(characters).get();

  Future<Character?> getCharacterById(int id) {
    return (select(characters)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Character>> getCharactersByCategory(int categoryId) {
    return (select(characters)
      ..where((tbl) => tbl.categoryId.equals(categoryId))).get();
  }

  Future<List<Character>> getFavoriteCharacters() {
    return (select(characters)
      ..where((tbl) => tbl.isFavorite.equals(true))).get();
  }

  Future<List<Character>> searchCharacters(String query) {
    return (select(characters)
      ..where((tbl) => tbl.name.like('%$query%'))).get();
  }

  Future<int> insertCharacter(CharactersCompanion data) {
    return into(characters).insert(data);
  }

  Future<bool> updateCharacter(CharactersCompanion data) {
    return update(characters).replace(data);
  }

  Future<int> deleteCharacter(int id) {
    return (delete(characters)..where((tbl) => tbl.id.equals(id))).go();
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

  Future<List<Category>> getAllCategories() => select(categories).get();

  Future<Category?> getCategoryById(int id) {
    return (select(categories)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCategory(CategoriesCompanion data) {
    return into(categories).insert(data);
  }

  Future<bool> updateCategory(CategoriesCompanion data) {
    return update(categories).replace(data);
  }

  Future<int> deleteCategory(int id) {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<CharacterImage>> getImagesByCharacterId(int characterId) {
    return (select(characterImages)
      ..where((tbl) => tbl.characterId.equals(characterId))).get();
  }

  Future<CharacterImage?> getMainImageByCharacterId(int characterId) {
    return (select(characterImages)..where(
      (tbl) =>
          tbl.characterId.equals(characterId) & tbl.isMainImage.equals(true),
    )).getSingleOrNull();
  }

  Future<int> insertImage(CharacterImagesCompanion data) {
    return into(characterImages).insert(data);
  }

  Future<bool> updateImage(CharacterImagesCompanion data) {
    return update(characterImages).replace(data);
  }

  Future<int> deleteImage(int id) {
    return (delete(characterImages)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> setMainImage(int imageId, int characterId) async {
    // First reset all images for this character
    await (update(characterImages)..where(
      (tbl) => tbl.characterId.equals(characterId),
    )).write(const CharacterImagesCompanion(isMainImage: Value(false)));

    // Then set the new main image
    return (update(characterImages)..where(
      (tbl) => tbl.id.equals(imageId),
    )).write(const CharacterImagesCompanion(isMainImage: Value(true)));
  }

  Future<List<Concept>> getConceptsByCharacterId(int characterId) {
    return (select(concepts)
      ..where((tbl) => tbl.characterId.equals(characterId))).get();
  }

  Future<int> insertConcept(ConceptsCompanion data) {
    return into(concepts).insert(data);
  }

  Future<bool> updateConcept(ConceptsCompanion data) {
    return update(concepts).replace(data);
  }

  Future<int> deleteConcept(int id) {
    return (delete(concepts)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Opinion methods
  Future<List<Opinion>> getOpinionsByCharacterId(int characterId) {
    return (select(opinions)
      ..where((tbl) => tbl.characterId.equals(characterId))).get();
  }

  Future<List<Opinion>> getOpinionsAboutCharacter(int aboutCharacterId) {
    return (select(opinions)
      ..where((tbl) => tbl.aboutCharacterId.equals(aboutCharacterId))).get();
  }

  Future<Opinion?> getSpecificOpinion(int characterId, int aboutCharacterId) {
    return (select(opinions)..where(
      (tbl) =>
          tbl.characterId.equals(characterId) &
          tbl.aboutCharacterId.equals(aboutCharacterId),
    )).getSingleOrNull();
  }

  Future<int> insertOpinion(OpinionsCompanion data) {
    return into(opinions).insert(data);
  }

  Future<bool> updateOpinion(OpinionsCompanion data) {
    return update(opinions).replace(data);
  }

  Future<int> deleteOpinion(int id) {
    return (delete(opinions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<int> deleteOpinionBetweenCharacters(
    int characterId,
    int aboutCharacterId,
  ) {
    return (delete(opinions)..where(
      (tbl) =>
          tbl.characterId.equals(characterId) &
          tbl.aboutCharacterId.equals(aboutCharacterId),
    )).go();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'completo_italiano',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
