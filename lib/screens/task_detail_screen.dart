import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/parent_selector.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/components/priority_selector.dart';

import '../components/task_item.dart';
import '../data/database.dart';
import '../dialogs/add_task_dialog.dart';

final Map<Priority, Color> priorityColours = {
  Priority.high: Colors.red,
  Priority.medium: Colors.orange,
  Priority.low: Colors.green,
};

class TaskDetailScreen extends HookConsumerWidget {
  const TaskDetailScreen({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEditing = useState<bool>(false);
    final priority = useState<Priority>(task.priority);
    final parent = useState<Task?>(null);
    final parentValue = parent.value;

    final titleController = useTextEditingController(text: task.title);
    final description = task.description?.trim() ?? '';
    final descriptionController = useTextEditingController(text: description);

    return Scaffold(
      appBar: AppBar(
        title:
            isEditing.value == true
                ? TextField(controller: titleController)
                : Text(task.title),
      ),
      body: SafeArea(
        minimum: EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.0,
              children: [
                Text(
                  'Description:',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                isEditing.value == true
                    ? TextField(minLines: 3, maxLines: 10)
                    : Text(
                      description.isNotEmpty
                          ? description
                          : 'No description provided',
                    ),
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
                      onChangeParent: (newParent) => parent.value = newParent,
                    )
                    : parentValue == null
                    ? Text('No parent provided')
                    : Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: priorityColours[parentValue.priority],
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Text(parentValue.title),
                      ],
                    ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isEditing.value == true) {
            isEditing.value = false;
          } else {
            isEditing.value = true;
          }
        },
        child: Icon(isEditing.value == true ? Icons.check : Icons.edit),
      ),
    );
  }
}
