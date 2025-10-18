import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

import 'data/database.dart';
import 'main.dart';

const _uuid = Uuid();

/// An object that controls a list of [Task].
class TodoList extends AsyncNotifier<List<Task>> {
  @override
  Future<List<Task>> build() async {
    return await database.select(database.tasks).get();
  }


  void add(String description) {
    // state = [...state, Task(id: _uuid.v4(), title: description)];
  }

  void toggle(String id) {}

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
    await (database.update(database.tasks)
      ..where((task) => task.id.isValue(id))).write(
      TasksCompanion(
        completed: Value(false),
        completedOn: Value(null),
      ),
    );
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
  }
}
