import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Top header bar for the shopping home screen.
/// Shows avatar, “Welcome, Lee”, location selector showing “Phnom Penh, Cambodia”,
/// notification icon, and shopping bag icon.
class HomeHeaderWidget extends StatelessWidget {
  final String userName;
  final String location;
  final int notificationCount;
  final int bagCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBagTap;
  final VoidCallback? onLocationTap;
  final VoidCallback? onAvatarTap;

  const HomeHeaderWidget({
    super.key,
    this.userName = 'Lee',
    this.location = 'Phnom Penh, Cambodia',
    this.notificationCount = 3,
    this.bagCount = 2,
    this.onNotificationTap,
    this.onBagTap,
    this.onLocationTap,
    this.onAvatarTap,
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
          // User Avatar with Panda logo or fallback
          Semantics(
            label: 'User profile: $userName',
            button: true,
            child: Tooltip(
              message: 'View profile',
              child: InkWell(
                onTap: onAvatarTap,
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  width: 44,
                  height: 44,
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLight,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.primary.withValues(alpha: 0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/logo/Blue-and-White Panda Waving.png',
                      fit: BoxFit.cover,
                      cacheWidth: 120,
                      cacheHeight: 120,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.person_rounded,
                        color: AppTheme.primary,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: AppTheme.spacingMd),

          // Greeting & Location selector
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome, $userName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.getTextSecondary(context),
                  ),
                ),
                const SizedBox(height: 3),
                Semantics(
                  label: 'Delivery location: $location',
                  button: true,
                  child: Tooltip(
                    message: 'Change delivery location',
                    child: InkWell(
                      onTap: onLocationTap,
                      borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.getCardBackground(context),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusXl,
                          ),
                          border: Border.all(
                            color: AppTheme.getBorder(context),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: AppTheme.primary,
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.getTextPrimary(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 14,
                              color: AppTheme.getTextMuted(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Notification icon button
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            tooltip: 'Notifications',
            semanticLabel: 'Notifications, $notificationCount unread',
            badgeCount: notificationCount,
            onTap: onNotificationTap ?? () {},
          ),
          const SizedBox(width: AppTheme.spacingSm),

          // Shopping bag icon button
          _HeaderIconButton(
            icon: Icons.shopping_bag_outlined,
            tooltip: 'Shopping bag',
            semanticLabel: 'Shopping bag, $bagCount items',
            badgeCount: bagCount,
            onTap: onBagTap ?? () {},
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String semanticLabel;
  final int badgeCount;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.tooltip,
    required this.semanticLabel,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Tooltip(
        message: tooltip,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.getCardBackground(context),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.getBorder(context), width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: onTap,
                  child: Icon(icon, color: AppTheme.getTextPrimary(context), size: 20),
                ),
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 17,
                    minHeight: 17,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
