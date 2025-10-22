import 'package:flutter/material.dart';
import 'package:task_finch/helpers/text_helpers.dart';
import 'package:task_finch/theming/business_logic_theming.dart';

import '../data/database.dart';

class PriorityPill extends StatelessWidget {
  const PriorityPill({super.key, required this.priority});
  final Priority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 80,
      decoration: BoxDecoration(gradient: priorityGradients[priority], borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 10.0),
        child: Text(priority.name.toSentenceCase(), style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))
    );
  }
}
