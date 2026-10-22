import 'package:flutter/material.dart';
import 'package:recital/core/theme/app_colors.dart';

/// The theme's parts, reached from a widget's context.
extension ThemeContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  Spacing get spacing => const Spacing();
  TextTheme get text => Theme.of(this).textTheme;
}
