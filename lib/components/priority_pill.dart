import 'package:flutter/material.dart';
import 'package:task_finch/helpers/text_helpers.dart';

import '../data/database.dart';

class PriorityPill extends StatelessWidget {
  const PriorityPill({super.key, required this.priority});
  final Priority priority;

  final Map<Priority, Color> priorityColours = const {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: priorityColours[priority], borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        child: Text(priority.name.toSentenceCase(), style: TextStyle(color: Colors.white, fontSize: 12))
    );
  }
}
