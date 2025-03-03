
import 'package:flutter/material.dart';

import 'colors.dart';

final ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    primary: AppColors.colorPrimary,
    primaryContainer: const Color.fromRGBO(255, 255, 255, 1),
    onTertiaryContainer: AppColors.colorSeeAll,
    secondary: Colors.black,    ///black and white
    secondaryContainer: const Color.fromRGBO(242, 255, 249, 1),
    surface: Colors.grey.shade100,
    error: Colors.red,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: Colors.black87,
    surfaceBright: Colors.blue.shade100,
    onError: Colors.white,
    brightness: Brightness.light,
    onSurfaceVariant: Colors.white  ///bottom sheet bg color
  ),
);