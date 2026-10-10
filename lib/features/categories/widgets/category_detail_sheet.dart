import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/product.dart';
import '../data/categories_data.dart';
import '../models/category.dart';

/// Modal bottom sheet displaying detailed category preview:
/// - Large category image
/// - Category Description
/// - Subcategory filter chips
/// - Best-selling products list with prices and discount badges
/// - Add-to-cart buttons updating CartController with toast/snackbar feedback
class CategoryDetailSheet extends StatefulWidget {
  final Category category;
  final ValueChanged<Product> onAddToCart;
  final ValueChanged<Product>? onProductTap;

  const CategoryDetailSheet({
    super.key,
    required this.category,
    required this.onAddToCart,
    this.onProductTap,
  });

  static Future<void> show({
    required BuildContext context,
    required Category category,
    required ValueChanged<Product> onAddToCart,
    ValueChanged<Product>? onProductTap,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => CategoryDetailSheet(
        category: category,
        onAddToCart: onAddToCart,
        onProductTap: onProductTap,
      ),
    );
  }

  @override
  State<CategoryDetailSheet> createState() => _CategoryDetailSheetState();
}

class _CategoryDetailSheetState extends State<CategoryDetailSheet> {
  late String _selectedSubcategory;

  @override
  void initState() {
    super.initState();
    _selectedSubcategory = widget.category.subcategories.isNotEmpty
        ? widget.category.subcategories.first
        : 'All';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.category;
    final bestSellers = categoryBestSellers[cat.id] ?? [];
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.88,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 4.5,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),

            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row: Title & close button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cat.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${cat.itemCount} active styles available',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : const Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Semantics(
                          label: 'Close details modal',
                          button: true,
                          child: IconButton(
                            tooltip: 'Close',
                            icon: const Icon(Icons.close_rounded),
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF0F172A),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Large category image hero container
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFF8FAFC),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            if (cat.imageAsset != null)
                              Image.asset(
                                cat.imageAsset!,
                                fit: BoxFit.cover,
                                cacheWidth: 600,
                                cacheHeight: 400,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildFallbackHero(cat, isDark),
                              )
                            else
                              _buildFallbackHero(cat, isDark),

                            // Soft gradient bottom shade
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.45),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            // Badge on hero
                            if (cat.badge != null)
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2563EB),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    cat.badge!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ),

                            // Subtitle overlay
                            Positioned(
                              bottom: 14,
                              left: 14,
                              right: 14,
                              child: Text(
                                'Explore top rated picks in ${cat.name}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Description
                    Text(
                      cat.description,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.45,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : const Color(0xFF475569),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Subcategory chips
                    if (cat.subcategories.isNotEmpty) ...[
                      Text(
                        'Subcategories',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: cat.subcategories.map((sub) {
                          final isSelected = _selectedSubcategory == sub;
                          return ChoiceChip(
                            label: Text(sub),
                            selected: isSelected,
                            onSelected: (val) {
                              if (val) {
                                setState(() => _selectedSubcategory = sub);
                              }
                            },
                            selectedColor: const Color(0xFF2563EB),
                            backgroundColor: isDark
                                ? AppColors.darkSurface
                                : const Color(0xFFF1F5F9),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                      ? AppColors.darkTextSecondary
                                      : const Color(0xFF334155)),
                              fontSize: 12.5,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: isSelected
                                    ? const Color(0xFF2563EB)
                                    : (isDark
                                        ? AppColors.darkBorder
                                        : const Color(0xFFE2E8F0)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Best-selling products
                    Text(
                      'Best-selling products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (bestSellers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No bestsellers loaded for this category yet.',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: bestSellers.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = bestSellers[index];
                          return _ProductRow(
                            product: product,
                            onTap: () => widget.onProductTap?.call(product),
                            onAddToCart: () => widget.onAddToCart(product),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackHero(Category cat, bool isDark) {
    return Center(
      child: Icon(
        cat.fallbackIcon,
        size: 64,
        color: cat.accentColor.withValues(alpha: 0.8),
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _ProductRow({
    required this.product,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                // Product preview image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: isDark
                        ? AppColors.darkCard
                        : const Color(0xFFEFF6FF),
                    child: product.imageAsset != null
                        ? Image.asset(
                            product.imageAsset!,
                            fit: BoxFit.cover,
                            cacheWidth: 150,
                            cacheHeight: 150,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              product.fallbackIcon,
                              color: const Color(0xFF2563EB),
                            ),
                          )
                        : Icon(
                            product.fallbackIcon,
                            color: const Color(0xFF2563EB),
                          ),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2563EB),
                            ),
                          ),
                          if (product.originalPrice != null) ...[
                            const SizedBox(width: 6),
                            Text(
                              '\$${product.originalPrice!.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                                color: isDark
                                    ? AppColors.darkTextMuted
                                    : const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Add to cart action button
                Semantics(
                  label: 'Add ${product.name} to cart',
                  button: true,
                  child: Tooltip(
                    message: 'Add to cart',
                    child: ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2563EB),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_shopping_cart_rounded, size: 15),
                          SizedBox(width: 4),
                          Text(
                            'Add',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
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
