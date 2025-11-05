import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/circle_icon.dart';
import 'package:task_finch/components/home_task_item.dart';

import '../main.dart';
import '../task_get_provider.dart';
import '../theming/constants.dart';

class CompletedScreen extends HookConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(completedTasks).value ?? [];
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleIcon(),
        ),
        actions: [
          SizedBox(width: 60, height: 60,)
        ],
        title: Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
      Icon(Icons.task_alt, size: 28, color: positiveColourTop),
            Text('Completed Tasks'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (final task in tasks) ...[
              // if (i > 0) const Divider(height: 0),
              ProviderScope(
                overrides: [currentTask.overrideWithValue(task)],
                child: const HomeTaskItem(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
