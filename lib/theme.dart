import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

extension AppThemeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get bgColor => isDark ? AppTheme.backgroundDark : AppTheme.backgroundLight;
  Color get surfaceColor => isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight;

  Color get textMain => isDark ? Colors.white : Colors.black87;
  Color get textSec => isDark ? Colors.white54 : Colors.black54;
  Color get textTertiary => isDark ? Colors.white38 : Colors.black38;
  Color get textFaded => isDark ? Colors.white24 : Colors.black26;
  Color get borderFaded => isDark ? Colors.white12 : Colors.black12;
  
  Color get cardColor => isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);
}

class AppTheme {
  static final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.dark);

  static void toggleTheme() {
    themeNotifier.value = themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
  static const Color primary = Color(0xFFEF4444);
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Colors.white;
  static const Color surfaceDark = Color(0xFF1E293B);
  
  static const Color textMainLight = Color(0xFF0F172A);
  static const Color textMainDark = Color(0xFFF8FAFC);
  static const Color textSecondaryLight = Color(0xFF64748B);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);


  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: surfaceLight,
      ),
      textTheme: GoogleFonts.outfitTextTheme().apply(
        bodyColor: textMainLight,
        displayColor: textMainLight,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        surface: surfaceDark,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: textMainDark,
        displayColor: textMainDark,
      ),
    );
  }
}
