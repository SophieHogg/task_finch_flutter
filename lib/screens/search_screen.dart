import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/components/priority_selector.dart';
import 'package:task_finch/components/priority_wide_indicator.dart';
import 'package:task_finch/theming/constants.dart';

import '../data/database.dart';

class SearchScreen extends HookConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priority = useState<Priority?>(null);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                IconButton(
                  style: IconButton.styleFrom(backgroundColor: baseColour),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) {
                        return _FilterDialog();
                      },
                    );
                  },
                  icon: Icon(Icons.filter_alt, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterDialog extends HookWidget {
  const _FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final priorities = useState<Set<Priority>>({});
    return AlertDialog(
      title: Text('Filtah'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                },
                child: SelectablePriorityPill(
                  priority: Priority.low,
                  selected: !priorities.value.contains(Priority.low),
                ),
              ),
              SelectablePriorityPill(
                priority: Priority.medium,
                selected: !priorities.value.contains(Priority.medium),
              ),
              SelectablePriorityPill(
                priority: Priority.high,
                selected: !priorities.value.contains(Priority.high),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
