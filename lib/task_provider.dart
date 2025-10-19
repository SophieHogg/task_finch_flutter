import 'package:drift/drift.dart';
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

import 'data/database.dart';
import 'main.dart';

const _uuid = Uuid();

class TaskAddRequest {
  final String title;
  final String? description;
  final Priority priority;
  final String? parentId;

  const TaskAddRequest({
    required this.title,
    required this.description,
    required this.priority,
    required this.parentId,
  });
}

/// An object that controls a list of [Task].
class TaskList extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    return await database.select(database.tasks).get();
  }

  void add(TaskAddRequest taskAddRequest) async {
    final TasksCompanion newTask = TasksCompanion(
      title: Value(taskAddRequest.title),
      description: Value(taskAddRequest.description),
      createdOn: Value(DateTime.now()),
      parentId: Value(taskAddRequest.parentId),
      completed: Value(false),
      priority: Value(taskAddRequest.priority),
      id: Value(_uuid.v4()),
    );
    await (database.into(database.tasks).insert(newTask));
    ref.invalidateSelf();
  }

  void markComplete(String id) async {
    await (database.update(database.tasks)
      ..where((task) => task.id.isValue(id))).write(
      TasksCompanion(
        completed: Value(true),
        completedOn: Value(DateTime.now()),
      ),
    );
    ref.invalidateSelf();
  }

  void markIncomplete(String id) async {
    await (database.update(database.tasks)..where(
      (task) => task.id.isValue(id),
    )).write(TasksCompanion(completed: Value(false), completedOn: Value(null)));
    ref.invalidateSelf();
  }

  void edit({required String id, required String description}) {
    // state = [
    //   for (final todo in state)
    //     if (todo.id == id)
    //       Task(id: todo.id, completed: todo.completed, title: description)
    //     else
    //       todo,
    // ];
  }


  void delete(String id) async {
    await (database.delete(database.tasks)
      ..where((task) => task.id.isValue(id))).go();
    ref.invalidateSelf();

  }
}
