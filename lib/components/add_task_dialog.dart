import 'package:flutter/material.dart';
import 'package:todos/todoProvider.dart';

class AddTaskDialog extends StatefulWidget {
  const AddTaskDialog({super.key, required this.onAdd});

  final void Function(TaskAddRequest taskAddRequest) onAdd;

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 8.0,
          children: [
            TextFormField(
              controller: titleController,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                label: const Row(
                  spacing: 4,
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
            Spacer(),
            ElevatedButton(

              onPressed: () {

                if (_formKey.currentState?.validate()?? false) {
                  widget.onAdd(
                    TaskAddRequest(
                      title: titleController.text.trim(),
                      description: descriptionController.text,
                      parentId: '1234',
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
