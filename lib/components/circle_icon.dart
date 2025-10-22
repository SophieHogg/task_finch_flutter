import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  const CircleIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(100),

    ),
    foregroundDecoration: BoxDecoration(
    border: BoxBorder.all(color: Colors.orange, width: 2),
    borderRadius: BorderRadius.circular(100),

    ),
    child: Image.asset('assets/icon.jpg'),
    );
  }
}
