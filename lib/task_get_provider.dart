import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/database.dart';
import 'main.dart';

final taskById = FutureProvider.family<Task?, String>((ref, id) async {
  ref.watch(taskListProvider);
  return await (database.select(database.tasks)
    ..where((task) => task.id.isValue(id))).getSingleOrNull();
});

final tasksExceptForId = FutureProvider.family<List<Task>, String?>((
  ref,
  id,
) async {
  ref.watch(taskListProvider);
  if (id != null) {
    return await (database.select(database.tasks)
      ..where((task) => task.id.isNotValue(id))).get();
  } else {
    return await (database.select(database.tasks)).get();
  }
});

final subtasksForTaskId = FutureProvider.family<List<Task>, String>((
  ref,
  id,
) async {
  ref.watch(taskListProvider);
  return await (database.select(database.tasks)
        ..where((task) => task.parentId.isValue(id))
        ..orderBy([(t) => OrderingTerm(expression: t.completed)]))
      .get();
});

final completedTasks = FutureProvider<List<Task>>((ref) async {
  ref.watch(taskListProvider);
  return await (database.select(database.tasks)
        ..where((task) => task.completed.isValue(true) & task.parentId.isNull())
        ..orderBy([(t) => OrderingTerm(expression: t.completedOn)]))
      .get();
});
