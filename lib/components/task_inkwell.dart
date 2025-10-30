// navigate to task using a simple inkwell

import 'package:flutter/material.dart';
import 'package:task_finch/components/no_attribute_text.dart';
import 'package:task_finch/components/priority_circle.dart';
import 'package:task_finch/data/database.dart';

import '../screens/task_detail_screen.dart';

class TaskInkwell extends StatelessWidget {
  const TaskInkwell({
    super.key,
    this.task,
    this.placeholder = 'No parent task assigned',
  });

  final Task? task;
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    if (task case final taskItem?)
      return Row(
        children: [
          Text('Parent task: '),

          Flexible(
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(100)),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TaskDetailScreen(taskId: taskItem.id),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: BoxBorder.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: Padding(
                  // Adjust for visual weight of priority circle
                  padding: const EdgeInsets.fromLTRB(10, 4, 16, 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      Flexible(child: Text(taskItem.title, maxLines: 1, overflow: TextOverflow.ellipsis,)),
                      PriorityCircle(priority: taskItem.priority),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    else
      return NoAttributeText(text: placeholder);
  }
}
