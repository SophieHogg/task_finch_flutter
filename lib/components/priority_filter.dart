import 'package:flutter/material.dart';
import 'package:task_finch/components/split_selector.dart';

import '../data/database.dart';
import '../theming/business_logic_theming.dart';

class PriorityFilter extends StatelessWidget {
  const PriorityFilter({
    super.key,
    required this.selectedPriorities,
    required this.onPriorityChange,
  });

  final Set<Priority> selectedPriorities;
  final Function(Set<Priority>) onPriorityChange;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SplitSelector(
            tConverter: (priority) => priority.name,
            optionList: priorityGradients.keys.toList().reversed.toList(),
            optionGradients: priorityGradients.values.toList().reversed.toList(),
            onTap: (tappedPriority) {
              if (selectedPriorities.contains(tappedPriority)) {
                onPriorityChange(
                  selectedPriorities
                      .where((key) => key != tappedPriority)
                      .toSet(),
                );
              } else {
                onPriorityChange(
                  {...selectedPriorities, tappedPriority}.toSet(),
                );
              }
              ;
            },
            selected: selectedPriorities.toList(),
          ),
        ),
      ],
    );
  }
}

