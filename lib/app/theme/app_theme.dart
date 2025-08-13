import 'package:flutter/material.dart';
import '../../core/utils/responsive_utils.dart';

/// All reusable colors used across the app
class AppColors {
  // Background
  static const Color background = Color(0xFF161825); // Screen background
  static const Color surface = Color(0xFF1E1F2E); // Card backgrounds
  static const Color surfaceVariant = Color(0xFF2A2B3A); // Elevated surfaces

  // Primary Colors
  static const Color primary = Color(0xFF3E4464); // AppBar, main UI elements
  static const Color secondary = Color(0xFF3B3C50); // Cards, tabs, etc.
  static const Color tertiary = Color(0xFF4A4D6A); // Tertiary elements

  // Call-To-Action (CTA) Buttons
  static const Color primaryCTA = Color(0xFF3CC45B); // Green button (main)
  static const Color secondaryCTA = Color(0xFFF0BF44); // Yellow button (secondary)
  static const Color accent = Color(0xFF6C63FF); // Accent color

  // Text Colors
  static const Color textLight = Colors.white; // Use on dark backgrounds
  static const Color textDark = Colors.black; // Use on light (yellow) backgrounds
  static const Color textSecondary = Color(0xFFB0B0B0); // Secondary text
  static const Color textTertiary = Color(0xFF808080); // Tertiary text

  // Status Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Enhanced Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF3CC45B), Color(0xFF2E9D47)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFF0BF44), Color(0xFFE6A800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF161825), Color(0xFF1E1F2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // New Modern Gradients
  static const LinearGradient calmGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient focusGradient = LinearGradient(
    colors: [Color(0xFFf093fb), Color(0xFFf5576c)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient gratitudeGradient = LinearGradient(
    colors: [Color(0xFF4facfe), Color(0xFF00f2fe)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x1AFFFFFF), Color(0x0AFFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism Colors
  static const Color glassPrimary = Color(0x1AFFFFFF);
  static const Color glassSecondary = Color(0x0AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);

  // Mood Colors
  static const Color calmMood = Color(0xFF667eea);
  static const Color focusedMood = Color(0xFFf093fb);
  static const Color gratefulMood = Color(0xFF4facfe);
  static const Color anxiousMood = Color(0xFFf5576c);
  static const Color distractedMood = Color(0xFF9CA3AF);
  static const Color tiredMood = Color(0xFF8B5CF6);
}

/// Design tokens for consistent spacing and sizing
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Typography system with responsive sizing
class AppTypography {
  static TextStyle displayLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 32.0),
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 28.0),
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 24.0),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
  }

  static TextStyle headlineLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 22.0),
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 20.0),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 18.0),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );
  }

  static TextStyle titleLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12.0),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    );
  }

  static TextStyle bodyLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 16.0),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.25,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12.0),
      fontWeight: FontWeight.w400,
      letterSpacing: 0.4,
    );
  }

  static TextStyle labelLarge(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 14.0),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 12.0),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return TextStyle(
      fontSize: ResponsiveUtils.getResponsiveFontSize(context, 10.0),
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    );
  }
}

/// App theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
    useMaterial3: true,
      brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryCTA,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryCTA,
        secondary: AppColors.secondaryCTA,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
      ),
    appBarTheme: const AppBarTheme(
      surfaceTintColor: AppColors.primary,
      foregroundColor: AppColors.textLight,
      elevation: 0,
        centerTitle: true,
      ),
             cardTheme: CardThemeData(
         color: AppColors.surface,
         elevation: 4,
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(16),
         ),
       ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryCTA,
        foregroundColor: AppColors.textLight,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryCTA),
      ),
    ),
  );
  }
}
