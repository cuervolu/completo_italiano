import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:drift/drift.dart';

class CharacterRepository {
  final CharacterDao _characterDao;
  final ImagesDao _imagesDao;

  CharacterRepository({
    required CharacterDao characterDao,
    required ImagesDao imagesDao,
  }) : _characterDao = characterDao,
       _imagesDao = imagesDao;

  Future<List<Character>> getAllCharacters() {
    return _characterDao.getAllCharacters();
  }

  Future<Character?> getCharacterById(int id) {
    return _characterDao.getCharacterById(id);
  }

  Future<List<Character>> getCharactersByStory(int storyId) {
    return _characterDao.getCharactersByStory(storyId);
  }

  Future<List<Character>> getFavoriteCharacters() {
    return _characterDao.getFavoriteCharacters();
  }

  Future<List<Character>> searchCharacters(String query, {int? storyId}) {
    if (storyId != null) {
      return _characterDao.searchCharactersByStory(query, storyId);
    }
    return _characterDao.searchCharacters(query);
  }

  Future<int> createCharacter({
    required int storyId,
    required String name,
    required String gender,
    required String age,
    required String personality,
    int? roleId,
    String? pronouns,
    DateTime? birthDate,
    String? race,
    String? background,
    String? appearance,
    String? speechPattern,
    String? dreams,
    String? fears,
    String? description,
    String? backgroundImage,
    bool isFavorite = false,
    double x = 0.0,
    double y = 0.0,
  }) {
    return _characterDao.insertCharacter(
      CharactersCompanion(
        storyId: Value(storyId),
        name: Value(name),
        gender: Value(gender),
        age: Value(age),
        personality: Value(personality),
        roleId: roleId != null ? Value(roleId) : Value.absent(),
        pronouns: pronouns != null ? Value(pronouns) : Value.absent(),
        birthDate: birthDate != null ? Value(birthDate) : Value.absent(),
        race: race != null ? Value(race) : Value.absent(),
        background: background != null ? Value(background) : Value.absent(),
        appearance: appearance != null ? Value(appearance) : Value.absent(),
        speechPattern:
            speechPattern != null ? Value(speechPattern) : Value.absent(),
        dreams: dreams != null ? Value(dreams) : Value.absent(),
        fears: fears != null ? Value(fears) : Value.absent(),
        description: description != null ? Value(description) : Value.absent(),
        backgroundImage:
            backgroundImage != null ? Value(backgroundImage) : Value.absent(),
        isFavorite: Value(isFavorite),
        xPosition: Value(x),
        yPosition: Value(y),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateCharacter({
    required int id,
    String? name,
    int? roleId,
    String? gender,
    String? age,
    String? personality,
    String? pronouns,
    DateTime? birthDate,
    String? race,
    String? background,
    String? appearance,
    String? speechPattern,
    String? dreams,
    String? fears,
    String? description,
    String? backgroundImage,
  }) async {
    final character = await _characterDao.getCharacterById(id);
    if (character == null) return false;

    return _characterDao.updateCharacter(
      CharactersCompanion(
        id: Value(id),
        name: name != null ? Value(name) : Value.absent(),
        roleId: roleId != null ? Value(roleId) : Value.absent(),
        gender: gender != null ? Value(gender) : Value.absent(),
        age: age != null ? Value(age) : Value.absent(),
        personality: personality != null ? Value(personality) : Value.absent(),
        pronouns: pronouns != null ? Value(pronouns) : Value.absent(),
        birthDate: birthDate != null ? Value(birthDate) : Value.absent(),
        race: race != null ? Value(race) : Value.absent(),
        background: background != null ? Value(background) : Value.absent(),
        appearance: appearance != null ? Value(appearance) : Value.absent(),
        speechPattern:
            speechPattern != null ? Value(speechPattern) : Value.absent(),
        dreams: dreams != null ? Value(dreams) : Value.absent(),
        fears: fears != null ? Value(fears) : Value.absent(),
        description: description != null ? Value(description) : Value.absent(),
        backgroundImage:
            backgroundImage != null ? Value(backgroundImage) : Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteCharacter(int id) {
    return _characterDao.deleteCharacter(id);
  }

  Future<int> restoreCharacter(int id) {
    return _characterDao.restoreCharacter(id);
  }

  Future<List<Character>> getDeletedCharacters() async {
    final deletedCharactersFutures = await _characterDao.getDeletedCharacters();
    return Future.wait(deletedCharactersFutures);
  }

  Future<int> toggleFavorite(int id) {
    return _characterDao.toggleFavorite(id);
  }

  Future<int> updateCharacterPosition(int id, double x, double y) {
    return _characterDao.updateCharacterPosition(id, x, y);
  }

  Future<List<CharacterRole>> getAllRoles() {
    return _characterDao.getAllRoles();
  }

  Future<CharacterRole?> getRoleById(int id) {
    return _characterDao.getRoleById(id);
  }

  Future<int> createRole({
    required String name,
    String? description,
    String? color,
  }) {
    return _characterDao.insertRole(
      CharacterRolesCompanion(
        name: Value(name),
        description: description != null ? Value(description) : Value.absent(),
        color: color != null ? Value(color) : Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<List<CharacterImage>> getCharacterImages(int characterId) {
    return _imagesDao.getImagesByCharacterId(characterId);
  }

  Future<CharacterImage?> getCharacterMainImage(int characterId) {
    return _imagesDao.getMainImageByCharacterId(characterId);
  }

  Future<int> addCharacterImage({
    required int characterId,
    required String imagePath,
    String? caption,
    bool isMainImage = false,
  }) async {
    final imageId = await _imagesDao.insertImage(
      CharacterImagesCompanion(
        characterId: Value(characterId),
        imagePath: Value(imagePath),
        caption: caption != null ? Value(caption) : Value.absent(),
        isMainImage: Value(isMainImage),
        addedAt: Value(DateTime.now()),
      ),
    );

    if (isMainImage) {
      await _imagesDao.setMainImage(imageId, characterId);
    }

    return imageId;
  }

  Future<int> setMainImage(int imageId, int characterId) {
    return _imagesDao.setMainImage(imageId, characterId);
  }

  Future<int> deleteImage(int id) {
    return _imagesDao.deleteImage(id);
  }
}
