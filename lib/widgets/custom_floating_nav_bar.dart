import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

/// Data describing one tab in [CustomFloatingNavBar].
class FloatingNavItem {
  final IconData icon;
  final String label;

  const FloatingNavItem({required this.icon, required this.label});
}

/// Translucent, glassmorphic pill-shaped floating navigation bar.
///
/// Features a subtle frosted glass effect using [BackdropFilter] and [ImageFilter.blur].
/// Only the selected tab shows its label; selection changes smoothly animate
/// the highlight pill and label width.
class CustomFloatingNavBar extends StatefulWidget {
  final ValueChanged<int>? onItemSelected;
  final int initialIndex;
  final List<FloatingNavItem> items;

  /// Multiplies bar height, padding, icon and text size. 1.0 = default size.
  final double scale;

  /// Optional translucent shell color. If null, automatically adapts
  /// between translucent white (light theme) and translucent black (dark theme).
  final Color? shellColor;
  final Color? activeColor;

  const CustomFloatingNavBar({
    super.key,
    this.onItemSelected,
    this.initialIndex = 0,
    this.items = defaultItems,
    this.scale = 1.0,
    this.shellColor,
    this.activeColor,
  });

  static const List<FloatingNavItem> defaultItems = [
    FloatingNavItem(icon: LucideIcons.home, label: 'Home'),
    FloatingNavItem(icon: LucideIcons.lineChart, label: 'Chart'),
    FloatingNavItem(icon: LucideIcons.creditCard, label: 'Card'),
    FloatingNavItem(icon: LucideIcons.messageSquare, label: 'Messages'),
    FloatingNavItem(icon: LucideIcons.trophy, label: 'Rewards'),
    FloatingNavItem(icon: LucideIcons.user, label: 'Profile'),
  ];

  @override
  State<CustomFloatingNavBar> createState() => _CustomFloatingNavBarState();
}

class _CustomFloatingNavBarState extends State<CustomFloatingNavBar> {
  static const _duration = Duration(milliseconds: 250);
  static const _curve = Curves.easeOutCubic;

  late int _currentIndex = widget.initialIndex;

  @override
  void didUpdateWidget(CustomFloatingNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Follow the parent when it changes the tab (e.g. a cart shortcut).
    if (widget.initialIndex != oldWidget.initialIndex) {
      _currentIndex = widget.initialIndex;
    }
  }

  void _select(int index) {
    if (index == _currentIndex) return;
    setState(() => _currentIndex = index);
    widget.onItemSelected?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Translucent shell color with enhanced transparency and contrast
    final Color effectiveShellColor =
        widget.shellColor ??
        (isDark
            ? const Color(0x660F172A)
            : Colors.white.withValues(alpha: 0.72));

    final bool isShellDark = effectiveShellColor.computeLuminance() < 0.5;

    // Translucent hairline border adapted to theme
    final Color effectiveBorder = isDark
        ? Colors.white.withValues(alpha: 0.18)
        : Colors.black.withValues(alpha: 0.08);

    final Color effectiveActive = widget.activeColor ?? const Color(0xFF2563EB);

    final Color effectiveInactive = isShellDark
        ? const Color(0xFFCBD5E1)
        : const Color(0xFF64748B);

    final Color shadowColor = isShellDark
        ? Colors.black.withValues(alpha: 0.45)
        : Colors.black.withValues(alpha: 0.08);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0),
          child: Container(
            height: 56 * widget.scale,
            padding: EdgeInsets.symmetric(
              horizontal: 5 * widget.scale,
              vertical: 5 * widget.scale,
            ),
            decoration: BoxDecoration(
              color: effectiveShellColor,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: effectiveBorder, width: 1.0),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < widget.items.length; i++)
                    _NavItem(
                      item: widget.items[i],
                      selected: i == _currentIndex,
                      activeColor: effectiveActive,
                      inactiveColor: effectiveInactive,
                      scale: widget.scale,
                      onTap: () => _select(i),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final FloatingNavItem item;
  final bool selected;
  final double scale;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.item,
    required this.selected,
    required this.scale,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        child: AnimatedContainer(
          duration: _CustomFloatingNavBarState._duration,
          curve: _CustomFloatingNavBarState._curve,
          padding: EdgeInsets.symmetric(
            horizontal: (selected ? 13 : 8.5) * scale,
            vertical: 8 * scale,
          ),
          decoration: BoxDecoration(
            color: selected ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 20 * scale,
                color: selected ? Colors.white : inactiveColor,
              ),
              AnimatedSize(
                duration: _CustomFloatingNavBarState._duration,
                curve: _CustomFloatingNavBarState._curve,
                alignment: Alignment.centerLeft,
                child: selected
                    ? Padding(
                        padding: EdgeInsets.only(left: 6 * scale),
                        child: Text(
                          item.label,
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13 * scale,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
