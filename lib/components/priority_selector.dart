import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_finch/components/priority_circle.dart';
import 'package:task_finch/helpers/text_helpers.dart';
import 'package:task_finch/theming/business_logic_theming.dart';
import 'package:collection/collection.dart';
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
    final _lastSelection = useState<Priority>(priority);
    return Container(
      height: 50,
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
                widthFactor: 1/3,
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(40),
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Colors.white, width: 3),
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
    return DropdownMenu<Priority>(
      initialSelection: _lastSelection.value,
      enableSearch: false,
      requestFocusOnTap: false,
      onSelected: (Priority? priority) {
        _lastSelection.value = priority ?? Priority.medium;
        onChangePriority(priority ?? Priority.medium);
      },
      leadingIcon: PriorityCircle(priority: _lastSelection.value),
      expandedInsets: EdgeInsets.zero,
      enableFilter: false,
      inputDecorationTheme: InputDecorationTheme.of(context),
      dropdownMenuEntries: [
        for (final priority in priorityGradients.entries)
          PriorityEntry(
            value: priority.key,
            label: priority.key.name.toSentenceCase(),
            leadingIcon: PriorityCircle(priority: priority.key),
          ),
      ],
    );
  }
}
