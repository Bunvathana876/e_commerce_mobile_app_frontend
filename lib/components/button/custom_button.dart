import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Reusable primary elevated button for ShopPanda.
class CustomPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double height;
  final Color? backgroundColor;

  const CustomPrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.height = 52.0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBg = backgroundColor ?? AppColors.primary;

    return SizedBox(
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectiveBg,
          foregroundColor: Colors.white,
          disabledBackgroundColor: effectiveBg.withValues(alpha: 0.55),
          disabledForegroundColor: Colors.white.withValues(alpha: 0.8),
          minimumSize: Size.fromHeight(height),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: const TextStyle(
            fontSize: 15.5,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 19),
                    const SizedBox(width: 8),
                  ],
                  Text(text),
                ],
              ),
      ),
    );
  }
}

/// Reusable secondary outlined button for ShopPanda.
class CustomSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final double height;

  const CustomSecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark
              ? AppColors.darkTextPrimary
              : AppColors.textPrimary,
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 19),
              const SizedBox(width: 8),
            ],
            Text(text),
          ],
        ),
      ),
    );
  }
}
