import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData build() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
      scaffoldBackgroundColor: const Color(0xFFF5F7F4),
    );
  }
}
