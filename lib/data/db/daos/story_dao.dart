import 'package:completo_italiano/data/db/tables.dart';
import 'package:drift/drift.dart';
import '../database.dart';

part 'story_dao.g.dart';

@DriftAccessor(tables: [Stories])
class StoryDao extends DatabaseAccessor<AppDatabase> with _$StoryDaoMixin {
  StoryDao(super.db);

  Future<List<Story>> getAllStories() {
    return (select(stories)..where((tbl) => tbl.deletedAt.isNull())).get();
  }

  Future<Story?> getStoryById(int id) {
    return (select(stories)..where(
      (tbl) => tbl.id.equals(id) & tbl.deletedAt.isNull(),
    )).getSingleOrNull();
  }

  Future<int> insertStory(StoriesCompanion data) {
    return into(stories).insert(data);
  }

  Future<bool> updateStory(StoriesCompanion data) {
    return update(stories).replace(data);
  }

  Future<int> deleteStory(int id) {
    return db.trashDao.moveToTrash(stories, id);
  }

  Future<List<Future<Story>>> getDeletedStories() {
    return db.trashDao.getTrashItems(stories);
  }

  Future<int> restoreStory(int id) {
    return db.trashDao.restoreFromTrash(stories, id);
  }

  Future<int> permanentlyDeleteStory(int id) {
    return db.trashDao.permanentlyDelete(stories, id);
  }
}
