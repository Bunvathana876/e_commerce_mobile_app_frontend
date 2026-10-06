import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';
import '../../../widgets/custom_floating_nav_bar.dart';

/// Home screen bottom navigation using the glassmorphic floating pill bar.
class HomeBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Color? shellColor;
  final Color? activeColor;

  const HomeBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.shellColor,
    this.activeColor,
  });

  static const List<FloatingNavItem> items = [
    FloatingNavItem(icon: LucideIcons.home, label: 'Home'),
    FloatingNavItem(icon: Icons.grid_view_rounded, label: 'Categories'),
    FloatingNavItem(icon: Icons.local_fire_department_rounded, label: 'Deals'),
    FloatingNavItem(icon: LucideIcons.heart, label: 'Wishlist'),
    FloatingNavItem(icon: LucideIcons.shoppingBag, label: 'Cart'),
    FloatingNavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Align(
          heightFactor: 1,
          child: CustomFloatingNavBar(
            items: items,
            scale:
                1.0, // Tuned scale so all 6 tabs fit comfortably without overflow
            shellColor:
                shellColor ??
                (isDark
                    ? const Color(0x660F172A)
                    : Colors.white.withValues(alpha: 0.35)),
            activeColor: activeColor ?? AppColors.primary,
            initialIndex: currentIndex,
            onItemSelected: onTap,
          ),
        ),
      ),
    );
  }
}
