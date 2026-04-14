// lib/services/app_theme.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const bg        = Color(0xFF0A0A0F);
  static const surface   = Color(0xFF13131A);
  static const surface2  = Color(0xFF1C1C28);
  static const border    = Color(0xFF1E1E2A);
  static const accent    = Color(0xFFE8FF47);
  static const accentDim = Color(0x1AE8FF47);
  static const accent2   = Color(0xFF47C8FF);
  static const red       = Color(0xFFFF5757);
  static const redDim    = Color(0x1AFF5757);
  static const textPrim  = Color(0xFFF0F0F0);
  static const textMuted = Color(0xFF666680);
  static const textMuted2= Color(0xFF888899);
}

ThemeData buildAppTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    colorScheme: const ColorScheme.dark(
      background: AppColors.bg,
      surface: AppColors.surface,
      primary: AppColors.accent,
      onPrimary: Colors.black,
    ),
    textTheme: GoogleFonts.dmSansTextTheme(
      const TextTheme(
        bodyLarge:   TextStyle(color: AppColors.textPrim),
        bodyMedium:  TextStyle(color: AppColors.textPrim),
        bodySmall:   TextStyle(color: AppColors.textMuted2),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
    ),
    dividerColor: AppColors.border,
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS:     CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
