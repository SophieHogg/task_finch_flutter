import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:todos/helpers/text_helpers.dart';

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
  final Map<Priority, Color> priorityColours = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };


  @override
  Widget build(BuildContext context) {
    final _lastSelection = useState<Priority>(priority);

    return DropdownMenu<Priority>(
      initialSelection: _lastSelection.value,
      enableSearch: false,
      requestFocusOnTap: false,
      label: const Text('Priority'),
      onSelected: (Priority? priority) {
        _lastSelection.value = priority ?? Priority.medium;
        onChangePriority(priority ?? Priority.medium);
      },
      expandedInsets: EdgeInsets.zero,
      enableFilter: false,
      inputDecorationTheme: InputDecorationTheme.of(context),
      dropdownMenuEntries: [
        for (final priority in priorityColours.entries)
          PriorityEntry(
            value: priority.key,
            label: priority.key.name.toSentenceCase(),
            leadingIcon: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priority.value,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
