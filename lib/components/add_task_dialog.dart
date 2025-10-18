import 'package:flutter/material.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key, required this.onAdd});
  final void Function (String title, String? description, DateTime createdOn, String? parentId) onAdd;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

      ],
    );
  }
}
