import 'package:flutter/material.dart';
import 'package:task_finch/theming/business_logic_theming.dart';

import '../data/database.dart';

class PriorityCircle extends StatelessWidget {
  const PriorityCircle({super.key, required this.priority, this.size = 12});
  final Priority? priority;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: priority != null ? priorityGradients[priority] : nullPriority,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
