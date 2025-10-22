import 'package:flutter/material.dart';
import 'package:task_finch/theming/constants.dart';

import '../data/database.dart';

class DeleteTaskDialog extends StatelessWidget {
  const DeleteTaskDialog({
    super.key,
    required this.task,
    required this.onConfirm,
    required this.onCancel,
  });

  final void Function() onConfirm;
  final void Function() onCancel;

  final Task task;

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
                IconButton(onPressed: onCancel, icon: Icon(Icons.close), visualDensity: VisualDensity.compact,),
              ],
            ),
          ),
          Text(
            'Are you sure you want to delete "${task.title}" (Task #${task.rId})?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: onCancel,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: baseColour, width: 2),
                ),

                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.arrow_back, color: baseColour),
                    Text('Cancel'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  side: BorderSide(color: dangerColour, width: 2),
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    Icon(Icons.delete_forever, color: dangerColour),
                    Text('Delete', style: TextStyle(color: dangerColour)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
