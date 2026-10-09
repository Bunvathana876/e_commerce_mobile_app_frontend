import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../data/home_mock_data.dart';

/// Horizontal category selector bar with icons and highlighted active chip.
class HomeCategoriesBar extends StatelessWidget {
  final List<HomeCategory> categories;
  final String selectedCategoryId;
  final ValueChanged<String> onSelectCategory;

  const HomeCategoriesBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectCategory,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 44,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 9),
        itemBuilder: (context, index) {
          final cat = categories[index];
          final isSelected = cat.id == selectedCategoryId;

          return InkWell(
            onTap: () => onSelectCategory(cat.id),
            borderRadius: BorderRadius.circular(14),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.darkSurface : Colors.white),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0)),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.3)
                        : Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
                    blurRadius: isSelected ? 8 : 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    cat.icon,
                    size: 16.5,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    cat.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF334155)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
