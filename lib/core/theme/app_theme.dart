import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

/// 2025-2026 Trendy Color Palette
/// Inspired by: Electric Bioluminescence, Cosmic Blue, Deep Teal, Thermal Glow
class AppColors {
  // === Primary: Deep Teal (2026 Trend - Tech + Nature) ===
  static const primary = Color(0xFF1E6F6B); // Transformative Teal
  static const primaryLight = Color(0xFF3DDAD4); // Neon Aqua accent
  static const primaryDark = Color(0xFF0A4A47); // Deep Ocean

  // === Secondary: Cosmic Blue (Premium Tech Feel) ===
  static const secondary = Color(0xFF1E3A8A); // Cosmic Blue
  static const secondaryLight = Color(0xFF60A5FA); // Electric Blue
  static const secondaryDark = Color(0xFF0F172A); // Space Black

  // === Accent: Electric Bioluminescence ===
  static const accent = Color(0xFFD946EF); // Hyper Violet
  static const accentAlt = Color(0xFF22D3EE); // Cyan Glow
  static const accentWarm = Color(0xFFF97316); // Thermal Orange

  // === Dark Theme (Sophisticated, not pure black) ===
  static const backgroundDark = Color(0xFF0A0F14); // Deep Space
  static const surfaceDark = Color(0xFF111827); // Soft Dark Gray
  static const cardDark = Color(0xFF1F2937); // Elevated Surface
  static const borderDark = Color(0xFF374151); // Subtle Border
  static const elevatedDark = Color(0xFF2D3748); // Modal/Overlay

  // === Light Theme (Minimal, Clean) ===
  static const backgroundLight = Color(0xFFF8FAFC);
  static const surfaceLight = Color(0xFFFFFFFF);
  static const cardLight = Color(0xFFFFFFFF);
  static const borderLight = Color(0xFFE2E8F0);

  // === Text Colors ===
  static const textPrimaryDark = Color(0xFFF1F5F9);
  static const textSecondaryDark = Color(0xFF94A3B8);
  static const textMutedDark = Color(0xFF64748B);
  static const textPrimaryLight = Color(0xFF0F172A);
  static const textSecondaryLight = Color(0xFF475569);

  // === Status Colors (Vibrant, Modern) ===
  static const success = Color(0xFF10B981); // Emerald
  static const warning = Color(0xFFF59E0B); // Amber
  static const error = Color(0xFFEF4444); // Rose Red
  static const info = Color(0xFF3B82F6); // Blue

  // === Feature Colors (App-specific) ===
  static const mealColor = Color(0xFFA855F7); // Purple Glow
  static const bazarColor = Color(0xFF06B6D4); // Cyan
  static const moneyPositive = Color(0xFF10B981); // Emerald
  static const moneyNegative = Color(0xFFF43F5E); // Rose

  // === Gradient Presets (Mesh/Aurora Effect) ===
  static const gradientPrimary = [
    Color(0xFF1E6F6B),
    Color(0xFF0EA5E9),
    Color(0xFF3DDAD4),
  ];

  static const gradientCosmic = [
    Color(0xFF1E3A8A),
    Color(0xFF6366F1),
    Color(0xFFD946EF),
  ];

  static const gradientThermal = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
    Color(0xFFFBBF24),
  ];
}

/// Spacing Tokens (Using 4px grid system)
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // Border Radius (Softer, more modern)
  static const double radiusXs = 6.0;
  static const double radiusSm = 10.0;
  static const double radiusMd = 14.0;
  static const double radiusLg = 20.0;
  static const double radiusXl = 28.0;
  static const double radiusFull = 9999.0;

  // Elevation shadows
  static List<BoxShadow> get shadowSm => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get shadowMd => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get glowPrimary => [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.4),
      blurRadius: 20,
      spreadRadius: -4,
    ),
  ];
}

/// Typography System (2025-2026 Trending Fonts)
/// Using: Plus Jakarta Sans (headings) + Inter (body)
class AppTypography {
  // Display - Bold Impact
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.0,
    height: 1.1,
  );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
    fontSize: 30,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle get displaySmall => GoogleFonts.plusJakartaSans(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    height: 1.2,
  );

  // Headlines
  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
  );

  static TextStyle get headlineMedium =>
      GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get headlineSmall =>
      GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w600);

  // Titles
  static TextStyle get titleLarge =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600);

  static TextStyle get titleMedium =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w500);

  static TextStyle get titleSmall =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500);

  // Body Text
  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.6);

  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5);

  static TextStyle get bodySmall =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, height: 1.5);

  // Labels
  static TextStyle get labelLarge => GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.2,
  );

  static TextStyle get labelSmall => GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Mono (for numbers, code)
  static TextStyle get mono =>
      GoogleFonts.jetBrainsMono(fontSize: 14, fontWeight: FontWeight.w500);

  static TextStyle get monoLarge =>
      GoogleFonts.jetBrainsMono(fontSize: 28, fontWeight: FontWeight.w700);
}

/// App Theme Configuration
class AppTheme {
  static ThemeData get darkTheme {
    final base = FlexThemeData.dark(
      scheme: FlexScheme.aquaBlue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.accent,
        secondaryContainer: AppColors.secondary,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimaryDark,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.5)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMedium.copyWith(color: AppColors.primary);
          }
          return AppTypography.labelMedium.copyWith(
            color: AppColors.textSecondaryDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(
            color: AppColors.textSecondaryDark,
            size: 24,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: BorderSide(
            color: AppColors.borderDark.withValues(alpha: 0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm + 4,
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textMutedDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardDark,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        side: BorderSide(color: AppColors.borderDark.withValues(alpha: 0.5)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.borderDark.withValues(alpha: 0.5),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = FlexThemeData.light(
      scheme: FlexScheme.aquaBlue,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 7,
      useMaterial3: true,
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.primary,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimaryLight,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.headlineLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryLight),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
