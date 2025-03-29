import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'storyboard_dao.g.dart';

@DriftAccessor(tables: [StoryBoards])
class StoryboardDao extends DatabaseAccessor<AppDatabase> with _$StoryboardDaoMixin {
  StoryboardDao(super.db);

  Future<List<StoryBoard>> getStoryBoardsByStoryId(int storyId) {
    return (select(storyBoards)
          ..where((tbl) => tbl.storyId.equals(storyId) & tbl.deletedAt.isNull())
          ..orderBy([(t) => OrderingTerm(expression: t.zIndex)]))
        .get();
  }

  Future<int> insertStoryBoard(StoryBoardsCompanion data) {
    return into(storyBoards).insert(data);
  }

  Future<bool> updateStoryBoard(StoryBoardsCompanion data) {
    return update(storyBoards).replace(data);
  }

  // Corregido: Ya no usa writeColumns
  Future<int> updateStoryBoardPosition(
    int id,
    double x,
    double y, [
    double? rotation,
  ]) {
    // Creamos un companion con los valores básicos
    final companion = StoryBoardsCompanion(
      xPosition: Value(x),
      yPosition: Value(y),
    );
    
    // Si hay rotación, la añadimos al companion
    final finalCompanion = rotation != null 
      ? companion.copyWith(rotation: Value(rotation)) 
      : companion;
    
    return (update(storyBoards)..where((tbl) => tbl.id.equals(id))).write(finalCompanion);
  }

  Future<int> deleteStoryBoard(int id) {
    return db.trashDao.moveToTrash(storyBoards, id);
  }
}