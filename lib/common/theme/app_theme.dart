import 'package:flutter/material.dart';

class AppTheme {
  //define app colors here
  static const Color primaryColor = Color(0xFFFFD550);
  static const Color textfieldErrorColor = Color(0xFFF95454);
  //dark theme
  static final darkTheme = ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
    ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800], // Set the background color to a dark color
        // You can customize other properties of the Snackbar here
      ),
    useMaterial3: true,
    fontFamily: "SegoeUI",
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF212121),
    )
  );
}
