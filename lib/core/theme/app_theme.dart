import 'package:flutter/material.dart';
import 'package:recital/core/theme/app_colors.dart';

/// The serif the poems are set in: New York on iOS, the platform serif elsewhere.
const poemFontFamily = '.New York';
const poemFontFallback = ['Georgia', 'serif'];

ThemeData buildAppTheme() {
  const colors = AppColors.light;
  final base = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: colors.accent,
      surface: colors.surface,
      primary: colors.accent,
      onSurface: colors.ink,
    ),
    scaffoldBackgroundColor: colors.paper,
    extensions: const [colors],
  );
  // A type scale of five steps; titles in the poems' serif, the interface in the
  // platform's sans.
  final text = base.textTheme
      .copyWith(
        headlineSmall: const TextStyle(
          fontFamily: poemFontFamily,
          fontFamilyFallback: poemFontFallback,
          fontSize: 26,
          height: 1.2,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: const TextStyle(
          fontFamily: poemFontFamily,
          fontFamilyFallback: poemFontFallback,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(fontSize: 16, height: 1.4),
        bodyMedium: const TextStyle(fontSize: 14, height: 1.4),
        labelMedium: const TextStyle(fontSize: 12, letterSpacing: 0.2),
      )
      .apply(bodyColor: colors.ink, displayColor: colors.ink);
  return base.copyWith(
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: colors.paper,
      foregroundColor: colors.ink,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge,
    ),
    dividerTheme: DividerThemeData(color: colors.hairline, space: 1),
    listTileTheme: ListTileThemeData(iconColor: colors.inkMuted),
  );
}

/// How a poem's lines are set.
TextStyle poemTextStyle(BuildContext context) => TextStyle(
  fontFamily: poemFontFamily,
  fontFamilyFallback: poemFontFallback,
  fontSize: 19,
  height: 1.55,
  color: Theme.of(context).extension<AppColors>()!.ink,
);
