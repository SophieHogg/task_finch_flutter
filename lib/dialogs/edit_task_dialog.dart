import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/parent_selector.dart';
import 'package:task_finch/components/priority_selector.dart';
import 'package:task_finch/main.dart';
import 'package:task_finch/task_provider.dart';

import '../data/database.dart';
import '../task_get_provider.dart';

final Map<Priority, Color> priorityColours = {
  Priority.high: Colors.red,
  Priority.medium: Colors.orange,
  Priority.low: Colors.green,
};

class EditTaskDialog extends HookConsumerWidget {
  const EditTaskDialog({super.key, required this.task});

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = useState<bool>(false);
    final priority = useState<Priority>(task.priority);

    final titleController = useTextEditingController(text: task.title);
    final editedText = useListenable(titleController);
    final description = task.description?.trim() ?? '';
    final descriptionController = useTextEditingController(text: description);

    // final subtaskList = ref.watch(subtasksForTaskId(task.id));
    final parent = _parent(task.parentId, ref);
    final parentValue = parent?.value;
    final titleHasText = editedText.text.isNotEmpty;
    final titleTooLong = editedText.text.length > 50;
    final disableSubmit = !titleHasText && !titleTooLong;

    // final subtaskListLength = subtaskList.value?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Task ${task.rId}'),
        actions: [
          Tooltip(
            message:
                disableSubmit
                    ? !titleHasText
                        ? 'Title must be provided'
                        : 'Title must be less than 50 characters'
                    : 'Save Changes',
            child: Opacity(
              opacity: !disableSubmit || !isEditing.value ? 1 : 0.6,
              child: IconButton(
                onPressed:
                    !disableSubmit
                        ? () {
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
                          Navigator.pop(context);
                        }
                        : null,
                icon: Icon(color: Colors.white, size: 30, Icons.check),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          minimum: EdgeInsets.all(16.0),
          child: Column(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text('Title:', style: TextStyle(fontWeight: FontWeight.w700)),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (String? value) {
                      if ((value == null || value.trim() == ''))
                        return 'Title is required';
                      else if (value.length > 50)
                        return 'Max length: 50 characters. Current length: ${value.length}';
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
                  TextField(
                    minLines: 3,
                    maxLines: 10,
                    controller: descriptionController,
                  ),
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
                  PrioritySelector(
                    priority: priority.value,
                    onChangePriority:
                        (newPriority) => priority.value = newPriority,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.0,
                children: [
                  Text(
                    'Parent task:',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (parent != null)
                    ParentSelector(
                      taskId: task.id,
                      initialParent: parent.value,
                      onChangeParent: (newParent) => parent.value = newParent,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
