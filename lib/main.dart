import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/data/database.dart';
import 'package:task_finch/dialogs/add_task_dialog.dart';

import 'components/navbar.dart';
import 'components/task_item.dart';
import 'theming/theme.dart';
import 'task_provider.dart';

final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

/// Creates a [TaskList] and initialize it with pre-defined values.
///
/// We are using [NotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final taskListProvider = AsyncNotifierProvider<TaskList, List<Task>>(
  TaskList.new,
);

/// The different ways to filter the list of todos
enum TaskListFilter { all, active, completed }

final taskListFilter = StateProvider((_) => TaskListFilter.all);

final uncompletedTasksCount = Provider<int>((ref) {
  return ref
          .watch(taskListProvider)
          .value
          ?.where((todo) => !todo.completed)
          .length ??
      0;
});

final filteredTasks = Provider<List<Task>>((ref) {
  final filter = ref.watch(taskListFilter);
  final tasks = ref.watch(taskListProvider);
  switch (filter) {
    case TaskListFilter.completed:
      return tasks.value?.where((todo) => todo.completed).toList() ?? [];
    case TaskListFilter.active:
      return tasks.value?.where((todo) => !todo.completed).toList() ?? [];
    case TaskListFilter.all:
      // ensure the incomplete tasks are at the top
      final incompleteTasks = tasks.value
          ?.where((task) => !task.completed)
          .sortedBy((task) => task.priority.index);
      final completeTasks = tasks.value
          ?.where((task) => task.completed)
          .sortedBy((task) => task.priority.index);
      return [...?incompleteTasks, ...?completeTasks];
  }
});
late AppDatabase database;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  database = AppDatabase();

  List<Task> allItems = await database.select(database.tasks).get();

  print('items in database: $allItems');

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TFTheme(
      child: Builder(
        builder: (context) {
          return MaterialApp(theme: Theme.of(context), home: Home());
        },
      ),
    );
  }
}

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(filteredTasks);

    return Scaffold(
      appBar: AppBar(title: Text('List Finch')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        
          child: Column(
            spacing: 8,
            children: [
              const Toolbar(),
              if (tasks.isNotEmpty) const Divider(height: 0),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 5,
                child: Column(children: [
        
                for (var i = 0; i < tasks.length; i++) ...[
                  if (i > 0) const Divider(height: 0),
                  ProviderScope(
                    overrides: [currentTask.overrideWithValue(tasks[i])],
                    child: const TaskItem(),
                  ),
                ],
                ],),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Dialog.fullscreen(
                child: AddTaskDialog(
                  onAdd: (taskAddRequest) {
                    ref.read(taskListProvider.notifier).addTask(taskAddRequest);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BaseNav(selectedIndex: 0,),
    );
  }
}

final currentTask = Provider<Task>(
  dependencies: const [],
  (ref) => throw UnimplementedError(),
);

class Toolbar extends HookConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskListFilter);

    Color? textColorFor(TaskListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedTasksCount)} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: 'All tasks',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(taskListFilter.notifier).state =
                          TaskListFilter.all,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TaskListFilter.all),
                ),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted tasks',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(taskListFilter.notifier).state =
                          TaskListFilter.active,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TaskListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed tasks',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(taskListFilter.notifier).state =
                          TaskListFilter.completed,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TaskListFilter.completed),
                ),
              ),
              child: const Text('Completed'),
            ),
          ),
        ],
      ),
    );
  }
}
