import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/screens/task_detail_screen.dart';

import '../main.dart';

class TaskItemSubmenuItem {
  final String? label;
  final Widget? icon;
  final void Function() onPressed;

  TaskItemSubmenuItem({this.label, this.icon, required this.onPressed});
}

class TaskItem extends HookConsumerWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(currentTask);

    bool isCompleted = task.completed;

    List<TaskItemSubmenuItem> submenuItemList = [
      TaskItemSubmenuItem(
        label: 'Delete',
        icon: Icon(Icons.delete),
        onPressed: () {
          ref.read(taskListProvider.notifier).deleteTaskById(task.id);
        },
      ),
    ];

    // key here to update state of submenu button to prevent bug when opening dialog
    // or navigating away that causes the button to remain focused and reopen menu
    final key = useState(ValueKey(0));

    return Material(
      color: Colors.white,
      elevation: 6,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(task: task),
            ),
          );
        },
        leading: Checkbox(
          value: isCompleted,
          onChanged: (value) async {
            if (value == null) return;
            isCompleted = value;
            if (value)
              ref.read(taskListProvider.notifier).markTaskComplete(task.id);
            else
              ref.read(taskListProvider.notifier).markTaskIncomplete(task.id);
          },
        ),
        title: Opacity(
          opacity: task.completed ? 0.6 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(task.title, maxLines: 3),
              Align(
                alignment: Alignment.centerLeft,
                child: PriorityPill(priority: task.priority),
              ),
            ],
          ),
        ),
        trailing: SizedBox(
          width: 50,
          child: SubmenuButton(
            style: ButtonStyle(
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(30),
                ),
              ),
            ),
            child: Icon(Icons.more_horiz_rounded),
            alignmentOffset: Offset(-30, 0),
            key: key.value,
            onFocusChange: (isFocused) {
              if (!isFocused) key.value = ValueKey(key.value.value + 1);
            },
            menuStyle: MenuStyle(alignment: Alignment.bottomLeft),
            menuChildren: [
              for (final menuItem in submenuItemList)
                MenuItemButton(
                  onPressed: menuItem.onPressed,
                  leadingIcon: menuItem.icon,
                  child: Text(menuItem.label ?? ''),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
