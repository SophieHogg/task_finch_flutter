import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/components/no_attribute_text.dart';
import 'package:task_finch/components/no_subtask_list.dart';
import 'package:task_finch/components/task_inkwell.dart';
import 'package:task_finch/helpers/date_helpers.dart';
import 'package:task_finch/main.dart';
import 'package:task_finch/theming/constants.dart';

import '../components/priority_wide_indicator.dart';
import '../components/subtask_list.dart';
import '../data/database.dart';
import '../dialogs/add_task_dialog.dart';
import '../dialogs/edit_task_dialog.dart';
import '../task_get_provider.dart';

final Map<Priority, Color> priorityColours = {
  Priority.high: Colors.red,
  Priority.medium: Colors.orange,
  Priority.low: Colors.green,
};

class TaskDetailScreen extends HookConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  ValueNotifier<Task?>? _parent(String? parentId, WidgetRef ref) {
    if (parentId == null)
      return useState(null);
    else {
      final parentTaskData = ref.watch(taskById(parentId));
      if (parentTaskData is AsyncData)
        return useState(parentTaskData.value);
      else
        // Return null as we don't want to set the initial value until the parent task data is loaded.
        return null;
    }
  }

  void openAddTaskDialog(Task parent, BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog.fullscreen(
          child: AddTaskDialog(
            defaultParent: parent,
            onAdd: (taskAddRequest) {
              ref.read(taskListProvider.notifier).addTask(taskAddRequest);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(taskById(taskId)).value;
    if (task == null) return SizedBox.shrink();

    final taskTitle = task.title;
    final description = task.description?.trim() ?? '';

    final subtaskList = ref.watch(subtasksForTaskId(task.id));
    final parent = _parent(task.parentId, ref);
    final parentValue = parent?.value;

    final subtaskListLength = subtaskList.value?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            onPressed:
                () => {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog.fullscreen(
                        child: EditTaskDialog(task: task),
                      );
                    },
                  ),
                },
            icon: Icon(color: Colors.white, size: 30, Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.completedOn case final completedOn?)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 16,
                  children: [
                    Icon(
                      Icons.checklist_rtl_rounded,
                      size: 28,
                      color: dangerColour,
                    ),
                    Text('Completed', style: TextStyle(fontSize: 18)),
                    Text(
                      completedOn.toRenderedDate(),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  if (parentValue != null) TaskInkwell(task: parentValue),
                  Text(
                    taskTitle,
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                  Text(
                    'Task ${task.rId}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  description.isNotEmpty
                      ? Text(description, style: TextStyle(fontSize: 16))
                      : NoAttributeText(text: 'No description provided'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    'Priority:',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  PriorityIndicator(priority: task.priority),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtasks${subtaskListLength > 0 ? ' ($subtaskListLength)' : ''}:',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      IconButton.filled(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            positiveColour,
                          ),
                        ),

                        onPressed: () => openAddTaskDialog(task, context, ref),
                        icon: Icon(Icons.add, color: Colors.white),
                      ),
                    ],
                  ),
                  if (subtaskList.value case final listValue?)
                    listValue.isNotEmpty
                        ? SubtaskList(taskList: listValue)
                        : NoSubtaskList(
                          onAddSubtask:
                              () => openAddTaskDialog(task, context, ref),
                        )
                  else
                    Text('loading...'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BaseNav(),
    );
  }
}
