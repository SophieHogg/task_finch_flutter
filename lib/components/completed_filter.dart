import 'package:flutter/material.dart';
import 'package:task_finch/components/split_selector.dart';

class CompletedFilter extends StatelessWidget {
  const CompletedFilter({
    super.key,
    required this.selectedOptions,
    required this.onChange,
  });

  final Set<String> selectedOptions;
  final Function(Set<String>) onChange;

  @override
  Widget build(BuildContext context) {
    Set<Gradient> completeGradients =
        [
          LinearGradient(colors: [Color(0xFF092475), Color(0xFF2A1AD8)]),
          LinearGradient(colors: [Color(0xFF4B2A57), Color(0xFF341C3A)]),
        ].toSet();

    return Row(
      children: [
        Expanded(
          child: SplitSelector(
            tConverter: (option) => option,
            optionList: ['Completed', 'Incomplete'],
            optionGradients: completeGradients.toList(),
            onTap: (tappedOption) {
              if (selectedOptions.contains(tappedOption)) {
                onChange(
                  selectedOptions.where((key) => key != tappedOption).toSet(),
                );
              } else {
                onChange({...selectedOptions, tappedOption}.toSet());
              }
              ;
            },
            selected: selectedOptions.toList(),
          ),
        ),
      ],
    );
  }
}
