import 'package:flutter/material.dart';

/// The palette: ink on warm paper, as a printed anthology, with one accent, the oxblood of
/// a cloth binding, for what is playing and what is chosen.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.paper,
    required this.surface,
    required this.ink,
    required this.inkMuted,
    required this.accent,
    required this.accentWash,
    required this.hairline,
  });

  static const light = AppColors(
    paper: Color(0xFFF5F0E6),
    surface: Color(0xFFFBF8F2),
    ink: Color(0xFF1F1B16),
    inkMuted: Color(0xFF6B6257),
    accent: Color(0xFF7A2E2E),
    accentWash: Color(0xFFF1E3DF),
    hairline: Color(0xFFE2D9C8),
  );

  /// The page behind everything.
  final Color paper;

  /// Bars and cards, a shade lighter than the page.
  final Color surface;
  final Color ink;
  final Color inkMuted;
  final Color accent;

  /// Behind what is selected or playing.
  final Color accentWash;
  final Color hairline;

  @override
  AppColors copyWith({
    Color? paper,
    Color? surface,
    Color? ink,
    Color? inkMuted,
    Color? accent,
    Color? accentWash,
    Color? hairline,
  }) => AppColors(
    paper: paper ?? this.paper,
    surface: surface ?? this.surface,
    ink: ink ?? this.ink,
    inkMuted: inkMuted ?? this.inkMuted,
    accent: accent ?? this.accent,
    accentWash: accentWash ?? this.accentWash,
    hairline: hairline ?? this.hairline,
  );

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other == null) return this;
    return AppColors(
      paper: Color.lerp(paper, other.paper, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentWash: Color.lerp(accentWash, other.accentWash, t)!,
      hairline: Color.lerp(hairline, other.hairline, t)!,
    );
  }
}

/// One spacing scale, in logical pixels.
@immutable
class Spacing {
  const Spacing();

  double get xs => 4;
  double get sm => 8;
  double get md => 12;

  /// The gutter at a page's sides.
  double get page => 16;
  double get lg => 24;
  double get xl => 32;
  double get xxl => 48;
}
