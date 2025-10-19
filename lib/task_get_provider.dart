import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/database.dart';
import 'main.dart';

final taskById = FutureProvider.family<Task?, String>((ref, id) async {
  return await (database.select(database.tasks)..where((task) => task.id.isValue(id))).getSingleOrNull();
});

final subtasksForTaskId = FutureProvider.family<List<Task>, String>((ref, id) async {
  return await (database.select(database.tasks)..where((task) => task.parentId.isValue(id))).get();
});