import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/database.dart';
import '../main.dart';

final taskListProvider = Provider<List<Task>>((ref) {
  final todos = ref.watch(todoListProvider);
  // ensure the incomplete tasks are at the top
  final incompleteTasks = todos.value
      ?.where((task) => !task.completed)
      .sortedBy((task) => task.priority.index);
  final completeTasks = todos.value
      ?.where((task) => task.completed)
      .toList()
      .sortedBy((task) => task.priority.index);
  return [...?incompleteTasks, ...?completeTasks];
});

typedef TaskEntry = DropdownMenuEntry<Task>;

class ParentSelector extends HookConsumerWidget {
  ParentSelector({super.key, required this.onChangeParent, this.initialParent});

  final void Function (Task? parent) onChangeParent;
  final Task? initialParent;
  final Map<Priority, Color> priorityColours = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };
  final TextEditingController taskController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTask = useState<Task?>(initialParent);
    final taskList = ref.watch(taskListProvider);

    return DropdownMenu<Task>(
      initialSelection: selectedTask.value,
      controller: taskController,
      // The default requestFocusOnTap value depends on the platform.
      // On mobile, it defaults to false, and on desktop, it defaults to true.
      // Setting this to true will trigger a focus request on the text field, and
      // the virtual keyboard will appear afterward.
      requestFocusOnTap: true,
      label: const Text('Parent Task'),
      onSelected: (Task? task) {
        selectedTask.value = task;
        onChangeParent(task);
      },
      expandedInsets: EdgeInsets.zero,
      enableFilter: true,
      inputDecorationTheme: InputDecorationTheme.of(context),
      dropdownMenuEntries: [
        for (final task in taskList)
          TaskEntry(
            value: task,
            label: task.title,
            leadingIcon: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priorityColours[task.priority],
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
