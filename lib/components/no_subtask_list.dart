import 'package:flutter/material.dart';

import 'no_attribute_text.dart';

class NoSubtaskList extends StatelessWidget {
  const NoSubtaskList({super.key, required this.onAddSubtask});

  final void Function() onAddSubtask;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('You currently have no subtasks.'),
        ElevatedButton(
          onPressed: () => {onAddSubtask()},
          child: Row(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add),
              Text('Add task'),
            ],
          ),
        ),
      ],
    );
  }
}
