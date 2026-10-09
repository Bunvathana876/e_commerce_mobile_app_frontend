import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

/// Top header bar for HomeScreen with user greeting, delivery address,
/// notification and cart action icons.
class HomeHeader extends StatelessWidget {
  final String userName;
  final String location;
  final int cartItemCount;
  final int unreadNotifications;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    this.userName = 'Alex',
    this.location = 'Phnom Penh, Cambodia',
    this.cartItemCount = 2,
    this.unreadNotifications = 3,
    this.onNotificationTap,
    this.onCartTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        children: [
          // User Avatar / Panda Logo
          InkWell(
            onTap: onProfileTap ?? () {},
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 44,
              height: 44,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurface
                    : AppColors.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.35 : 0.2,
                  ),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo/Blue-and-White Panda Waving.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.person_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Greeting & Location
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome, $userName 👋',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 3),
                InkWell(
                  onTap: onProfileTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_rounded,
                          size: 13,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 14,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Notification Button with Badge
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            badgeCount: unreadNotifications,
            onTap: onNotificationTap ?? () {},
            isDark: isDark,
          ),
          const SizedBox(width: 8),

          // Cart Button with Badge
          _HeaderIconButton(
            icon: Icons.shopping_bag_outlined,
            badgeCount: cartItemCount,
            onTap: onCartTap ?? () {},
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;
  final bool isDark;

  const _HeaderIconButton({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: Icon(
                icon,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBackground : Colors.white,
                  width: 1.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                '$badgeCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
