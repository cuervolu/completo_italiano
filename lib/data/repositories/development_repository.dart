import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:drift/drift.dart';

class DevelopmentRepository {
  final DevelopmentDao _developmentDao;
  final ConceptsDao _conceptsDao;

  DevelopmentRepository({
    required DevelopmentDao developmentDao,
    required ConceptsDao conceptsDao,
  }) : _developmentDao = developmentDao,
       _conceptsDao = conceptsDao;

  Future<List<CharacterDevelopmentData>> getCharacterDevelopment(
    int characterId,
  ) {
    return _developmentDao.getDevelopmentByCharacterId(characterId);
  }

  Future<List<CharacterDevelopmentData>> getDevelopmentByType(
    int characterId,
    String stageType,
  ) {
    return _developmentDao.getDevelopmentByStageType(characterId, stageType);
  }

  Future<int> createDevelopmentStage({
    required int characterId,
    required String stageTitle,
    required String description,
    String stageType = 'custom',
    int? stageOrder,
  }) {
    return _developmentDao.insertDevelopment(
      CharacterDevelopmentCompanion(
        characterId: Value(characterId),
        stageTitle: Value(stageTitle),
        description: Value(description),
        stageType: Value(stageType),
        stageOrder: stageOrder != null ? Value(stageOrder) : Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateDevelopmentStage({
    required int id,
    String? stageTitle,
    String? description,
    String? stageType,
    int? stageOrder,
  }) async {
    return _developmentDao.updateDevelopment(
      CharacterDevelopmentCompanion(
        id: Value(id),
        stageTitle: stageTitle != null ? Value(stageTitle) : Value.absent(),
        description: description != null ? Value(description) : Value.absent(),
        stageType: stageType != null ? Value(stageType) : Value.absent(),
        stageOrder: stageOrder != null ? Value(stageOrder) : Value.absent(),
      ),
    );
  }

  Future<int> deleteDevelopmentStage(int id) {
    return _developmentDao.deleteDevelopment(id);
  }

  Future<List<Concept>> getCharacterConcepts(int characterId) {
    return _conceptsDao.getConceptsByCharacterId(characterId);
  }

  Future<int> createConcept({
    required int characterId,
    required String title,
    required String content,
    String? sketchPath,
  }) {
    return _conceptsDao.insertConcept(
      ConceptsCompanion(
        characterId: Value(characterId),
        title: Value(title),
        content: Value(content),
        sketchPath: sketchPath != null ? Value(sketchPath) : Value.absent(),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateConcept({
    required int id,
    String? title,
    String? content,
    String? sketchPath,
  }) async {
    return _conceptsDao.updateConcept(
      ConceptsCompanion(
        id: Value(id),
        title: title != null ? Value(title) : Value.absent(),
        content: content != null ? Value(content) : Value.absent(),
        sketchPath: sketchPath != null ? Value(sketchPath) : Value.absent(),
      ),
    );
  }

  Future<int> deleteConcept(int id) {
    return _conceptsDao.deleteConcept(id);
  }
}
