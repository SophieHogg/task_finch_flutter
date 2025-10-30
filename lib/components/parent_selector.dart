import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/priority_circle.dart';
import 'package:task_finch/theming/constants.dart';

import '../data/database.dart';
import '../task_get_provider.dart';

final possibleParentProvider = Provider.family<List<Task>, String?>((
  ref,
  taskId,
) {
  final tasks = ref.watch(tasksExceptForId(taskId));
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

typedef TaskEntry = DropdownMenuEntry<Task?>;

class ParentSelector extends HookConsumerWidget {
  ParentSelector({
    super.key,
    required this.onChangeParent,
    this.initialParent,
    this.taskId,
  });

  final void Function(Task? parent) onChangeParent;
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
    final taskList = ref.watch(possibleParentProvider(taskId));
    final filteredTaskList = taskList.whereNot((task) => task.id == taskId);
    final taskController = useTextEditingController(text: initialParent?.title);
    return DropdownMenu<Task?>(
      
      menuHeight: MediaQuery.sizeOf(context).height/2,
      // Disable the input if there are no tasks to be selected and show hint text
      enabled: filteredTaskList.length > 0,
      hintText: filteredTaskList.length == 0 ? 'No available tasks' : '',
      initialSelection: selectedTask.value,
      controller: taskController,
      textStyle: TextStyle(
        color: selectedTask.value == null ? Colors.grey : Colors.black,
      ),
      trailingIcon: Icon(Icons.keyboard_arrow_down),
      selectedTrailingIcon: Icon(Icons.keyboard_arrow_up),
      // The default requestFocusOnTap value depends on the platform.
      // On mobile, it defaults to false, and on desktop, it defaults to true.
      // Setting this to true will trigger a focus request on the text field, and
      // the virtual keyboard will appear afterward.
      requestFocusOnTap: true,
      onSelected: (Task? task) {
        selectedTask.value = task;
        onChangeParent(task);
      },
      expandedInsets: EdgeInsets.zero,
      enableFilter: true,
      leadingIcon: PriorityCircle(
        priority: selectedTask.value?.priority,
        size: 16,
      ),
      inputDecorationTheme: InputDecorationTheme.of(context),
      menuStyle: MenuStyle(
        elevation: WidgetStatePropertyAll(6),
        backgroundColor: WidgetStatePropertyAll(lightTopColour),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        maximumSize: WidgetStatePropertyAll(Size.infinite),
      ),
      dropdownMenuEntries: [
        TaskEntry(
          value: null,
          labelWidget: Text(
            'No parent',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
          label: 'No parent',
          leadingIcon: PriorityCircle(priority: null),
        ),
        for (final task in filteredTaskList)
          TaskEntry(
            value: task,
            label: task.title,
            style: ButtonStyle(
              textStyle: WidgetStateProperty.all(TextStyle(inherit: false, fontSize: 15)),
            ),
            leadingIcon: PriorityCircle(priority: task.priority),
            trailingIcon: Text(
              '#${task.rId}',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
