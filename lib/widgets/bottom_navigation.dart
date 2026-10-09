import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../theme/app_theme.dart';

/// Navigation item definition for BottomNavigation.
class BottomNavItem {
  final IconData icon;
  final String label;

  const BottomNavItem({required this.icon, required this.label});
}

/// Fixed bottom navigation bar safe-area aware using SafeArea:
/// Tabs: Home, Categories, Deals, Favorites, Profile.
class BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<BottomNavItem> items = [
    BottomNavItem(icon: LucideIcons.home, label: 'Home'),
    BottomNavItem(icon: Icons.grid_view_rounded, label: 'Categories'),
    BottomNavItem(icon: Icons.local_fire_department_rounded, label: 'Deals'),
    BottomNavItem(icon: LucideIcons.heart, label: 'Favorites'),
    BottomNavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: Semantics(
                  label: '${item.label} tab',
                  selected: isSelected,
                  button: true,
                  child: Tooltip(
                    message: item.label,
                    child: InkWell(
                      onTap: () => onTap(index),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedScale(
                            scale: isSelected ? 1.1 : 1.0,
                            duration: const Duration(milliseconds: 160),
                            child: Icon(
                              item.icon,
                              size: 20,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textMuted,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: isSelected
                                  ? AppTheme.primary
                                  : AppTheme.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
