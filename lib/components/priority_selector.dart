import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_finch/helpers/text_helpers.dart';
import 'package:task_finch/theming/business_logic_theming.dart';
import '../data/database.dart';

typedef PriorityEntry = DropdownMenuEntry<Priority>;

class PrioritySelector extends HookWidget {
  PrioritySelector({
    super.key,
    required this.priority,
    required this.onChangePriority,
  });

  final Priority priority;
  final void Function(Priority priority) onChangePriority;

  // ease out back jumps past the edges too far
  // this adjusts the default values: 'd' from 1.275 to 1.10
  static const _betterEaseOutBack = Cubic(0.175, 0.885, 0.32, 1.10);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: fullGradient),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            AnimatedSlide(
              offset: Offset(2 - priority.index.toDouble(), 0),
              duration: Duration(milliseconds: 300),
              curve: _betterEaseOutBack,
              child: FractionallySizedBox(
                widthFactor: 1 / 3,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(40),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children:
              [
                for (final priorityGradient in priorityGradients.entries)
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.white.withAlpha(50),
                      borderRadius: BorderRadius.circular(100),
                      onTap:
                          () => this.onChangePriority(priorityGradient.key),
                      child: Center(
                        child: AnimatedDefaultTextStyle(
                          style: TextStyle(
                            color:
                            priorityGradient.key == priority
                                ? Colors.white
                                : Colors.black,
                          ),
                          duration: Duration(milliseconds: 200),
                          child: Text(
                            priorityGradient.key.name.toSentenceCase(),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ].reversed.toList(),
            ),
          ],
        ),
      ),
    );
  }
}
