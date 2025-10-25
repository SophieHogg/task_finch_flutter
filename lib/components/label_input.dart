import 'package:flutter/material.dart';

import '../theming/constants.dart';

class LabelInput extends StatelessWidget {
  const LabelInput(
      {super.key, required this.label, required this.field, this.mandatory = false});

  final String label;
  final Widget? field;
  final bool mandatory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 4.0,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
            if(mandatory)
              Text(
                '*',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: dangerColour,
                ),
              ),
          ],
        ),
        if(field case final widget?)
          widget
      ],
    );
  }
}
