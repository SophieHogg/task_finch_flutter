import 'package:flutter/material.dart';
import 'package:task_finch/theming/constants.dart';

class ChildrenBadge extends StatelessWidget {
  const ChildrenBadge({
    super.key,
    required this.incompleteChildrenCount,
    this.completedChildrenCount,
  });

  final int incompleteChildrenCount;
  final int? completedChildrenCount;

  int get totalChildrenCount =>
      incompleteChildrenCount + (completedChildrenCount ?? 0);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      triggerMode: TooltipTriggerMode.tap,
      showDuration: Duration(milliseconds: 3000),
      richMessage: WidgetSpan(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('To do: ${incompleteChildrenCount}'),
            Text('Completed: ${completedChildrenCount}'),
          ],
        ),
      ),
      child: InkWell(
        child: Container(
          width: 60,
          height: 25,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            border: BoxBorder.all(color: secondaryColour),
          ),
          child: Row(
            spacing: 4,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.checklist, color: secondaryColour, size: 20),
              FittedBox(
                child: Text(
                  incompleteChildrenCount.toString(),
                  style: TextStyle(
                    color: secondaryColour,
                    fontWeight: FontWeight.w700,
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
