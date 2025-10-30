import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/components/circle_icon.dart';
import 'package:task_finch/components/home_task_item.dart';
import 'package:task_finch/data/database.dart';
import 'package:task_finch/dialogs/add_task_dialog.dart';
import 'package:task_finch/theming/constants.dart';

import 'components/task_counter.dart';
import 'task_provider.dart';
import 'theming/theme.dart';

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
    final tasks = (ref.watch(taskListProvider).value?.where((task) => task.completed == false)) ?? [];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleIcon(),
        ),

        title: Text('Task Finch'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            spacing: 8,
            children: [
              Column(
                spacing: 8,
                children: [
                  for (final task in tasks) ...[
                    // if (i > 0) const Divider(height: 0),
                    ProviderScope(
                      overrides: [currentTask.overrideWithValue(task)],
                      child: const HomeTaskItem(),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: positiveColour,
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
        child: const Icon(color: Colors.white, Icons.add),
      ),
      bottomNavigationBar: BaseNav(selectedIndex: 0),
    );
  }
}

final currentTask = Provider<Task>(
  dependencies: const [],
  (ref) => throw UnimplementedError(),
);

