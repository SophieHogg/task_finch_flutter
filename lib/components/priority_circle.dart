import 'package:flutter/material.dart';
import 'package:task_finch/theming/business_logic_theming.dart';

import '../data/database.dart';

class PriorityCircle extends StatelessWidget {
  const PriorityCircle({super.key, required this.priority});
  final Priority? priority;

  @override
  Widget build(BuildContext context) {
    return priority != null ? SizedBox(
      width: 12,
      height: 12,
      child: Center(
        child: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            gradient: priorityGradients[priority],
            shape: BoxShape.circle,
          ),
        ),
      ),
    ) : SizedBox.shrink();
  }
}
