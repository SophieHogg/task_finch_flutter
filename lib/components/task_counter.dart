import 'package:flutter/material.dart';

class TaskCounter extends StatelessWidget {
  const TaskCounter({super.key, required this.incompleteTasks, required this.completedTasks});

  final int incompleteTasks;
  final int completedTasks;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${incompleteTasks}')
      ],
    );
  }
}
