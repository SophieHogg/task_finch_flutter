import 'package:flutter/material.dart';

import 'constants.dart';

class TFTheme extends StatelessWidget {
  const TFTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final existingTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: baseColour),
    );
    return Theme(

      data: existingTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColour, surface: lightBackgroundColour, ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          ),
        ),
        scaffoldBackgroundColor: lightBackgroundColour,
        appBarTheme: existingTheme.appBarTheme.copyWith(
          backgroundColor: baseColour,
          titleTextStyle: TextStyle(fontSize: 20, color: Colors.white),
          iconTheme: IconThemeData(size: 20, color: Colors.white),
        ),
        inputDecorationTheme: existingTheme.inputDecorationTheme.copyWith(
          filled: true,
          fillColor: lightTopColour,
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
