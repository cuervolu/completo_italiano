import 'package:drift/drift.dart';

/// Table for storing story information
/// Stories are the top-level organizational units
@TableIndex(name: 'index_stories_title', unique: true, columns: {#title})
class Stories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().nullable()();
  TextColumn get genre => text().nullable()(); // Fantasy, Sci-Fi, etc.
  TextColumn get setting => text().nullable()(); // World/universe details
  TextColumn get backgroundImage =>
      text().nullable()(); // Path to custom background
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for character roles
/// Defines the role a character plays in the story
@TableIndex(name: 'index_character_roles_name', unique: true, columns: {#name})
class CharacterRoles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name =>
      text().withLength(min: 1, max: 50)(); // Protagonist, Antagonist, etc.
  TextColumn get description => text().nullable()();
  TextColumn get color => text().nullable()(); // For visual distinction
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for storing character information
/// Characters are the main entities in the app
@TableIndex(name: 'index_characters_name', unique: true, columns: {#name})
@TableIndex(name: 'index_characters_story', columns: {#storyId})
@TableIndex(name: 'index_characters_role', columns: {#roleId})
@TableIndex(name: 'index_characters_favorite', columns: {#isFavorite})
class Characters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get storyId =>
      integer().references(Stories, #id)(); // Link to story
  IntColumn get roleId =>
      integer().nullable().references(CharacterRoles, #id)(); // Character role

  // Basic info
  TextColumn get description => text().nullable()();
  TextColumn get gender => text()(); // Required field
  TextColumn get pronouns => text().nullable()(); // Character's pronouns
  TextColumn get age => text()(); // Required field
  DateTimeColumn get birthDate => dateTime().nullable()();
  TextColumn get race => text().nullable()(); // Human, Elf, etc. for fantasy

  // Detailed character aspects
  TextColumn get personality => text()(); // Required field
  TextColumn get background => text().nullable()();
  TextColumn get appearance => text().nullable()();
  TextColumn get speechPattern =>
      text().nullable()(); // How the character talks
  TextColumn get dreams => text().nullable()(); // Aspirations, goals
  TextColumn get fears => text().nullable()(); // What scares them

  // Position on the board
  RealColumn get xPosition => real().withDefault(const Constant(0.0))();
  RealColumn get yPosition => real().withDefault(const Constant(0.0))();

  // Custom background image
  TextColumn get backgroundImage => text().nullable()();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for storing family relationships between characters
@TableIndex(name: 'index_relationship_character', columns: {#characterId})
@TableIndex(name: 'index_relationship_related', columns: {#relatedCharacterId})
@TableIndex(
  name: 'index_relationship_both',
  columns: {#characterId, #relatedCharacterId},
)
class CharacterRelationships extends Table {
  IntColumn get id => integer().autoIncrement()();

  @ReferenceName('characterRelationshipsFromRef')
  IntColumn get characterId => integer().references(Characters, #id)();

  @ReferenceName('characterRelationshipsToRef')
  IntColumn get relatedCharacterId => integer().references(Characters, #id)();

  TextColumn get relationshipType =>
      text()(); // Parent, Child, Sibling, Friend, Enemy, etc.
  TextColumn get description => text().nullable()(); // Additional details
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for storing character development/arc over time
@TableIndex(name: 'index_development_character', columns: {#characterId})
@TableIndex(
  name: 'index_development_order',
  columns: {#characterId, #stageOrder},
)
class CharacterDevelopment extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  TextColumn get stageTitle => text().withLength(min: 1, max: 100)();
  TextColumn get description => text()();
  TextColumn get stageType =>
      text().withDefault(const Constant('custom'))(); // Beginning, Middle, End
  IntColumn get stageOrder =>
      integer().withDefault(const Constant(0))(); // For ordering
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
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
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for storing character concepts and sketches
/// Contains ideas and drafts related to a character
@TableIndex(name: 'index_concepts_character', columns: {#characterId})
class Concepts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get characterId => integer().references(Characters, #id)();
  TextColumn get title => text().withLength(min: 1, max: 100)();
  TextColumn get content => text()(); // Brainstorming ideas
  TextColumn get sketchPath => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for storing opinions between characters
/// Represents what one character thinks about another
@TableIndex(name: 'index_opinions_character', columns: {#characterId})
@TableIndex(name: 'index_opinions_about', columns: {#aboutCharacterId})
@TableIndex(
  name: 'index_opinions_relationship',
  columns: {#characterId, #aboutCharacterId},
)
class Opinions extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Character who has the opinion
  @ReferenceName('opinionsFromRef')
  IntColumn get characterId => integer().references(Characters, #id)();

  // Character who is the subject of the opinion
  @ReferenceName('opinionsAboutRef')
  IntColumn get aboutCharacterId => integer().references(Characters, #id)();

  TextColumn get content => text()();

  // Relationship level (1-10)
  IntColumn get relationshipLevel => integer().nullable()();

  // Color to visualize sentiment
  TextColumn get color => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().nullable()();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for story boards (pinboard-style images/stickers)
/// Allows users to place images anywhere like a bulletin board
@TableIndex(name: 'index_storyboards_story', columns: {#storyId})
class StoryBoards extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get storyId => integer().references(Stories, #id)();
  TextColumn get imagePath => text()();
  RealColumn get xPosition => real().withDefault(const Constant(0.0))();
  RealColumn get yPosition => real().withDefault(const Constant(0.0))();
  RealColumn get width => real().withDefault(const Constant(100.0))();
  RealColumn get height => real().withDefault(const Constant(100.0))();
  RealColumn get rotation => real().withDefault(const Constant(0.0))();
  IntColumn get zIndex =>
      integer().withDefault(const Constant(0))(); // For layering
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get deletedAt => dateTime().nullable()();
}

/// Table for application settings
/// Stores global application configuration
class AppSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get defaultBackgroundImage => text().nullable()();
  TextColumn get themeColor => text().nullable()();
  TextColumn get fontStyle => text().nullable()();
  IntColumn get lastOpenedStoryId => integer().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}