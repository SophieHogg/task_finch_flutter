import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/task_item.dart';

import '../data/database.dart';
import '../main.dart';

class SubtaskList extends  StatelessWidget {
  const SubtaskList({super.key, required this.taskList});
  final List<Task> taskList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for(final task in taskList) ProviderScope(
            overrides: [currentTask.overrideWithValue(task)],
            child: const TaskItem(),
          ),
        ],
      ),
    );
  }
}
