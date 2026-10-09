import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

/// Top app header for categories screen:
/// - Greeting: "Good morning, Alex"
/// - Title: "Find what you love"
/// - Profile/avatar button
/// - Notification button with a small badge
class AppHeader extends StatelessWidget {
  final String greeting;
  final String title;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  const AppHeader({
    super.key,
    this.greeting = 'Good morning, Alex',
    this.title = 'Find what you love',
    this.notificationCount = 3,
    this.onNotificationTap,
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Semantics(
            label: 'User profile avatar',
            button: true,
            child: Tooltip(
              message: 'View profile',
              child: InkWell(
                onTap: onProfileTap,
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                    ),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🐼',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Greeting & Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  greeting,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Notification button with badge
          Semantics(
            label: 'Notifications, $notificationCount unread',
            button: true,
            child: Tooltip(
              message: 'Notifications',
              child: InkWell(
                onTap: onNotificationTap,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        LucideIcons.bell,
                        size: 20,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF0F172A),
                      ),
                      if (notificationCount > 0)
                        Positioned(
                          top: 9,
                          right: 10,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
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

