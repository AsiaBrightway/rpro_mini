
import 'package:flutter/material.dart';

final ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: const Color.fromRGBO(113, 63, 198, 1.0),
    primaryContainer: const Color.fromRGBO(9, 7, 44, 1),
    onTertiaryContainer: Colors.white,
    secondary: Colors.white,
    secondaryContainer: const Color.fromRGBO(242, 255, 249, 1),
    surface: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: const Color.fromRGBO(230, 228, 228, 1.0),
    surfaceBright: Colors.blue.shade100,
    onError: Colors.white,
    brightness: Brightness.light,
      onSurfaceVariant: const Color.fromRGBO(202, 201, 201, 1.0) ///bottom sheet bg color
  ),
);