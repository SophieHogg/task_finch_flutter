import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/database.dart';
import '../main.dart';

final possibleParentProvider = Provider<List<Task>>((ref) {
  final tasks = ref.watch(taskListProvider);
  // ensure the incomplete tasks are at the top
  final incompleteTasks = tasks.value
      ?.where((task) => !task.completed)
      .sortedBy((task) => task.priority.index);
  final completeTasks = tasks.value
      ?.where((task) => task.completed)
      .toList()
      .sortedBy((task) => task.priority.index);
  return [...?incompleteTasks, ...?completeTasks];
});

typedef TaskEntry = DropdownMenuEntry<Task>;

class ParentSelector extends HookConsumerWidget {
  ParentSelector({super.key, required this.onChangeParent, this.initialParent, this.taskId});

  final void Function (Task? parent) onChangeParent;
  final Task? initialParent;
  final String? taskId;
  final Map<Priority, Color> priorityColours = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTask = useState<Task?>(initialParent);
    final taskList = ref.watch(possibleParentProvider);
    final filteredTaskList = taskList.whereNot((task) => task.id == taskId);
    final taskController = useTextEditingController();
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
      leadingIcon: SizedBox(
        width: 8,
        height: 8,
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: priorityColours[selectedTask.value?.priority],
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme.of(context),
      dropdownMenuEntries: [
        for (final task in filteredTaskList)
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
