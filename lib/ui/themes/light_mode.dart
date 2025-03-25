
import 'package:flutter/material.dart';
import 'colors.dart';

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.colorPrimary,
    primaryContainer: const Color.fromRGBO(255, 255, 255, 1),
    onTertiaryContainer: AppColors.colorSeeAll,
    onPrimaryContainer: const Color.fromRGBO(224, 234, 229, 1.0),  /// dropdown color
    secondary: Colors.black,    ///black and white
    secondaryContainer: const Color.fromRGBO(244, 246, 245, 1.0),
    surface: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.white, /// table card
    tertiary: AppColors.colorPrimary, /// price color in card
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    surfaceBright: Colors.grey.shade600,  /// hint text color
    onError: Colors.white,
    brightness: Brightness.light,
    onSurfaceVariant: Colors.white  ///bottom sheet bg color
  ),
);