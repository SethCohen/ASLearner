import 'package:flutter/material.dart';

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
    extensions: const <ThemeExtension<dynamic>>[
      CustomPalette(
        background: Color(0xFF4A5B6E),
        surface: Color(0xFF425366),
        selected: Color(0xFFF8CDC6),
        unselected: Color(0xFF9EC1CC),
        text: Color(0xFFF5EFEE),
        hover: Color(0xFFF5EFEE),
        error: Color(0xFFC9465E),
      ),
    ]);
