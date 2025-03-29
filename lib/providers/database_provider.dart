import 'package:completo_italiano/db/database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'database_provider.g.dart';

@riverpod
AppDatabase database(Ref ref) {
  return AppDatabase();
}
