import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../data/category_data.dart';

/// Clean card representing a department in the "Shop by category" grid,
/// matching the exact reference UI.
class CategoryGridCard extends StatelessWidget {
  final CategoryDetails category;
  final VoidCallback onTap;

  const CategoryGridCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shortTitle = category.title.split('&').first.trim();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top preview surface: Photographic image
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(19),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF8FAFC),
                    child: category.imageAsset != null
                        ? Image.asset(
                            category.imageAsset!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            errorBuilder: (_, _, _) => _buildFallback(isDark),
                          )
                        : _buildFallback(isDark),
                  ),
                ),
              ),

              // Bottom row with category title & subtle chevron
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shortTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(bool isDark) {
    return Container(
      color: category.accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
      child: Center(
        child: Icon(category.icon, color: category.accentColor, size: 32),
      ),
    );
  }
}
