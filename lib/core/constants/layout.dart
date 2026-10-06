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
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 18.0;
  static const double xxl = 24.0;
  static const double full = 999.0;

  static final BorderRadius cardRadius = BorderRadius.circular(lg);
  static final BorderRadius buttonRadius = BorderRadius.circular(lg);
  static final BorderRadius pillRadius = BorderRadius.circular(full);
}
