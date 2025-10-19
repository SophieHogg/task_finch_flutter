import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/screens/task_detail_screen.dart';

import '../main.dart';

class TaskItem extends HookConsumerWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(currentTask);

    bool isCompleted = task.completed;

    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) async {
            if (value == null) return;
            isCompleted = value;
            if (value)
              ref.read(taskListProvider.notifier).markTaskComplete(task.id);
            else
              ref.read(taskListProvider.notifier).markTaskIncomplete(task.id);
          },
        ),
        title: Opacity(
          opacity: task.completed ? 0.6 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title),
              Align(
                alignment: Alignment.centerLeft,
                child: PriorityPill(priority: task.priority),
              ),
              Text(task.parentId ?? ''),
            ],
          ),
        ),
      ),
    );
  }
}
