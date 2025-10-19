import 'package:flutter/material.dart';

class TFTheme extends StatelessWidget {
  const TFTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final existingTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Color(0x020154)),
    );
    return Theme(
      data: existingTheme.copyWith(
        textTheme: existingTheme.textTheme.copyWith(
          bodyMedium: TextStyle(color: Colors.red),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          ),
        ),
        inputDecorationTheme: existingTheme.inputDecorationTheme.copyWith(
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
          alignLabelWithHint: true,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
      child: child,
    );
  }
}
