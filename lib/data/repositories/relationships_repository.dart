import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:drift/drift.dart';

class RelationshipsRepository {
  final RelationshipDao _relationshipDao;
  final OpinionsDao _opinionsDao;

  RelationshipsRepository({
    required RelationshipDao relationshipDao,
    required OpinionsDao opinionsDao,
  })  : _relationshipDao = relationshipDao,
        _opinionsDao = opinionsDao;


  Future<List<CharacterRelationship>> getRelationshipsFromCharacter(int characterId) {
    return _relationshipDao.getRelationshipsByCharacterId(characterId);
  }

  Future<List<CharacterRelationship>> getRelationshipsToCharacter(int characterId) {
    return _relationshipDao.getRelationshipsWithCharacterId(characterId);
  }

  Future<int> createRelationship({
    required int characterId,
    required int relatedCharacterId,
    required String relationshipType,
    String? description,
  }) {
    return _relationshipDao.insertRelationship(
      CharacterRelationshipsCompanion(
        characterId: Value(characterId),
        relatedCharacterId: Value(relatedCharacterId),
        relationshipType: Value(relationshipType),
        description: description != null ? Value(description) : Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateRelationship({
    required int id,
    String? relationshipType,
    String? description,
  }) async {
    return _relationshipDao.updateRelationship(
      CharacterRelationshipsCompanion(
        id: Value(id),
        relationshipType: relationshipType != null ? Value(relationshipType) : Value.absent(),
        description: description != null ? Value(description) : Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteRelationship(int id) {
    return _relationshipDao.deleteRelationship(id);
  }

  Future<List<Opinion>> getOpinionsFromCharacter(int characterId) {
    return _opinionsDao.getOpinionsByCharacterId(characterId);
  }

  Future<List<Opinion>> getOpinionsAboutCharacter(int aboutCharacterId) {
    return _opinionsDao.getOpinionsAboutCharacter(aboutCharacterId);
  }

  Future<Opinion?> getSpecificOpinion(int characterId, int aboutCharacterId) {
    return _opinionsDao.getSpecificOpinion(characterId, aboutCharacterId);
  }

  Future<int> createOpinion({
    required int characterId,
    required int aboutCharacterId,
    required String content,
    int? relationshipLevel,
    String? color,
  }) {
    return _opinionsDao.insertOpinion(
      OpinionsCompanion(
        characterId: Value(characterId),
        aboutCharacterId: Value(aboutCharacterId),
        content: Value(content),
        relationshipLevel: relationshipLevel != null ? Value(relationshipLevel) : Value.absent(),
        color: color != null ? Value(color) : Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateOpinion({
    required int id,
    String? content,
    int? relationshipLevel,
    String? color,
  }) async {
    return _opinionsDao.updateOpinion(
      OpinionsCompanion(
        id: Value(id),
        content: content != null ? Value(content) : Value.absent(),
        relationshipLevel: relationshipLevel != null ? Value(relationshipLevel) : Value.absent(),
        color: color != null ? Value(color) : Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteOpinion(int id) {
    return _opinionsDao.deleteOpinion(id);
  }
}