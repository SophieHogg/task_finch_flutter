import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todos/components/priority_pill.dart';
import 'package:todos/helpers/text_helpers.dart';

import '../data/database.dart';
import '../main.dart';

class TodoItem extends HookConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodo, );

    bool isCompleted = todo.completed;

    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {

        },
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) async {
            if (value == null) return;
            isCompleted = value;
            if (value)
              ref.read(todoListProvider.notifier).markComplete(todo.id);
            else
              ref.read(todoListProvider.notifier).markIncomplete(todo.id);
          },
        ),
        title:
            Opacity(
              opacity: todo.completed ? 0.6 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(todo.title),
              Align(
                alignment: Alignment.centerLeft,
                child: PriorityPill(priority: todo.priority),
              ),
                          ],
              ),
            ),
      ),
    );
  }
}
