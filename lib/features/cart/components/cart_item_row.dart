import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/input/custom_input.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../controllers/cart_controller.dart';

/// One product row in the cart: picture, name, price, quantity and delete.
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
    final product = item.product;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: product.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          product.fallbackIcon,
                          size: 36,
                          color: AppColors.homePrimary.withValues(alpha: 0.75),
                        ),
                      )
                    : Icon(
                        product.fallbackIcon,
                        size: 36,
                        color: AppColors.homePrimary.withValues(alpha: 0.75),
                      ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onRemove,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          LucideIcons.trash2,
                          size: 18,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  product.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      formatPrice(item.total),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.homePrimary,
                      ),
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
