import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String text;
  final String? taglineText;
  const EmptyState({super.key, required this.text, this.taglineText});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          if(taglineText case final text?)
            Text(text, textAlign: TextAlign.center, style: TextStyle(fontSize: 16))
        ],
      ),
    );
  }
}
