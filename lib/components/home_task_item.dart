import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:task_finch/components/children_badge.dart';
import 'package:task_finch/components/priority_pill.dart';
import 'package:task_finch/components/task_item.dart';
import 'package:task_finch/helpers/date_helpers.dart';
import 'package:task_finch/screens/task_detail_screen.dart';

import '../main.dart';
import '../task_get_provider.dart';
import '../theming/constants.dart';



class HomeTaskItem extends HookConsumerWidget {
  const HomeTaskItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final task = ref.watch(currentTask);

    final children = ref.watch(subtasksForTaskId(task.id)).value;


    bool isCompleted = task.completed;

    // key here to update state of submenu button to prevent bug when opening dialog
    // or navigating away that causes the button to remain focused and reopen menu
    final key = useState(ValueKey(0));

    return Card(
      color: lightTopColour,
      elevation: 6,
      child: ListTile(
        minLeadingWidth: 10,
        contentPadding: EdgeInsets.symmetric(horizontal: 2),
        visualDensity: VisualDensity.compact,
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
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 4,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: PriorityPill(priority: task.priority),
                  ),
                  if(children != null && children.length > 0)
                    ChildrenBadge(childrenCount: children.length),
                  Text(
                    'Task #${task.rId}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),

              Row(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                ],
              ),
              if(task.completed) Text('Completed at ${task.completedOn!.toRenderedDate()}', style: TextStyle(fontSize: 14),)
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
