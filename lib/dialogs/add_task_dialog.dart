import 'package:flutter/material.dart';
import 'package:task_finch/components/parent_selector.dart';
import 'package:task_finch/components/priority_selector.dart';
import 'package:task_finch/task_provider.dart';

import '../data/database.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd, this.defaultParent});

  final void Function(TaskAddRequest taskAddRequest) onAdd;
  final Task? defaultParent;
  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  Priority priority = Priority.medium;

  Task? parent;
  @override
  void initState() {
    super.initState();
    parent = widget.defaultParent;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          spacing: 16.0,
          children: [
            Text("New Task"),
            TextFormField(
              controller: titleController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                label: const Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Title'),
                    const Text('*', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
              validator: (String? value) {
                return ((value == null || value.trim() == '')
                    ? 'Title is required'
                    : null);
              },
            ),
            TextFormField(
              controller: descriptionController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(labelText: 'Description'),
              minLines: 3,
              maxLines: 5,
            ),
            PrioritySelector(priority: priority, onChangePriority: (newPriority) => priority = newPriority),
            ParentSelector(onChangeParent: (newParent) => parent = newParent, initialParent: parent),
            Spacer(),
            ElevatedButton(

              onPressed: () {

                if (_formKey.currentState?.validate()?? false) {
                  widget.onAdd(
                    TaskAddRequest(
                      title: titleController.text.trim(),
                      description: descriptionController.text,
                      priority: priority,
                      parentId: parent?.id,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Row(
                spacing: 8.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  Text('Add', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
