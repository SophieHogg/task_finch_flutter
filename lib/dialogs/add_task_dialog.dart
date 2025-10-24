import 'package:flutter/material.dart';
import 'package:task_finch/components/parent_selector.dart';
import 'package:task_finch/components/priority_selector.dart';
import 'package:task_finch/task_provider.dart';

import '../data/database.dart';
import '../theming/constants.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("New Task")),
      // bottomNavigationBar: ElevatedButton(onPressed: null, child: Text('h')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      spacing: 16.0,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Title ',
                                  style: TextStyle(fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: dangerColour,
                                  ),
                                ),
                              ],
                            ),
                            TextFormField(
                              controller: titleController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: const InputDecoration(),
                              validator: (String? value) {
                                if ((value == null || value.trim() == ''))
                                  return 'Title is required';
                                else if (value.length > 50)
                                  return 'Max length: 50 characters. Current length: ${value.length}';
                                else
                                  return null;
                              },
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            Text(
                              'Description',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextFormField(
                              controller: descriptionController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,

                              minLines: 3,
                              maxLines: 5,
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            Text(
                              'Priority',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            PrioritySelector(
                              priority: priority,
                              onChangePriority: (newPriority) {
                                setState(() {
                                  priority = newPriority;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 4.0,
                          children: [
                            Text(
                              'Parent task',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            ParentSelector(
                              onChangeParent: (newParent) => parent = newParent,
                              initialParent: parent,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: positiveColour,
                ),
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
      ),
    );
  }
}
