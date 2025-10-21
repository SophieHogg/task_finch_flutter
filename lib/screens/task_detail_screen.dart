import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/components/no_attribute_text.dart';
import 'package:task_finch/components/no_subtask_list.dart';
import 'package:task_finch/components/parent_selector.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/components/priority_selector.dart';
import 'package:task_finch/components/task_inkwell.dart';
import 'package:task_finch/components/task_list.dart';
import 'package:task_finch/main.dart';
import 'package:task_finch/task_provider.dart';
import 'package:task_finch/theming/constants.dart';

import '../components/task_item.dart';
import '../data/database.dart';
import '../dialogs/add_task_dialog.dart';
import '../task_get_provider.dart';

final Map<Priority, Color> priorityColours = {
  Priority.high: Colors.red,
  Priority.medium: Colors.orange,
  Priority.low: Colors.green,
};

class TaskDetailScreen extends HookConsumerWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

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
    final isEditing = useState<bool>(false);
    final priority = useState<Priority>(task.priority);

    final titleController = useTextEditingController(text: task.title);
    final editedText = useListenable(titleController);
    final description = task.description?.trim() ?? '';
    final descriptionController = useTextEditingController(text: description);

    final subtaskList = ref.watch(subtasksForTaskId(task.id));
    final parent = _parent(task.parentId, ref);
    final parentValue = parent?.value;
    final titleHasText = editedText.text.isNotEmpty;
    final titleTooLong = editedText.text.length > 50;
    final disableSubmit = !titleHasText && !titleTooLong;

    final subtaskListLength = subtaskList.value?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title:
        isEditing.value == true
            ? Text(titleController.text)
            : Text(editedText.text),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
            minimum: EdgeInsets.all(16.0),
            child: Column(
                spacing: 16.0,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                if (isEditing.value)
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                'Title:',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextFormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (String? value) {
                  if ((value == null || value.trim() == ''))
                    return 'Title is required';
                  else if (value.length > 50)
                    return 'Max length: 50 characters. Current length: ${value
                        .length}';
                  else
                    return null;
                },
                controller: titleController,
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              isEditing.value == true
                  ? TextField(
                minLines: 3,
                maxLines: 10,
                controller: descriptionController,
              )
                  : descriptionController.text.isNotEmpty
                  ? Text(descriptionController.text)
                  : NoAttributeText(text: 'No description provided'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4.0,
            children: [
              if (!isEditing.value)
                Text(
                  'Priority:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              isEditing.value == true
                  ? PrioritySelector(
                priority: priority.value,
                onChangePriority:
                    (newPriority) => priority.value = newPriority,
              )
                  : PriorityPill(priority: priority.value),
            ],
          ),
          if (parent != null)
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        if (!isEditing.value)
          Text(
            'Parent Task:',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        isEditing.value == true
            ? ParentSelector(
          taskId: task.id,
          initialParent: parent.value,
          onChangeParent:
              (newParent) => parent.value = newParent,
        )
            : TaskInkwell(task: parentValue),
      ],
    ),
    Column(
    spacing: 4,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
    Text(
    'Subtasks${subtaskListLength > 0 ? ' ($subtaskListLength)' : ''}:',
    style: TextStyle(fontWeight: FontWeight.w700),
    ),
    Container(
      decoration: BoxDecoration(
          color: positiveColour,
          borderRadius: BorderRadiusGeometry.circular(100)
      ),
      child: IconButton(
        color: Colors.white,
      onPressed: () => openAddTaskDialog(task, context, ref),
      icon: Icon(Icons.add)),
    )
    ],
    ),
    Divider(),
    if (subtaskList.value case final listValue?)
    listValue.isNotEmpty
    ? SubtaskList(taskList: listValue)
        : NoSubtaskList(
    onAddSubtask: () => openAddTaskDialog(task, context, ref),
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
    floatingActionButton: Tooltip(
    message: disableSubmit ?
    !titleHasText ? 'Title must be provided'
        : 'Title must be less than 50 characters'
        : 'Save Changes',
    child: Opacity(
    opacity: !disableSubmit || !isEditing.value ? 1 : 0.6,
    child: FloatingActionButton(
    shape: const CircleBorder(),
    backgroundColor: baseColour,
    onPressed:
    !disableSubmit || isEditing.value == false
    ? () {
    if (isEditing.value == true) {
    ref
        .read(taskListProvider.notifier)
        .editTaskById(
    task.id,
    TaskAddRequest(
    title: titleController.text,
    description: descriptionController.text,
    priority: priority.value,
    parentId: parentValue?.id,
    ),
    );
    isEditing.value = false;
    } else {
    isEditing.value = true;
    }
    }
        : null,
    child: Icon(color: Colors.white, isEditing.value == true ? Icons.check : Icons.edit),
    ),
    )
    ,
    )
    ,
    );
  }
}
