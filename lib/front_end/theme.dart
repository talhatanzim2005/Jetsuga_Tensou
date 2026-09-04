import 'package:flutter/material.dart';

/// Strictly enforced 8-Point Grid Spacing System.
abstract class AppSpacing {
  static const double xs = 8.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double lg = 32.0;
  static const double xl = 48.0;
  static const double xxl = 64.0;
}

/// Strictly enforced 8-Point Grid Border Radii.
abstract class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;
}

/// Major Third Typography System (1.25x Ratio Scale).
abstract class AppTypography {
  static const String fontFamily = 'Inter';

  static const TextStyle h1 = TextStyle(
    fontSize: 48.83,
    height: 1.1,
    letterSpacing: -1.0,
    fontWeight: FontWeight.bold,
    color: AppColors.contentText,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 39.06,
    height: 1.15,
    letterSpacing: -0.73,
    fontWeight: FontWeight.bold,
    color: AppColors.contentText,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 31.25,
    height: 1.2,
    letterSpacing: -0.5,
    fontWeight: FontWeight.w700,
    color: AppColors.contentText,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 25.00,
    height: 1.3,
    letterSpacing: -0.31,
    fontWeight: FontWeight.w600,
    color: AppColors.contentText,
  );

  static const TextStyle h5 = TextStyle(
    fontSize: 20.00,
    height: 1.35,
    letterSpacing: -0.13,
    fontWeight: FontWeight.w600,
    color: AppColors.contentText,
  );

  static const TextStyle h6 = TextStyle(
    fontSize: 16.00,
    height: 1.4,
    letterSpacing: -0.05,
    fontWeight: FontWeight.w600,
    color: AppColors.contentText,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14.00,
    height: 1.5,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
    color: AppColors.contentText,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.80,
    height: 1.5,
    letterSpacing: 0.0,
    fontWeight: FontWeight.w400,
    color: AppColors.contentTextMuted,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11.0,
    height: 1.4,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w600,
    color: AppColors.contentTextMuted,
  );

  static const TextStyle tableHeader = TextStyle(
    fontSize: 11.0,
    height: 1.4,
    letterSpacing: 1.2,
    fontWeight: FontWeight.w600,
    color: AppColors.contentTextMuted,
  );
}

/// Dual-Tone Color Palette — Dark Sidebar + Warm Cream Content.
/// Based on video reference design.
abstract class AppColors {
  // ─── Sidebar (Dark Navy) ───
  static const Color sidebarBg = Color(0xFF1B1E2E);
  static const Color sidebarSurface = Color(0xFF252838);
  static const Color sidebarText = Color(0xFFCBCED8);
  static const Color sidebarTextMuted = Color(0xFF6B7089);
  static const Color sidebarActiveText = Color(0xFFFFFFFF);
  static const Color sidebarDivider = Color(0xFF2E3144);

  // ─── Content Area (Warm Cream) ───
  static const Color contentBg = Color(0xFFF4F1EA);
  static const Color contentSurface = Color(0xFFFFFFFF);
  static const Color contentText = Color(0xFF1A1A2E);
  static const Color contentTextMuted = Color(0xFF6B7280);
  static const Color contentDivider = Color(0xFFE5E1D8);

  // ─── Top Bar ───
  static const Color topBarBg = Color(0xFFFAF8F4);
  static const Color topBarBorder = Color(0xFFE8E4DC);

  // ─── Accent (Warm Gold) — 10% focal points ───
  static const Color accent = Color(0xFFE8C858);
  static const Color accentDark = Color(0xFFD4AE38);
  static const Color accentBg = Color(0xFFFDF6E3);
  static const Color accentText = Color(0xFF1A1A2E);

  // ─── Table ───
  static const Color tableHeaderBg = Color(0xFFF0EDE6);
  static const Color tableRowBorder = Color(0xFFE8E4DC);
  static const Color tableRowHover = Color(0xFFEDEAE3);

  // ─── Status Badges ───
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);

  // ─── Stat Cards ───
  static const Color statGold = Color(0xFFFDF6E3);
  static const Color statCoral = Color(0xFFFEE2E2);
  static const Color statTeal = Color(0xFFE0F2FE);
  static const Color statDark = Color(0xFF1E293B);

  // ─── General ───
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color onlineGreen = Color(0xFF22C55E);

  // Legacy compat aliases
  static const Color primary = accent;
  static const Color background = contentBg;
  static const Color surface = contentSurface;
  static const Color textPrimary = contentText;
  static const Color textSecondary = contentTextMuted;
  static const Color secondary = sidebarBg;
  static const Color onPrimary = accentText;
}

/// Global Application Theme Definition.
abstract class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.contentBg,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.sidebarBg,
        surface: AppColors.contentSurface,
        onPrimary: AppColors.accentText,
        onSecondary: AppColors.sidebarText,
        onSurface: AppColors.contentText,
        error: AppColors.error,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        headlineLarge: AppTypography.h2,
        headlineMedium: AppTypography.h3,
        headlineSmall: AppTypography.h4,
        titleLarge: AppTypography.h5,
        titleMedium: AppTypography.h6,
        bodyLarge: AppTypography.body,
        bodySmall: AppTypography.bodySmall,
      ),
      cardTheme: CardThemeData(
        color: AppColors.contentSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: const BorderSide(color: AppColors.contentDivider, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.contentSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.contentDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.contentDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        hintStyle: AppTypography.body.copyWith(color: AppColors.contentTextMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.contentDivider,
        thickness: 1,
      ),
    );
  }

  /// Keep a dark theme getter for backwards compat (redirects to light).
  static ThemeData get darkTheme => lightTheme;
}
