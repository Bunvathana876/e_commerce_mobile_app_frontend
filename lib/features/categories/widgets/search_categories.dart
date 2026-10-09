import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

/// Clean rounded search bar for categories and products.
/// - Search icon
/// - Placeholder: “Search categories or products”
/// - Clear button when text is entered
class SearchCategories extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const SearchCategories({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasText = controller.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.darkTextPrimary : const Color(0xFF0F172A),
          ),
          decoration: InputDecoration(
            hintText: 'Search categories or products',
            hintStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF94A3B8),
            ),
            prefixIcon: Icon(
              LucideIcons.search,
              size: 19,
              color: isDark ? AppColors.darkTextMuted : const Color(0xFF64748B),
            ),
            suffixIcon: hasText
                ? Semantics(
                    label: 'Clear search text',
                    button: true,
                    child: IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      tooltip: 'Clear',
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : const Color(0xFF64748B),
                      onPressed: onClear,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ),
    );
  }
}

