import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/children_badge.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/screens/task_detail_screen.dart';

import '../data/database.dart';
import '../dialogs/delete_task_dialog.dart';
import '../main.dart';
import '../task_get_provider.dart';
import '../theming/constants.dart';

class TaskItemSubmenuItem {
  final Widget? label;
  final Widget? icon;
  final void Function() onPressed;

  TaskItemSubmenuItem({this.label, this.icon, required this.onPressed});
}

void onDeleteTask(WidgetRef ref, BuildContext context, Task task) async {
  final children = ref
      .watch(subtasksForTaskId(task.id))
      .value
      ?.where((task) => task.completed == false);

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: DeleteTaskDialog(
          task: task,
          onConfirm: () {
            ref.read(taskListProvider.notifier).deleteTaskById(task.id);
            Navigator.pop(context);
          },
          children: children?.length ?? 0,
          onCancel: () => Navigator.pop(context),
        ),
      );
    },
  );
}

List<TaskItemSubmenuItem> submenuItemList(
  WidgetRef ref,
  BuildContext context,
  Task task,
) {
  return [
    TaskItemSubmenuItem(
      label: Text(style: TextStyle(color: dangerColour), 'Delete'),
      icon: Icon(color: dangerColour, Icons.delete),
      onPressed: () {
        onDeleteTask(ref, context, task);
      },
    ),
  ];
}

class TaskItem extends HookConsumerWidget {
  const TaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(currentTask);
    final children = ref
        .watch(subtasksForTaskId(task.id))
        .value
        ?.where((task) => task.completed == false);
    final completedChildren = ref
        .watch(subtasksForTaskId(task.id))
        .value
        ?.where((task) => task.completed == true);

    bool isCompleted = task.completed;

    // key here to update state of submenu button to prevent bug when opening dialog
    // or navigating away that causes the button to remain focused and reopen menu
    final key = useState(ValueKey(0));

    return Card(
      color: lightTopColour,
      elevation: 6,
      child: ListTile(
        visualDensity: VisualDensity.compact,
        minLeadingWidth: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 2),

        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetailScreen(taskId: task.id),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PriorityPill(priority: task.priority),
                  ),
                  if (children != null && children.length > 0)
                    ChildrenBadge(
                      incompleteChildrenCount: children.length,
                      completedChildrenCount: completedChildren?.length ?? 0,
                    ),
                  Text(
                    'Task #${task.rId}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text(task.title, maxLines: 3)],
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
              for (final menuItem in submenuItemList(ref, context, task))
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
