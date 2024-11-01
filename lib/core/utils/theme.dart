import 'package:flutter/material.dart';
import 'package:lms/constants.dart';

ThemeData getDarkTheme() {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.black,
    hintColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: kPrimaryColor),

    // Button styles
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(kPrimaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(const BorderSide(color: kPrimaryColor)),
        foregroundColor: WidgetStateProperty.all(kPrimaryColor),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.white))),
    // TextField styles
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.white),
      hintStyle: TextStyle(color: Colors.white),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),

    // Progress indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),

    // ListTile styles
    listTileTheme: const ListTileThemeData(
      selectedColor: kPrimaryColor,
      selectedTileColor: Colors.black54,
      iconColor: Colors.white,
      textColor: Colors.white,
    ),

    // Radio button and Checkbox themes
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(kPrimaryColor),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(kPrimaryColor),
      checkColor: WidgetStateProperty.all(Colors.white),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      foregroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.white),
    ),
  );
}

ThemeData getLightTheme() {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: Colors.white,
    hintColor: Colors.black,
    iconTheme: const IconThemeData(color: Colors.black),
    textSelectionTheme:
        const TextSelectionThemeData(selectionColor: kPrimaryColor),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(iconColor: WidgetStateProperty.all(Colors.black))),
    // Button styles
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(kPrimaryColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        side: WidgetStateProperty.all(const BorderSide(color: kPrimaryColor)),
        foregroundColor: WidgetStateProperty.all(kPrimaryColor),
      ),
    ),

    // TextField styles
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(color: Colors.black),
      hintStyle: TextStyle(color: Colors.black),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: kPrimaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),

    // Progress indicators
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Colors.white,
    ),

    // ListTile styles
    listTileTheme: ListTileThemeData(
      selectedColor: kPrimaryColor,
      selectedTileColor: Colors.grey[200],
      iconColor: Colors.black,
      textColor: Colors.black,
    ),

    // Radio button and Checkbox themes
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(kPrimaryColor),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all(kPrimaryColor),
      checkColor: WidgetStateProperty.all(Colors.black),
    ),

    // AppBar theme
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      foregroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}
