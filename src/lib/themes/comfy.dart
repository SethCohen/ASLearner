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
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Color(0xFFF8CDC6),
    unselectedLabelColor: Color(0xFF9EC1CC),
    indicator: BoxDecoration(),
    splashFactory: NoSplash.splashFactory,
  ),
  cardTheme: const CardTheme(
      elevation: 0,
      color: Color(0xFF425366),
      surfaceTintColor: Colors.transparent),
);