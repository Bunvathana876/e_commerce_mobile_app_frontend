import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

/// Navigation item for AppBottomNavigation.
class AppNavItem {
  final IconData icon;
  final String label;

  const AppNavItem({required this.icon, required this.label});
}

/// App bottom navigation bar:
/// - Home, Categories, Deals, Cart, Profile
/// - Selected tab expands slightly and displays its label
/// - Cart shows an item count badge
/// - Smooth animated transitions (respecting AccessibilityFeatures.disableAnimations)
class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartCount;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartCount = 0,
  });

  static const List<AppNavItem> defaultItems = [
    AppNavItem(icon: LucideIcons.home, label: 'Home'),
    AppNavItem(icon: Icons.grid_view_rounded, label: 'Categories'),
    AppNavItem(icon: Icons.local_fire_department_rounded, label: 'Deals'),
    AppNavItem(icon: LucideIcons.shoppingBag, label: 'Cart'),
    AppNavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 10),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xEE1E293B)
              : Colors.white.withValues(alpha: 0.96),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : const Color(0xFFE2E8F0),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(defaultItems.length, (index) {
            final item = defaultItems[index];
            final isSelected = index == currentIndex;
            final isCart = item.label.toLowerCase() == 'cart';

            return Semantics(
              label: '${item.label} tab',
              selected: isSelected,
              button: true,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 16 : 10,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF2563EB)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon with possible Cart badge
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 20,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : const Color(0xFF64748B)),
                            ),
                            if (isCart && cartCount > 0)
                              Positioned(
                                top: -5,
                                right: -7,
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFFEF4444),
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: const BoxConstraints(
                                    minWidth: 15,
                                    minHeight: 15,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$cartCount',
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFF2563EB)
                                            : Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Animated label expansion
                        if (isSelected) ...[
                          const SizedBox(width: 6),
                          AnimatedOpacity(
                            duration: disableAnimations
                                ? Duration.zero
                                : const Duration(milliseconds: 200),
                            opacity: isSelected ? 1.0 : 0.0,
                            child: Text(
                              item.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

