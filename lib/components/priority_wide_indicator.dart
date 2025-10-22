import 'package:flutter/material.dart';
import 'package:task_finch/helpers/text_helpers.dart';
import 'package:task_finch/theming/business_logic_theming.dart';

import '../data/database.dart';

class PriorityIndicator extends StatelessWidget {
  const PriorityIndicator({super.key, required this.priority});

  final Priority priority;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: fullGradient),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              for (final value in Priority.values.reversed)
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: priority == value ? Colors.black.withAlpha(100) : Colors.white.withAlpha(20),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${value.name.toSentenceCase()}',
                      style: TextStyle(
                        color: priority == value ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w700
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
