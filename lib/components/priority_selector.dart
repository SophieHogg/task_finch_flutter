import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:task_finch/components/priority_circle.dart';
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

  @override
  Widget build(BuildContext context) {
    final _lastSelection = useState<Priority>(priority);

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
            leadingIcon: PriorityCircle(priority: priority.key)
          ),
      ],
    );
  }
}
