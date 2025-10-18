import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/legacy.dart';
import 'package:todos/components/add_task_dialog.dart';
import 'package:todos/data/database.dart';
import 'package:collection/collection.dart';

import 'components/navbar.dart';
import 'components/task_item.dart';
import 'todoProvider.dart';

/// Some keys used for testing
final addTodoKey = UniqueKey();
final activeFilterKey = UniqueKey();
final completedFilterKey = UniqueKey();
final allFilterKey = UniqueKey();

/// Creates a [TodoList] and initialize it with pre-defined values.
///
/// We are using [NotifierProvider] here as a `List<Todo>` is a complex
/// object, with advanced business logic like how to edit a todo.
final todoListProvider = AsyncNotifierProvider<TodoList, List<Task>>(
  TodoList.new,
);

/// The different ways to filter the list of todos
enum TodoListFilter { all, active, completed }

/// The currently active filter.
///
/// We use [StateProvider] here as there is no fancy logic behind manipulating
/// the value since it's just enum.
final todoListFilter = StateProvider((_) => TodoListFilter.all);

/// The number of uncompleted todos
///
/// By using [Provider], this value is cached, making it performant.\
/// Even multiple widgets try to read the number of uncompleted todos,
/// the value will be computed only once (until the todo-list changes).
///
/// This will also optimize unneeded rebuilds if the todo-list changes, but the
/// number of uncompleted todos doesn't (such as when editing a todo).
final uncompletedTodosCount = Provider<int>((ref) {
  return ref
          .watch(todoListProvider)
          .value
          ?.where((todo) => !todo.completed)
          .length ??
      0;
});

/// The list of todos after applying of [todoListFilter].
///
/// This too uses [Provider], to avoid recomputing the filtered list unless either
/// the filter of or the todo-list updates.
final filteredTodos = Provider<List<Task>>((ref) {
  final filter = ref.watch(todoListFilter);
  final todos = ref.watch(todoListProvider);
  switch (filter) {
    case TodoListFilter.completed:
      return todos.value?.where((todo) => todo.completed).toList() ?? [];
    case TodoListFilter.active:
      return todos.value?.where((todo) => !todo.completed).toList() ?? [];
    case TodoListFilter.all:
      // ensure the incomplete tasks are at the top
  final incompleteTasks = todos.value?.where((task) => !task.completed).sortedBy((task) => task.priority.index);
  final completeTasks = todos.value?.where((task) => task.completed).sortedBy((task) => task.priority.index);
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
    return const MaterialApp(home: Home());
  }
}

class Home extends HookConsumerWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(filteredTodos);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          children: [
            const SizedBox(height: 42),
            const Toolbar(),
            if (todos.isNotEmpty) const Divider(height: 0),
            for (var i = 0; i < todos.length; i++) ...[
              if (i > 0) const Divider(height: 0),
              Dismissible(
                key: ValueKey(todos[i].id),
                onDismissed: (_) async {
                  ref.read(todoListProvider.notifier).delete(todos[i].id);
                },
                child: ProviderScope(
                  overrides: [currentTodo.overrideWithValue(todos[i])],
                  child: const TodoItem(),
                ),
              ),
            ],
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Dialog.fullscreen(
                  child: AddTaskDialog(
                    onAdd: (taskAddRequest) {
                      ref.read(todoListProvider.notifier).add(taskAddRequest);
                      Navigator.pop(context);
                    },
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const Navbar(),
      ),
    );
  }
}

/// A provider which exposes the [Task] displayed by a [TodoItem].
///
/// By retrieving the [Task] through a provider instead of through its
/// constructor, this allows [TodoItem] to be instantiated using the `const` keyword.
///
/// This ensures that when we add/remove/edit todos, only what the
/// impacted widgets rebuilds, instead of the entire list of items.
final currentTodo = Provider<Task>(
  dependencies: const [],
  (ref) => throw UnimplementedError(),
);

class Toolbar extends HookConsumerWidget {
  const Toolbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(todoListFilter);

    Color? textColorFor(TodoListFilter value) {
      return filter == value ? Colors.blue : Colors.black;
    }

    return Material(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '${ref.watch(uncompletedTodosCount)} items left',
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Tooltip(
            key: allFilterKey,
            message: 'All todos',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(todoListFilter.notifier).state =
                          TodoListFilter.all,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TodoListFilter.all),
                ),
              ),
              child: const Text('All'),
            ),
          ),
          Tooltip(
            key: activeFilterKey,
            message: 'Only uncompleted todos',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(todoListFilter.notifier).state =
                          TodoListFilter.active,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TodoListFilter.active),
                ),
              ),
              child: const Text('Active'),
            ),
          ),
          Tooltip(
            key: completedFilterKey,
            message: 'Only completed todos',
            child: TextButton(
              onPressed:
                  () =>
                      ref.read(todoListFilter.notifier).state =
                          TodoListFilter.completed,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                foregroundColor: WidgetStatePropertyAll(
                  textColorFor(TodoListFilter.completed),
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

bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(() {
    void listener() {
      isFocused.value = node.hasFocus;
    }

    node.addListener(listener);
    return () => node.removeListener(listener);
  }, [node]);

  return isFocused.value;
}
