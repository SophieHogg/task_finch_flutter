import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todos/helpers/text_helpers.dart';

import '../data/database.dart';

class PrioritySelector extends StatefulWidget {
  const PrioritySelector({
    super.key,
    required this.priority,
    required this.onChangePriority,
  });

  final Priority priority;
  final void Function(Priority priority) onChangePriority;

  @override
  State<PrioritySelector> createState() => _PrioritySelectorState();
}

class _PrioritySelectorState extends State<PrioritySelector> {
  late Priority _lastSelection;

  @override
  void initState() {
    super.initState();
    _lastSelection = widget.priority;
  }

  final Map<Priority, Color> priorityColours = {
    Priority.high: Colors.red,
    Priority.medium: Colors.orange,
    Priority.low: Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MenuAnchor(
          menuChildren: <Widget>[
            for (final priorityColour in priorityColours.entries)
              MenuItemButton(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    spacing: 8,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: priorityColour.value,
                          shape: BoxShape.circle,
                        ),
                      ),

                      Text(priorityColour.key.name.toSentenceCase()),
                      if (priorityColour.key == _lastSelection)
                        Icon(Icons.check),
                    ],
                  ),
                ),
                onPressed: () => _activate(priorityColour.key),
              ),
          ],
          builder: (
            BuildContext context,
            MenuController controller,
            Widget? child,
          ) {
            return OutlinedButton(
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              child: Row(
                spacing: 8,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: priorityColours[_lastSelection],
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(_lastSelection.name.toSentenceCase()),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _activate(Priority selection) {
    setState(() {
      _lastSelection = selection;
      widget.onChangePriority(selection);
    });
  }
}
