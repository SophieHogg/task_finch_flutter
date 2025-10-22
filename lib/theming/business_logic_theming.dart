import 'package:flutter/material.dart';

import '../data/database.dart';

const lowPriority = LinearGradient(colors: [
  Color(0xFF7ED957),
  Color(0xFF43C67A),
]);

const mediumPrioirty = LinearGradient(colors: [
  Color(0xFFFFC300),
  Color(0xFFFF8C00),
]);

const highPriority = LinearGradient(colors: [
  Color(0xFFFF595E),
  Color(0xFFD7263D),
]);

const nullPriority = LinearGradient(colors: [
  Color(0xFFBDBDBD),
  Color(0xFF6699CC),
]);


const fullGradient = [
  Color(0xFF7ED957),
  Color(0xFF43C67A),

  Color(0xFFFFC300),
  Color(0xFFFF8C00),

  Color(0xFFFF595E),
  Color(0xFFD7263D),
];


final Map<Priority, LinearGradient> priorityGradients = {
  Priority.high: highPriority,
  Priority.medium: mediumPrioirty,
  Priority.low: lowPriority,
};