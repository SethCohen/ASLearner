import 'package:flutter/material.dart';

// CONSTANTS
const Color background = Color(0xFF4A5B6E);
const Color surface = Color(0xFF425366);
const Color selected = Color(0xFFF8CDC6);
const Color unselected = Color(0xFF9EC1CC);
const Color text = Color(0xFFF5EFEE);
const Color hover = Color(0xFFF5EFEE);
const Color error = Color(0xFFC9465E);

@immutable
class CustomPalette extends ThemeExtension<CustomPalette> {
  const CustomPalette({
    required this.background,
    required this.surface,
    required this.selected,
    required this.unselected,
    required this.text,
    required this.hover,
    required this.error,
  });

  final Color? background;
  final Color? surface;
  final Color? selected;
  final Color? unselected;
  final Color? text;
  final Color? hover;
  final Color? error;

  @override
  CustomPalette copyWith(
      {Color? background,
      Color? surface,
      Color? selected,
      Color? unselected,
      Color? text,
      Color? hover,
      Color? error}) {
    return CustomPalette(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      selected: selected ?? this.selected,
      unselected: unselected ?? this.unselected,
      text: text ?? this.text,
      hover: hover ?? this.hover,
      error: error ?? this.error,
    );
  }

  @override
  CustomPalette lerp(CustomPalette? other, double t) {
    if (other is! CustomPalette) {
      return this;
    }
    return CustomPalette(
      background: Color.lerp(background, other.background, t),
      surface: Color.lerp(surface, other.surface, t),
      selected: Color.lerp(selected, other.selected, t),
      unselected: Color.lerp(unselected, other.unselected, t),
      text: Color.lerp(text, other.text, t),
      hover: Color.lerp(hover, other.hover, t),
      error: Color.lerp(error, other.error, t),
    );
  }
}

final comfyTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: selected,
      background: background,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: unselected,
      titleTextStyle: TextStyle(
        color: text,
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
    ),
    tabBarTheme: TabBarTheme(
      labelColor: selected,
      unselectedLabelColor: unselected,
      indicator: const BoxDecoration(),
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(selected),
        overlayColor: MaterialStateProperty.all<Color>(surface),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return hover;
            } else if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.focused) ||
                states.contains(MaterialState.selected)) {
              return selected;
            } else {
              return unselected;
            }
          },
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return surface;
            } else if (states.contains(MaterialState.pressed) ||
                states.contains(MaterialState.focused) ||
                states.contains(MaterialState.selected)) {
              return surface;
            } else {
              return text;
            }
          },
        ),
      ),
    ),
    cardTheme: const CardTheme(
        elevation: 0, color: surface, surfaceTintColor: Colors.transparent),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: selected,
      linearTrackColor: background,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: text),
      displayMedium: TextStyle(color: text),
      displaySmall: TextStyle(color: text),
      headlineLarge: TextStyle(color: text),
      headlineMedium: TextStyle(color: text),
      headlineSmall: TextStyle(color: text),
      titleLarge: TextStyle(color: text),
      titleMedium: TextStyle(color: text),
      titleSmall: TextStyle(color: text),
      labelLarge: TextStyle(color: text),
      labelMedium: TextStyle(color: text),
      labelSmall: TextStyle(color: text),
      bodyLarge: TextStyle(color: text),
      bodyMedium: TextStyle(color: text),
      bodySmall: TextStyle(color: text),
    ),
    extensions: const <ThemeExtension<dynamic>>[
      CustomPalette(
        background: background,
        surface: surface,
        selected: selected,
        unselected: unselected,
        text: text,
        hover: hover,
        error: error,
      ),
    ]);
