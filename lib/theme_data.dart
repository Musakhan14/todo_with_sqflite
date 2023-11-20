import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0xff1E3C64),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      textStyle: const TextStyle(
        color: Color(0xff1E3C64),
      ),
      foregroundColor: const Color(0xff1E3C64),
      side: const BorderSide(
        color: Color(0xff1E3C64),
        width: 1.7,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: const TextStyle(fontWeight: FontWeight.bold),
    border: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    errorBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    suffixIconColor: Colors.grey,
    prefixIconColor: Colors.grey,
    disabledBorder: outlineInputBorder,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xff1E3C64),
      textStyle: const TextStyle(
        fontSize: 18,
      ),
      disabledBackgroundColor: Colors.grey,
    ),
  ),
  // primarySwatch:  Color(0xff1E3C64),
  canvasColor: const Color(0xff1E3C64),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xff1E3C64),
    toolbarTextStyle: TextStyle(
      color: Colors.black,
    ),
    elevation: 0.0,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
);
OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xff1E3C64),
  ),
);
