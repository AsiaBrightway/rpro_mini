import 'package:flutter/material.dart';

Color parseColor(String hexCode) {
  try {
    hexCode = hexCode.replaceAll("#", ""); // Remove # if present
    if (hexCode.length == 6) {
      return Color(int.parse("0xFF$hexCode"));
    }
  } catch (e) {
    return Colors.grey; // Default color if invalid
  }
  return Colors.grey;
}