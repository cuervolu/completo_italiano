import 'package:completo_italiano/data/db/database.dart';
import 'package:completo_italiano/data/db/daos/daos.dart';
import 'package:drift/drift.dart';

class StoryRepository {
  final StoryDao _storyDao;
  final StoryboardDao _storyboardDao;

  StoryRepository({
    required StoryDao storyDao,
    required StoryboardDao storyboardDao,
  }) : _storyDao = storyDao,
       _storyboardDao = storyboardDao;

  Future<List<Story>> getAllStories() {
    return _storyDao.getAllStories();
  }

  Future<Story?> getStoryById(int id) {
    return _storyDao.getStoryById(id);
  }

  Future<int> createStory({
    required String title,
    String? description,
    String? genre,
    String? setting,
    String? backgroundImage,
  }) {
    return _storyDao.insertStory(
      StoriesCompanion(
        title: Value(title),
        description: Value(description),
        genre: Value(genre),
        setting: Value(setting),
        backgroundImage: Value(backgroundImage),
        createdAt: Value(DateTime.now()),
      ),
    );
  }

  Future<bool> updateStory({
    required int id,
    String? title,
    String? description,
    String? genre,
    String? setting,
    String? backgroundImage,
  }) async {
    final story = await _storyDao.getStoryById(id);
    if (story == null) return false;

    return _storyDao.updateStory(
      StoriesCompanion(
        id: Value(id),
        title: title != null ? Value(title) : Value.absent(),
        description: description != null ? Value(description) : Value.absent(),
        genre: genre != null ? Value(genre) : Value.absent(),
        setting: setting != null ? Value(setting) : Value.absent(),
        backgroundImage:
            backgroundImage != null ? Value(backgroundImage) : Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<int> deleteStory(int id) {
    return _storyDao.deleteStory(id);
  }

  Future<int> restoreStory(int id) {
    return _storyDao.restoreStory(id);
  }

  Future<int> permanentlyDeleteStory(int id) {
    return _storyDao.permanentlyDeleteStory(id);
  }

  Future<List<Story>> getDeletedStories() async {
    final deletedStoriesFutures = await _storyDao.getDeletedStories();
    return Future.wait(deletedStoriesFutures);
  }

  Future<List<StoryBoard>> getStoryBoardItems(int storyId) {
    return _storyboardDao.getStoryBoardsByStoryId(storyId);
  }

  Future<int> addStoryBoardItem({
    required int storyId,
    required String imagePath,
    double x = 0.0,
    double y = 0.0,
    double width = 100.0,
    double height = 100.0,
    double rotation = 0.0,
    int zIndex = 0,
  }) {
    return _storyboardDao.insertStoryBoard(
      StoryBoardsCompanion(
        storyId: Value(storyId),
        imagePath: Value(imagePath),
        xPosition: Value(x),
        yPosition: Value(y),
        width: Value(width),
        height: Value(height),
        rotation: Value(rotation),
        zIndex: Value(zIndex),
      ),
    );
  }

  Future<int> updateStoryBoardItemPosition({
    required int id,
    required double x,
    required double y,
    double? rotation,
  }) {
    return _storyboardDao.updateStoryBoardPosition(id, x, y, rotation);
  }

  Future<int> deleteStoryBoardItem(int id) {
    return _storyboardDao.deleteStoryBoard(id);
  }
}
