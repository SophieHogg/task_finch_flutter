import 'package:flutter/material.dart';

import 'constants.dart';

class TFTheme extends StatelessWidget {
  const TFTheme({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final existingTheme = ThemeData(
      fontFamily: 'Ubuntu',
      colorScheme: ColorScheme.fromSeed(seedColor: baseColour),
    );
    return Theme(

      data: existingTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: baseColour, surface: lightBackgroundColour, ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(16),
            side: BorderSide(width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
          ),
        ),
        checkboxTheme: existingTheme.checkboxTheme.copyWith(
          fillColor: WidgetStateProperty.resolveWith(((Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return baseColour; // Color when checked
            }
            return Colors.transparent; // Color when unchecked
          }),),
        ),
        scaffoldBackgroundColor: lightBackgroundColour,
        appBarTheme: existingTheme.appBarTheme.copyWith(
          backgroundColor: baseColour,
          // due to a bug in the appBar, font family also has to be declared separately here
          titleTextStyle: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'Ubuntu'),
          iconTheme: IconThemeData(size: 20, color: Colors.white),
        ),
        inputDecorationTheme: existingTheme.inputDecorationTheme.copyWith(
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.all(0),
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
