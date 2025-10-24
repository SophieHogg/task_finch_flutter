import 'package:flutter/material.dart';
import 'package:task_finch/theming/constants.dart';

class ChildrenBadge extends StatelessWidget {
  const ChildrenBadge({super.key, required this.childrenCount});

  final int childrenCount;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              childrenCount.toString(),
              style: TextStyle(
                color: secondaryColour,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
