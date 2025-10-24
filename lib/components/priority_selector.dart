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

  @override
  Widget build(BuildContext context) {
    final _lastSelection = useState<Priority>(priority);
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: fullGradient),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        children:
            [
              for (final priorityGradient in priorityGradients.entries)
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: priorityGradient.key == priority ? Colors.black.withAlpha(40) : Colors.transparent,
                      gradient:
                          priority == priorityGradient.key
                              ? priorityGradient.value
                              : null,
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(
                        color:
                            priority == priorityGradient.key
                                ? Colors.white
                                : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: InkWell(
                      onTap: () => this.onChangePriority(priorityGradient.key),
                      child: Center(
                        child: Text(
                          priorityGradient.key.name.toSentenceCase(),
                          style: TextStyle(
                            color:
                                priorityGradient.key == priority
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ].reversed.toList(),
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
