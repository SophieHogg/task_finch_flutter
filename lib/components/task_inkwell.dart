// navigate to task using a simple inkwell

import 'package:flutter/material.dart';
import 'package:task_finch/components/no_attribute_text.dart';
import 'package:task_finch/components/priority_circle.dart';
import 'package:task_finch/data/database.dart';

import '../screens/task_detail_screen.dart';

class TaskInkwell extends StatelessWidget {
  const TaskInkwell({super.key, this.task, this.placeholder = 'No task'});

  final Task? task;
  final String placeholder;
  @override
  Widget build(BuildContext context) {
    if (task case final taskItem?)
      return InkWell(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: taskItem),
            ),
          );
        },
        child: Padding(
          // Adjust for visual weight of priority circle
          padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              PriorityCircle(priority: taskItem.priority),
              Text(taskItem.title),
            ],
          ),
        ),
      );
    else
      return NoAttributeText(text: placeholder);
  }
}
