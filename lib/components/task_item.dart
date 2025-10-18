import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/database.dart';
import '../main.dart';

class TodoItem extends HookConsumerWidget {
  const TodoItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todo = ref.watch(currentTodo);
    final itemFocusNode = useFocusNode();
    final itemIsFocused = useIsFocused(itemFocusNode);

    final textEditingController = useTextEditingController();
    final textFieldFocusNode = useFocusNode();
    bool isCompleted = todo.completed;

    return Material(
      color: Colors.white,
      elevation: 6,
      child: Focus(
        focusNode: itemFocusNode,
        onFocusChange: (focused) {
          if (focused) {
            textEditingController.text = todo.title;
          } else {
            // Commit changes only when the textfield is unfocused, for performance
            ref
                .read(todoListProvider.notifier)
                .edit(id: todo.id, description: textEditingController.text);
          }
        },
        child: ListTile(
          onTap: () {
            itemFocusNode.requestFocus();
            textFieldFocusNode.requestFocus();
          },
          leading: Checkbox(
            value: isCompleted,
            onChanged:
                (value) async {
                if(value == null) return;
                isCompleted = value;
                await Future.delayed(Duration(milliseconds: 300));
                if(value) ref.read(todoListProvider.notifier).markComplete(todo.id);
                else ref.read(todoListProvider.notifier).markIncomplete(todo.id);
                },
          ),
          title:
          itemIsFocused
              ? TextField(
            autofocus: true,
            focusNode: textFieldFocusNode,
            controller: textEditingController,
          )
              : Text(todo.title),
        ),
      ),
    );
  }
}