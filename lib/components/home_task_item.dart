import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/screens/task_detail_screen.dart';

import '../main.dart';
import '../theming/constants.dart';

class TaskItemSubmenuItem {
  final Widget? label;
  final Widget? icon;
  final void Function() onPressed;

  TaskItemSubmenuItem({this.label, this.icon, required this.onPressed});
}

class HomeTaskItem extends HookConsumerWidget {
  const HomeTaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(currentTask);

    bool isCompleted = task.completed;

    List<TaskItemSubmenuItem> submenuItemList = [
      TaskItemSubmenuItem(
        label: Text(style: TextStyle(color: dangerColour), 'Delete'),
        icon: Icon(color: dangerColour, Icons.delete),
        onPressed: () {
          ref.read(taskListProvider.notifier).deleteTaskById(task.id);
        },
      ),
    ];

    // key here to update state of submenu button to prevent bug when opening dialog
    // or navigating away that causes the button to remain focused and reopen menu
    final key = useState(ValueKey(0));

    return Card(
      color: lightTopColour,
      elevation: 6,
      child: ListTile(
        minLeadingWidth: 10,
        contentPadding: EdgeInsets.all(2),
        minVerticalPadding: 4,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 4,
            children: [
              Flexible(
                child: Tooltip(
                  message: task.title,
                  child: Text(
                    task.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 20,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
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
            alignmentOffset: Offset(-50, 0),
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
                  child: menuItem.label ?? SizedBox.shrink(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
