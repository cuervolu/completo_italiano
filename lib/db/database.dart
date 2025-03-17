import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

/// Table for storing story information
/// Stories are the top-level organizational units
@TableIndex(name: 'index_stories_title', unique: true, columns: {#title})
class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get genre => text().nullable()(); // Fantasy, Sci-Fi, etc.
  TextColumn get setting => text().nullable()(); // World/universe details
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Table for storing character information
/// Characters are the main entities in the app
@TableIndex(name: 'index_characters_name', unique: true, columns: {#name})
@TableIndex(name: 'index_characters_story', columns: {#storyId})
@TableIndex(name: 'index_characters_category', columns: {#categoryId})
@TableIndex(name: 'index_characters_favorite', columns: {#isFavorite})
class Characters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get storyId =>
      integer().references(Stories, #id)(); // Link to story
  IntColumn get categoryId =>
      integer().nullable().references(Categories, #id)();

  // Basic info
  TextColumn get description => text()();
  TextColumn get role =>
      text().nullable()(); // Protagonist, Antagonist, Supporting, etc.
  TextColumn get age => text().nullable()();
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get race => text().nullable()(); // Human, Elf, etc. for fantasy

  // Detailed character aspects
  TextColumn get personality => text().nullable()();
  TextColumn get background => text().nullable()();
  TextColumn get appearance => text().nullable()();
  TextColumn get speechPattern =>
      text().nullable()(); // How the character talks
  TextColumn get dreams => text().nullable()(); // Aspirations, goals
  TextColumn get fears => text().nullable()(); // What scares them

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Table for storing family relationships between characters
@TableIndex(name: 'index_relationship_character', columns: {#characterId})
@TableIndex(name: 'index_relationship_related', columns: {#relatedCharacterId})
@TableIndex(name: 'index_relationship_both', columns: {#characterId, #relatedCharacterId})
class CharacterRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  IntColumn get relatedCharacterId => integer().references(Characters, #id)();
  TextColumn get relationshipType => text()(); // Parent, Child, Sibling, etc.
  TextColumn get description => text().nullable()(); // Additional details
}

/// Table for storing character development/arc over time
@TableIndex(name: 'index_development_character', columns: {#characterId})
@TableIndex(name: 'index_development_order', columns: {#characterId, #stageOrder})
class CharacterDevelopment extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  TextColumn get stageTitle => text().withLength(min: 1, max: 100)();
  TextColumn get description => text()();
  IntColumn get stageOrder =>
      integer().withDefault(const Constant(0))(); // For ordering
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// Table for storing categories to organize characters
/// Each character can belong to one category
@TableIndex(name: 'index_categories_name', unique: true, columns: {#name})
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50)();
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()();
}

/// Table for storing character images
/// Each character can have multiple images in their gallery
@TableIndex(name: 'index_images_character', columns: {#characterId})
@TableIndex(name: 'index_images_main', columns: {#characterId, #isMainImage})
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
@TableIndex(name: 'index_concepts_character', columns: {#characterId})
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
@TableIndex(name: 'index_opinions_character', columns: {#characterId})
@TableIndex(name: 'index_opinions_about', columns: {#aboutCharacterId})
@TableIndex(name: 'index_opinions_relationship', columns: {#characterId, #aboutCharacterId})
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
  tables: [
    Stories,
    Characters,
    Categories,
    CharacterImages,
    Concepts,
    Opinions,
    CharacterRelationships,
    CharacterDevelopment,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // Story methods
  Future<List<Story>> getAllStories() => select(stories).get();

  Future<Story?> getStoryById(int id) {
    return (select(stories)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertStory(StoriesCompanion data) {
    return into(stories).insert(data);
  }

  Future<bool> updateStory(StoriesCompanion data) {
    return update(stories).replace(data);
  }

  Future<int> deleteStory(int id) {
    return (delete(stories)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Character relationship methods
  Future<List<CharacterRelationship>> getRelationshipsByCharacterId(
    int characterId,
  ) {
    return (select(characterRelationships)
      ..where((tbl) => tbl.characterId.equals(characterId))).get();
  }

  Future<List<CharacterRelationship>> getRelationshipsWithCharacterId(
    int characterId,
  ) {
    return (select(characterRelationships)
      ..where((tbl) => tbl.relatedCharacterId.equals(characterId))).get();
  }

  Future<int> insertRelationship(CharacterRelationshipsCompanion data) {
    return into(characterRelationships).insert(data);
  }

  Future<bool> updateRelationship(CharacterRelationshipsCompanion data) {
    return update(characterRelationships).replace(data);
  }

  Future<int> deleteRelationship(int id) {
    return (delete(characterRelationships)
      ..where((tbl) => tbl.id.equals(id))).go();
  }

  // Character development methods
  Future<List<CharacterDevelopmentData>> getDevelopmentByCharacterId(
    int characterId,
  ) {
    return (select(characterDevelopment)
          ..where((tbl) => tbl.characterId.equals(characterId))
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
    return (delete(characterDevelopment)
      ..where((tbl) => tbl.id.equals(id))).go();
  }

  // Existing methods, updated for the new schema
  Future<List<Character>> getAllCharacters() => select(characters).get();

  Future<List<Character>> getCharactersByStory(int storyId) {
    return (select(characters)
      ..where((tbl) => tbl.storyId.equals(storyId))).get();
  }

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

  Future<List<Character>> searchCharactersByStory(String query, int storyId) {
    return (select(characters)..where(
      (tbl) => tbl.name.like('%$query%') & tbl.storyId.equals(storyId),
    )).get();
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