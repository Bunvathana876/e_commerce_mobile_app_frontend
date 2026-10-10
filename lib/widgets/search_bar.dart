import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Search input field with placeholder and a filter button directly beside it.
class CustomSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final String hintText;

  const CustomSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onFilterTap,
    this.hintText = 'Search clothes, shoes, bags...',
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          // Search text field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.getCardBackground(context),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(color: AppTheme.getBorder(context), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                style: TextStyle(
                  fontSize: 13.5,
                  color: AppTheme.getTextPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: AppTheme.getTextMuted(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppTheme.getTextSecondary(context),
                    size: 21,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Filter Button directly beside it
          Semantics(
            label: 'Filter and sort options',
            button: true,
            child: Tooltip(
              message: 'Filter products',
              child: InkWell(
                onTap: onFilterTap ?? () {},
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
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
            ),
          ),
        ],
      ),
    );
  }
}
