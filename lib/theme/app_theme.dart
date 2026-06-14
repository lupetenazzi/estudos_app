import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Cores principais
  static const primary = Color(0xFF6366F1);
  static const primaryForeground = Color(0xFFFFFFFF);

  // Fundo e superfícies
  static const background = Color(0xFFF5F4FF);
  static const surface = Color(0xFFFFFFFF);
  static const muted = Color(0xFFEEF0FF);

  // Textos
  static const foreground = Color(0xFF1E1B4B);
  static const mutedForeground = Color(0xFF8B8BAE);

  // Acento (laranja)
  static const accent = Color(0xFFF97316);
  static const accentForeground = Color(0xFFFFFFFF);

  // Secundário (laranja claro)
  static const secondary = Color(0xFFFFF4ED);
  static const secondaryForeground = Color(0xFFC2410C);

  // Estados
  static const destructive = Color(0xFFEF4444);
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFF59E0B);

  // Input
  static const inputBackground = Color(0xFFF0F0FF);
  static const border = Color(0x1F6366F1); // rgba(99,102,241,0.12)
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.accent,
        onSecondary: AppColors.accentForeground,
        error: AppColors.destructive,
        background: AppColors.background,
        surface: AppColors.surface,
        onBackground: AppColors.foreground,
        onSurface: AppColors.foreground,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.nunitoTextTheme().copyWith(
        headlineLarge: GoogleFonts.nunito(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        headlineMedium: GoogleFonts.nunito(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        headlineSmall: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
        bodyLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.foreground,
        ),
        bodyMedium: GoogleFonts.nunito(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.mutedForeground,
        ),
        labelLarge: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.foreground,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.foreground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }
}