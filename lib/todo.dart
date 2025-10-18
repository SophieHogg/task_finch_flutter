import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod/riverpod.dart';
import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// A read-only description of a todo-item
@immutable
class Task {
  const Task({
    required this.title,
    required this.id,
    this.description,
    this.completed = false,
    this.parentId
  });
  final String title;
  final String id;
  final String? parentId;
  final String? description;
  final bool completed;

  @override
  String toString() {
    return 'Todo(description: $description, completed: $completed)';
  }
}

/// An object that controls a list of [Task].
class TodoList extends Notifier<List<Task>> {
  @override
  List<Task> build() => [
    const Task(id: 'todo-0', title: 'Buy cookies'),
    const Task(id: 'todo-1', title: 'Star Riverpod'),
    const Task(id: 'todo-2', title: 'Have a walk'),
  ];

  void add(String description) {
    state = [...state, Task(id: _uuid.v4(), title: description)];
  }

  void toggle(String id) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Task(
            id: todo.id,
            completed: !todo.completed,
            title: todo.title,
          )
        else
          todo,
    ];
  }

  void edit({required String id, required String description}) {
    state = [
      for (final todo in state)
        if (todo.id == id)
          Task(id: todo.id, completed: todo.completed, title: description)
        else
          todo,
    ];
  }

  void remove(Task target) {
    state = state.where((todo) => todo.id != target.id).toList();
  }
}
