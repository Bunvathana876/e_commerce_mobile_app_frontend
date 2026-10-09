import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

/// Modern product card for the "Made for you" section:
/// Product images (asset or gradient placeholder), discount badges,
/// favorite heart buttons with animation, title, ratings, original strikethrough price,
/// sale price, and quick add-to-cart action.
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusLg),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Image Container with Discount Badge & Favorite Heart
            Expanded(
              child: Stack(
                children: [
                  // Product image or gradient placeholder
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: product.placeholderGradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppTheme.radiusLg - 1),
                      ),
                    ),
                    padding: const EdgeInsets.all(AppTheme.spacingSm),
                    child: Center(
                      child: product.imageAsset != null
                          ? Image.asset(
                              product.imageAsset!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildFallbackIcon(),
                            )
                          : (product.imageUrl != null
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            _buildFallbackIcon(),
                                  )
                                : _buildFallbackIcon()),
                    ),
                  ),

                  // Discount Badge
                  if (product.discountBadge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.saleRed,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSm,
                          ),
                        ),
                        child: Text(
                          product.discountBadge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Heart Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Semantics(
                      label: product.isFavorite
                          ? 'Remove ${product.name} from favorites'
                          : 'Add ${product.name} to favorites',
                      button: true,
                      child: InkWell(
                        onTap: onFavoriteTap,
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.95),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.border,
                              width: 0.8,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                          child: AnimatedScale(
                            scale: product.isFavorite ? 1.15 : 1.0,
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOutBack,
                            child: Icon(
                              product.isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 16.5,
                              color: product.isFavorite
                                  ? AppTheme.saleRed
                                  : AppTheme.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom: Product Details
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Category & Rating Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.category.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textMuted,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: AppTheme.starGold,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),

                  // Title
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price hierarchy & Add to Cart
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppTheme.primary,
                              ),
                            ),
                            if (product.originalPrice != null)
                              Text(
                                '\$${product.originalPrice!.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppTheme.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Add to cart action button
                      Semantics(
                        label: 'Add ${product.name} to cart',
                        button: true,
                        child: InkWell(
                          onTap: onAddToCart,
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusSm,
                          ),
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSm,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primary.withValues(
                                    alpha: 0.28,
                                  ),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.add_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Icon(
      product.fallbackIcon,
      size: 44,
      color: AppTheme.primary.withValues(alpha: 0.55),
    );
  }
}
