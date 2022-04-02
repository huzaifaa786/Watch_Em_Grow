import 'package:flutter/material.dart';

class Styles {
  Styles._();

  // Colors
  static const Color kcPrimaryColor = Color(0xff828CFC);
  static const Color kcAppBarColor = Color(0xFF424242);

  // Themes

  static final ColorScheme _colorSchemelight =
      const ColorScheme.light().copyWith(
    primary: kcPrimaryColor,
    primaryVariant: kcPrimaryColor,
  );

  static final ColorScheme _colorSchemedark = const ColorScheme.dark().copyWith(
    primary: kcPrimaryColor,
    primaryVariant: kcPrimaryColor,
  );

  static final ThemeData lightTheme = ThemeData(
    colorScheme: _colorSchemelight,
    primaryColor: _colorSchemelight.primary,
    accentColor: _colorSchemelight.primary,
    fontFamily: "Default",
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _colorSchemelight.primary,
      selectionHandleColor: _colorSchemelight.primary,
    ),
    indicatorColor: _colorSchemelight.primary,
    toggleableActiveColor: _colorSchemelight.primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kcPrimaryColor),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: _colorSchemedark,
    primaryColor: _colorSchemedark.primary,
    accentColor: _colorSchemedark.primary,
    fontFamily: "Default",
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: _colorSchemedark.primary,
      selectionHandleColor: _colorSchemedark.primary,
    ),
    appBarTheme: const AppBarTheme(
      color: kcAppBarColor,
    ),
    indicatorColor: _colorSchemedark.primary,
    toggleableActiveColor: _colorSchemedark.primary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(kcPrimaryColor),
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(color: Colors.white),
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
    ),
  );
}
