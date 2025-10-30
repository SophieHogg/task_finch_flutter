import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/base_nav.dart';
import 'package:task_finch/components/home_task_item.dart';
import 'package:collection/collection.dart';
import '../main.dart';
import '../task_get_provider.dart';

class CompletedScreen extends HookConsumerWidget {
  const CompletedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks =
        ref
            .watch(completedTasks)
            .value ??
        [];
    return Scaffold(
      appBar: AppBar(title: Text('Completed Tasks')),
      bottomNavigationBar: BaseNav(selectedIndex: 1),
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
