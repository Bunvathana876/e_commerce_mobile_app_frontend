import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/category.dart';

/// Shop by category section:
/// - Section title and category count
/// - Toggle between grid view and list view
/// - Cards include image, category name, item count, arrow, and “New” or “Sale” badge
/// - Fade & slide entrance animations (respecting AccessibilityFeatures.disableAnimations)
class CategoryGrid extends StatelessWidget {
  final List<Category> categories;
  final bool isGridView;
  final VoidCallback onToggleView;
  final ValueChanged<Category> onCategoryTap;

  const CategoryGrid({
    super.key,
    required this.categories,
    required this.isGridView,
    required this.onToggleView,
    required this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header with count and view toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Shop by category',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '${categories.length} categories',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),

              // Grid / List toggle button
              Semantics(
                label: isGridView
                    ? 'Switch to list view'
                    : 'Switch to grid view',
                button: true,
                child: Tooltip(
                  message: isGridView ? 'List view' : 'Grid view',
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onToggleView,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0),
                            width: 1,
                          ),
                        ),
                        child: Icon(
                          isGridView
                              ? Icons.view_list_rounded
                              : Icons.grid_view_rounded,
                          size: 18,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Categories Content
          if (categories.isEmpty)
            _buildEmptySearch(context, isDark)
          else if (isGridView)
            _buildGridView(isDark, disableAnimations)
          else
            _buildListView(isDark, disableAnimations),
        ],
      ),
    );
  }

  Widget _buildEmptySearch(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : const Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🐼',
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'No matching categories',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Try checking your spelling or search for something else.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridView(bool isDark, bool disableAnimations) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 650 ? 3 : 2;
        final aspectRatio = constraints.maxWidth > 650 ? 0.95 : 0.82;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: aspectRatio,
          ),
          itemBuilder: (context, index) {
            final cat = categories[index];
            final card = _CategoryGridItem(
              category: cat,
              onTap: () => onCategoryTap(cat),
            );

            if (disableAnimations) return card;

            return _AnimatedEntrance(
              index: index,
              child: card,
            );
          },
        );
      },
    );
  }

  Widget _buildListView(bool isDark, bool disableAnimations) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final cat = categories[index];
        final card = _CategoryListItem(
          category: cat,
          onTap: () => onCategoryTap(cat),
        );

        if (disableAnimations) return card;

        return _AnimatedEntrance(
          index: index,
          child: card,
        );
      },
    );
  }
}

/// Fade and slide entrance wrapper.
class _AnimatedEntrance extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedEntrance({required this.index, required this.child});

  @override
  State<_AnimatedEntrance> createState() => _AnimatedEntranceState();
}

class _AnimatedEntranceState extends State<_AnimatedEntrance>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: widget.child,
      ),
    );
  }
}

/// Grid Card Item
class _CategoryGridItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryGridItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = category;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top preview image
              Expanded(
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(19),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: isDark
                            ? AppColors.darkSurface
                            : const Color(0xFFF8FAFC),
                        child: cat.imageAsset != null
                            ? Image.asset(
                                cat.imageAsset!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildFallback(cat, isDark),
                              )
                            : _buildFallback(cat, isDark),
                      ),
                    ),
                    if (cat.badge != null)
                      Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: cat.badge == 'Sale'
                                ? const Color(0xFFEF4444)
                                : const Color(0xFF2563EB),
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: (cat.badge == 'Sale'
                                        ? const Color(0xFFEF4444)
                                        : const Color(0xFF2563EB))
                                    .withValues(alpha: 0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            cat.badge!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Bottom details row
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            cat.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : const Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${cat.itemCount} items',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 17,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : const Color(0xFF94A3B8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(Category cat, bool isDark) {
    return Center(
      child: Icon(
        cat.fallbackIcon,
        size: 40,
        color: cat.accentColor.withValues(alpha: 0.8),
      ),
    );
  }
}

/// List View Item
class _CategoryListItem extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;

  const _CategoryListItem({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = category;

    return Container(
      height: 86,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Thumbnail image
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 66,
                    height: 66,
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF8FAFC),
                    child: cat.imageAsset != null
                        ? Image.asset(
                            cat.imageAsset!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                              child: Icon(
                                cat.fallbackIcon,
                                color: cat.accentColor,
                              ),
                            ),
                          )
                        : Center(
                            child: Icon(
                              cat.fallbackIcon,
                              color: cat.accentColor,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name and details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              cat.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          if (cat.badge != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: cat.badge == 'Sale'
                                    ? const Color(0xFFEF4444)
                                    : const Color(0xFF2563EB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                cat.badge!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${cat.itemCount} items in stock',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
