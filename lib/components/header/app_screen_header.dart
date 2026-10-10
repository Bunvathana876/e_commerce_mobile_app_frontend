import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Reusable, unified header component for ShopPanda screens.
///
/// Implements [PreferredSizeWidget] so it can be passed directly as a
/// [Scaffold.appBar] or rendered inline inside a [Column] / [CustomScrollView].
///
/// Provides a consistent, polished design language across all screens:
/// - Leading container (custom icon badge, avatar, or 40x40 circular back button)
/// - Title & optional subtitle / greeting with clean typography
/// - Optional pill badge (e.g., item count or status)
/// - Stylized 40x40 circular action buttons with badge support and tooltips
/// - Adaptive Light and Dark theme styling
class AppScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final Color? leadingIconBackground;
  final Widget? leadingWidget;
  final bool showBackButton;
  final VoidCallback? onBack;
  final List<Widget>? actions;
  final Color? backgroundColor;

  const AppScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconBackground,
    this.leadingWidget,
    this.showBackButton = false,
    this.onBack,
    this.actions,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkBackground : AppColors.background);

    return Container(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Leading section: Back button, custom widget, or themed icon badge
              if (showBackButton)
                _buildBackButton(context, isDark)
              else if (leadingWidget != null)
                leadingWidget!
              else if (leadingIcon != null)
                _buildIconBadge(isDark),

              if (showBackButton || leadingWidget != null || leadingIcon != null)
                const SizedBox(width: 12),

              // Title, Subtitle, and Optional Badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : const Color(0xFF64748B),
                        ),
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: subtitle != null ? 20 : 21,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (badgeText != null && badgeText!.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(
                                alpha: isDark ? 0.22 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              badgeText!,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              if (actions != null && actions!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context, bool isDark) {
    return Semantics(
      label: 'Back',
      button: true,
      child: Tooltip(
        message: 'Back',
        child: InkWell(
          onTap: onBack ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 40,
            height: 40,
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
                  blurRadius: 4,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              size: 20,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIconBadge(bool isDark) {
    final defaultBg = (leadingIconColor ?? AppColors.primary).withValues(
      alpha: isDark ? 0.22 : 0.12,
    );
    final bg = leadingIconBackground ?? defaultBg;
    final iconColor = leadingIconColor ?? AppColors.primary;

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: iconColor.withValues(alpha: isDark ? 0.3 : 0.15),
          width: 1,
        ),
      ),
      child: Center(
        child: Icon(
          leadingIcon,
          color: iconColor,
          size: 21,
        ),
      ),
    );
  }
}

/// A circular 40x40 icon button matching the header styling across ShopPanda.
class AppHeaderActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final String semanticLabel;
  final int badgeCount;
  final VoidCallback onTap;
  final Color? iconColor;

  const AppHeaderActionButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.semanticLabel,
    this.badgeCount = 0,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Semantics(
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
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.03,
                      ),
                      blurRadius: 4,
                      offset: const Offset(0, 1.5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: onTap,
                    child: Center(
                      child: Icon(
                        icon,
                        size: 19,
                        color: iconColor ??
                            (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                      ),
                    ),
                  ),
                ),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -2,
                  right: -2,
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark ? AppColors.darkSurface : Colors.white,
                        width: 1.5,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      badgeCount > 99 ? '99+' : '$badgeCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        height: 1,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

