import 'package:flutter/material.dart';

// Palette: https://coolors.co/4a5b6e-425366-f8cdc6-9ec1cc-f5efee
// background: Color(0xFF4A5B6E)
// surface: Color(0xFF425366)
// selected: Color(0xFFF8CDC6)
// unselected: Color(0xFF9EC1CC)
// text/hover: Color(0xFFF5EFEE)
// error: Color(0xFFC9465E)

final comfyTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFF8CDC6),
    background: const Color(0xFF4A5B6E),
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Color(0xFF9EC1CC),
    titleTextStyle: TextStyle(
      color: Color(0xFFF5EFEE),
      fontSize: 22,
      fontWeight: FontWeight.w500,
    ),
  ),
  tabBarTheme: TabBarTheme(
    labelColor: const Color(0xFFF8CDC6),
    unselectedLabelColor: const Color(0xFF9EC1CC),
    indicator: const BoxDecoration(),
    splashFactory: NoSplash.splashFactory,
    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
  ),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor:
          MaterialStateProperty.all<Color>(const Color(0xFFF8CDC6)),
      overlayColor: MaterialStateProperty.all<Color>(const Color(0xFF425366)),
    ),
  ),
  cardTheme: const CardTheme(
      elevation: 0,
      color: Color(0xFF425366),
      surfaceTintColor: Colors.transparent),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Color(0xFFF8CDC6),
    linearTrackColor: Color(0xFF4A5B6E),
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Color(0xFFF5EFEE)),
    displayMedium: TextStyle(color: Color(0xFFF5EFEE)),
    displaySmall: TextStyle(color: Color(0xFFF5EFEE)),
    headlineLarge: TextStyle(color: Color(0xFFF5EFEE)),
    headlineMedium: TextStyle(color: Color(0xFFF5EFEE)),
    headlineSmall: TextStyle(color: Color(0xFFF5EFEE)),
    titleLarge: TextStyle(color: Color(0xFFF5EFEE)),
    titleMedium: TextStyle(color: Color(0xFFF5EFEE)),
    titleSmall: TextStyle(color: Color(0xFFF5EFEE)),
    labelLarge: TextStyle(color: Color(0xFFF5EFEE)),
    labelMedium: TextStyle(color: Color(0xFFF5EFEE)),
    labelSmall: TextStyle(color: Color(0xFFF5EFEE)),
    bodyLarge: TextStyle(color: Color(0xFFF5EFEE)),
    bodyMedium: TextStyle(color: Color(0xFFF5EFEE)),
    bodySmall: TextStyle(color: Color(0xFFF5EFEE)),
  ),
);
