import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../models/category.dart';

/// Popular categories horizontal swipeable cards:
/// - Includes Fashion, Shoes, Bags, Electronics
/// - Each card has an image, category name, item count, and favorite button with scale animation
/// - Page / dot indicators
class PopularCategories extends StatefulWidget {
  final List<Category> categories;
  final ValueChanged<Category> onCategoryTap;
  final ValueChanged<Category> onToggleFavorite;

  const PopularCategories({
    super.key,
    required this.categories,
    required this.onCategoryTap,
    required this.onToggleFavorite,
  });

  @override
  State<PopularCategories> createState() => _PopularCategoriesState();
}

class _PopularCategoriesState extends State<PopularCategories> {
  final ScrollController _scrollController = ScrollController();
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;
    const itemWidth = 190.0 + 14.0; // card width + separator
    final offset = _scrollController.offset;
    final newIndex = (offset / itemWidth).round().clamp(
      0,
      widget.categories.isEmpty ? 0 : widget.categories.length - 1,
    );
    if (newIndex != _activeIndex) {
      setState(() => _activeIndex = newIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final items = widget.categories;

    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.local_fire_department_rounded,
                        color: Color(0xFF2563EB),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Popular categories',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Swipe to explore',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),

        // Horizontal list
        SizedBox(
          height: 215,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cat = items[index];
              return _PopularCategoryCard(
                category: cat,
                onTap: () => widget.onCategoryTap(cat),
                onToggleFavorite: () => widget.onToggleFavorite(cat),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // Page dot indicators
        if (items.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(items.length, (index) {
              final isCurrent = index == _activeIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: isCurrent ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isCurrent
                      ? const Color(0xFF2563EB)
                      : (isDark
                          ? AppColors.darkBorder
                          : const Color(0xFFCBD5E1)),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class _PopularCategoryCard extends StatefulWidget {
  final Category category;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  const _PopularCategoryCard({
    required this.category,
    required this.onTap,
    required this.onToggleFavorite,
  });

  @override
  State<_PopularCategoryCard> createState() => _PopularCategoryCardState();
}

class _PopularCategoryCardState extends State<_PopularCategoryCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _heartAnim;

  @override
  void initState() {
    super.initState();
    _heartAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      lowerBound: 1.0,
      upperBound: 1.35,
    );
  }

  @override
  void dispose() {
    _heartAnim.dispose();
    super.dispose();
  }

  void _triggerFavorite() {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    widget.onToggleFavorite();
    if (!disableAnimations) {
      _heartAnim.forward().then((_) => _heartAnim.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.category;

    return Container(
      width: 190,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top preview surface
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(19),
                    ),
                    child: Container(
                      height: 125,
                      width: double.infinity,
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF8FAFC),
                      child: cat.imageAsset != null
                          ? Image.asset(
                              cat.imageAsset!,
                              fit: BoxFit.cover,
                              cacheWidth: 400,
                              cacheHeight: 300,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallback(cat, isDark),
                            )
                          : _buildFallback(cat, isDark),
                    ),
                  ),

                  // Favorite heart button with scale animation
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Semantics(
                      label: cat.isFavorite
                          ? 'Remove ${cat.name} from favorites'
                          : 'Add ${cat.name} to favorites',
                      button: true,
                      child: Tooltip(
                        message: cat.isFavorite
                            ? 'Remove favorite'
                            : 'Add favorite',
                        child: InkWell(
                          onTap: _triggerFavorite,
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurface.withValues(alpha: 0.9)
                                  : Colors.white.withValues(alpha: 0.92),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: ScaleTransition(
                                scale: _heartAnim,
                                child: Icon(
                                  cat.isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_outline_rounded,
                                  size: 18,
                                  color: cat.isFavorite
                                      ? const Color(0xFFEF4444)
                                      : (isDark
                                          ? AppColors.darkTextSecondary
                                          : const Color(0xFF64748B)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Badge pill if available
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
                          color: const Color(0xFF2563EB),
                          borderRadius: BorderRadius.circular(6),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(
                                0xFF2563EB,
                              ).withValues(alpha: 0.35),
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
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              // Title and items count
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
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
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : const Color(0xFF64748B),
                      ),
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
        size: 44,
        color: cat.accentColor.withValues(alpha: 0.8),
      ),
    );
  }
}
