import 'package:flutter/material.dart';
import 'package:task_finch/theming/constants.dart';

import '../data/database.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.task,
    required this.onConfirm,
    required this.onCancel,
    required this.children,
  });

  final void Function() onConfirm;
  final void Function() onCancel;

  final Task task;
  final int children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Container(
            decoration: BoxDecoration(
              border: BoxBorder.fromLTRB(
                bottom: BorderSide(color: Colors.grey),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Delete Task', style: TextStyle(fontSize: 20)),
                IconButton(
                  onPressed: onCancel,
                  icon: Icon(Icons.close),
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),

              children: [
                TextSpan(text: 'Are you sure you want to delete "'),
                TextSpan(
                  text: task.title,
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: '"?'),
                if (children > 0) TextSpan(text: " Its ${children} subtask"),
                if (children > 1) TextSpan(text: 's'),
                if(children > 0) TextSpan(text: ' will have no parent set.')
              ],
            ),
          ),
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onCancel,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: baseColour, width: 2),
                  ),

                  child: Text('Cancel'),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(color: dangerColour, width: 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 8,
                    children: [
                      Icon(Icons.delete_forever, color: dangerColour),
                      Text('Delete', style: TextStyle(color: dangerColour)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
