import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Horizontal filter chips for categories:
/// - All, Women, Men, Kids, Home, Tech
/// - Selected chip uses royal blue background and white text.
class CategoryFilterChips extends StatelessWidget {
  final List<String> chips;
  final String selectedChip;
  final ValueChanged<String> onSelected;

  const CategoryFilterChips({
    super.key,
    this.chips = const ['All', 'Women', 'Men', 'Kids', 'Home', 'Tech'],
    required this.selectedChip,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 40,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: chips.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          final isSelected = chip.toLowerCase() == selectedChip.toLowerCase();

          return Semantics(
            label: '$chip category filter',
            selected: isSelected,
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onSelected(chip),
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2563EB)
                        : (isDark ? AppColors.darkSurface : Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : (isDark
                              ? AppColors.darkBorder
                              : const Color(0xFFE2E8F0)),
                      width: 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: isDark ? 0.15 : 0.02,
                              ),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      chip,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF475569)),
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
