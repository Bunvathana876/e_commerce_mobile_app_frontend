import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Clean rounded search bar with integrated filter button.
class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search clothes, shoes, bags...',
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 6.0),
      child: Row(
        children: [
          // Search Field
          Expanded(
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : const Color(0xFFE2E8F0),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: isDark
                        ? AppColors.darkTextMuted
                        : const Color(0xFF94A3B8),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : const Color(0xFF64748B),
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Filter Button
          InkWell(
            onTap: onFilterTap ?? () {},
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.32),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
