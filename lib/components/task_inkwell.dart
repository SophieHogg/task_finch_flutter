// navigate to task using a simple inkwell

import 'package:flutter/material.dart';
import 'package:task_finch/components/no_attribute_text.dart';
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
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: taskItem),
            ),
          );
        },
        child: Row(
          spacing: 8,
          children: [
            Container(
              width: 8,
              height: 8,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: priorityColours[taskItem.priority],
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Text(taskItem.title),
          ],
        ),
      );
    else
      return NoAttributeText(text: placeholder);
  }
}
