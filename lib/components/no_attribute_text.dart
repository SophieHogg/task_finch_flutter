import 'package:flutter/material.dart';

class NoAttributeText extends StatelessWidget {
  const NoAttributeText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
        text,
      style: TextStyle( color: Colors.grey)
    );
  }
}
