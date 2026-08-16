import 'package:drift/drift.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'data/database.dart';
import 'main.dart';

final taskByFilter = FutureProvider.family<
  List<Task>,
  (String, Set<Priority>, Set<CompletionStatus>)
>((ref, filters) async {
  ref.watch(taskListProvider);
  final (searchTerm, priorities, statuses) = filters;
  return await (database.select(database.tasks)..where(
    (task) =>
        task.title.contains(searchTerm) &
        task.priority.isIn(priorities.map((priority) => priority.name)) &
        task.completed.isIn(statuses.map((status) => switch(status) {
          CompletionStatus.complete => true,
          CompletionStatus.incomplete => false,
        })),
  )).get();
});
