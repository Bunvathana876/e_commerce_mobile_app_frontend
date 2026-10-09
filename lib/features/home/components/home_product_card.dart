import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../data/home_mock_data.dart';

/// Clean, modern product card with favorite toggle, rating, price, and add-to-cart.
class HomeProductCard extends StatelessWidget {
  final HomeProduct product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onAddToCart;

  const HomeProductCard({
    super.key,
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: Image Container with Discount & Favorite Button
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                    ),
                    child: Center(
                      child: product.imageUrl != null
                          ? Image.network(
                              product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    product.fallbackIcon,
                                    size: 48,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.65,
                                    ),
                                  ),
                            )
                          : Icon(
                              product.fallbackIcon,
                              size: 48,
                              color: AppColors.primary.withValues(alpha: 0.65),
                            ),
                    ),
                  ),

                  // Discount / New Badge
                  if (product.discountTag != null || product.isNew)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: product.isNew
                              ? (isDark
                                    ? const Color(0xFF3B82F6)
                                    : AppColors.primaryDark)
                              : const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          product.isNew ? 'NEW' : product.discountTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                    ),

                  // Favorite Heart Button
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: onFavoriteTap,
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkSurface.withValues(alpha: 0.85)
                              : Colors.white.withValues(alpha: 0.95),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0),
                            width: 0.8,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 4,
                              offset: const Offset(0, 1.5),
                            ),
                          ],
                        ),
                        child: AnimatedScale(
                          scale: product.isFavorite ? 1.15 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeOutBack,
                          child: Icon(
                            product.isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: product.isFavorite
                                ? const Color(0xFFEF4444)
                                : (isDark
                                      ? AppColors.darkTextSecondary
                                      : const Color(0xFF94A3B8)),
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
                children: [
                  // Category & Rating Row
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          product.category.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextMuted
                                : const Color(0xFF94A3B8),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        product.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        ' (${product.reviewsCount})',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Title
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price & Add to Cart Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            if (product.originalPrice != null)
                              Text(
                                '\$${product.originalPrice!.toStringAsFixed(2)}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 10.5,
                                  decoration: TextDecoration.lineThrough,
                                  color: isDark
                                      ? AppColors.darkTextMuted
                                      : const Color(0xFF94A3B8),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      // Add to Cart Button
                      InkWell(
                        onTap: onAddToCart,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
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
                            size: 19,
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
}
