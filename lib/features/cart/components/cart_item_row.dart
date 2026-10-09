import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/input/custom_input.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../controllers/cart_controller.dart';

/// Professional cart item card: image showcase, product title, category tag,
/// unit and total pricing, accessible quantity controls, and delete action.
class CartItemRow extends StatelessWidget {
  final CartItem item;
  final VoidCallback onTap;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onRemove;

  const CartItemRow({
    super.key,
    required this.item,
    required this.onTap,
    required this.onMinus,
    required this.onPlus,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = item.product;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Studio Product Thumbnail
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 82,
              height: 82,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF0F172A)
                    : (product.cardBackground),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) => Icon(
                          product.fallbackIcon,
                          size: 36,
                          color: AppColors.primary.withValues(alpha: 0.7),
                        ),
                      )
                    : Icon(
                        product.fallbackIcon,
                        size: 36,
                        color: AppColors.primary.withValues(alpha: 0.7),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // 2. Product Details & Controls
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title and Delete Action
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          height: 1.25,
                          letterSpacing: -0.2,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFEF4444,
                          ).withValues(alpha: isDark ? 0.2 : 0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          LucideIcons.trash2,
                          size: 15,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Category tag
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    product.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Price and Quantity Stepper Row
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatPrice(item.total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.3,
                            color: AppColors.primary,
                          ),
                        ),
                        if (item.quantity > 1)
                          Text(
                            '${formatPrice(product.price)} each',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                    const Spacer(),
                    QuantityStepper(
                      quantity: item.quantity,
                      onMinus: onMinus,
                      onPlus: onPlus,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
