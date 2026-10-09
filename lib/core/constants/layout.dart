import 'package:flutter/material.dart';

/// Layout geometry constants for ShopPanda.
/// Use these constants to keep padding, margins, and borders consistent across all screens.
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(16.0);
  static const EdgeInsets itemPadding = EdgeInsets.all(12.0);

  // Semantic spacing
  static const double elementGap = sm;
  static const double cardGap = md;
  static const double sectionGap = xxl;
}

class AppRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 18.0;
  static const double xxl = 24.0;
  static const double full = 999.0;

  static final BorderRadius inputRadius = BorderRadius.circular(md);
  static final BorderRadius cardRadius = BorderRadius.circular(lg);
  static final BorderRadius buttonRadius = BorderRadius.circular(lg);
  static final BorderRadius sheetRadius = BorderRadius.vertical(
    top: Radius.circular(xxl),
  );
  static final BorderRadius pillRadius = BorderRadius.circular(full);
}

/// Elevation and ambient shadow tokens for commercial tactile depth.
class AppShadows {
  AppShadows._();

  static List<BoxShadow> subtle({bool isDark = false}) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.20 : 0.03),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> card({bool isDark = false}) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.04),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> floating({bool isDark = false}) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: isDark ? 0.40 : 0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> primaryGlow(Color primaryColor) => [
    BoxShadow(
      color: primaryColor.withValues(alpha: 0.28),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}
