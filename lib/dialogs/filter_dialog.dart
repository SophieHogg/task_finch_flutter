import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../components/completed_filter.dart';
import '../components/label_input.dart';
import '../components/priority_filter.dart';
import '../data/database.dart';
import '../screens/task_detail_screen.dart';

class FilterDialog extends HookWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final priorities = useState<Set<Priority>>(priorityColours.keys.toSet());
    final completed = useState<Set<CompletionStatus>>(CompletionStatus.values.toSet());

    return AlertDialog(
      actions: [
        ElevatedButton(
          onPressed:
              completed.value.length > 0 && priorities.value.length > 0
                  ? () {
                    Navigator.pop(context, (
                      filterStatus: completed.value,
                      filterPriority: priorities.value,
                    ));
                  }
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [Icon(Icons.filter_alt), Text('Filter')],
          ),
        ),
      ],
      title: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Filter', style: TextStyle(fontSize: 20)),
              Icon(Icons.filter_alt),
            ],
          ),
          Divider(),
        ],
      ),
      content: Column(
        spacing: 16,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          LabelInput(
            label: "Priority",
            field: PriorityFilter(
              selectedPriorities: priorities.value,
              onPriorityChange:
                  (newPriorities) => priorities.value = newPriorities,
            ),
          ),
          LabelInput(
            label: 'Completed',
            field: CompletedFilter(
              selectedOptions: completed.value,
              onChange: (newCompleted) => completed.value = newCompleted,
            ),
          ),
        ],
      ),
    );
  }
}
