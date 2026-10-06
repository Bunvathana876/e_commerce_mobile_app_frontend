import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/empty_state/empty_state.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../checkout/screens/checkout_screen.dart';
import '../../products/screens/product_detail_screen.dart';
import '../components/cart_item_row.dart';
import '../controllers/cart_controller.dart';

/// Cart page: list of products, quantity +/-, price summary and Checkout.
class CartScreen extends StatefulWidget {
  /// Called when the user taps "Start Shopping" (e.g. go to the Home tab).
  final VoidCallback? onStartShopping;

  /// Called after an order is placed and the user taps "View my orders".
  final VoidCallback? onViewOrders;

  const CartScreen({super.key, this.onStartShopping, this.onViewOrders});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  bool _promoApplied = false;
  double _discountAmount = 0.0;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (code == 'PANDA10' || code == 'SAVE10') {
      setState(() {
        _promoApplied = true;
        _discountAmount = 10.0;
      });
      showAppToast(
        context,
        '🎉 Promo code "$code" applied! \$10 discount added.',
      );
    } else if (code.isEmpty) {
      showAppToast(context, 'Please enter a promo code.');
    } else {
      showAppToast(context, 'Invalid promo code. Try "PANDA10"');
    }
  }

  void _removePromo() {
    setState(() {
      _promoApplied = false;
      _discountAmount = 0.0;
      _promoController.clear();
    });
    showAppToast(context, 'Promo code removed.');
  }

  void _openCheckout(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CheckoutScreen(
          onViewOrders: widget.onViewOrders,
          onContinueShopping: widget.onStartShopping,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              icon: const Icon(
                LucideIcons.trash2,
                size: 20,
                color: AppColors.textSecondary,
              ),
              tooltip: 'Clear Cart',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    title: const Text('Clear Cart?'),
                    content: const Text(
                      'Are you sure you want to remove all items from your cart?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          cart.clear();
                          Navigator.of(ctx).pop();
                          showAppToast(context, 'Cart cleared');
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(color: AppColors.error),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.isEmpty) {
            return PandaEmptyState(
              title: "Your cart is lonely! Let's find some deals",
              message:
                  "Looks like you haven't added anything yet. Explore fresh arrivals and grab your favorites!",
              buttonText: 'Start Shopping',
              onButtonTap: widget.onStartShopping,
            );
          }

          final effectiveTotal = (cart.total - _discountAmount).clamp(
            0.0,
            double.infinity,
          );

          return Column(
            children: [
              // Free shipping progress bar
              _FreeShippingBanner(subtotal: cart.subtotal),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  children: [
                    for (final item in cart.items)
                      CartItemRow(
                        item: item,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: item.product),
                          ),
                        ),
                        onMinus: () => cart.decrement(item.product.id),
                        onPlus: () => cart.increment(item.product.id),
                        onRemove: () => cart.remove(item.product.id),
                      ),
                  ],
                ),
              ),

              // Summary and checkout
              _buildSummary(context, cart, effectiveTotal),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummary(
    BuildContext context,
    CartController cart,
    double effectiveTotal,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Promo Code Row
          if (!_promoApplied)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.homeSurface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    LucideIcons.tag,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _promoController,
                      textCapitalization: TextCapitalization.characters,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Promo code (try PANDA10)',
                        hintStyle: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 8),
                      ),
                      onSubmitted: (_) => _applyPromo(),
                    ),
                  ),
                  TextButton(
                    onPressed: _applyPromo,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'PANDA10 (- \$10.00)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: _removePromo,
                    child: const Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),

          _SummaryRow(label: 'Subtotal', value: formatPrice(cart.subtotal)),
          const SizedBox(height: 6),
          _SummaryRow(
            label: 'Shipping',
            value: cart.shipping == 0 ? 'Free' : formatPrice(cart.shipping),
          ),
          if (_promoApplied) ...[
            const SizedBox(height: 6),
            _SummaryRow(
              label: 'Promo Discount',
              value: '- ${formatPrice(_discountAmount)}',
              isDiscount: true,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _SummaryRow(
            label: 'Total',
            value: formatPrice(effectiveTotal),
            bold: true,
          ),
          const SizedBox(height: 14),
          ElevatedButton(
            onPressed: () => _openCheckout(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.homePrimary,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              textStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

class _FreeShippingBanner extends StatelessWidget {
  final double subtotal;

  const _FreeShippingBanner({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    final freeThreshold = CartController.freeShippingFrom;
    final isFree = subtotal >= freeThreshold;
    final progress = (subtotal / freeThreshold).clamp(0.0, 1.0);
    final remaining = freeThreshold - subtotal;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 6, 20, 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isFree ? const Color(0xFFF0FDF4) : AppColors.homePrimaryLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isFree
              ? const Color(0xFF86EFAC)
              : AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isFree
                    ? Icons.check_circle_rounded
                    : Icons.local_shipping_rounded,
                size: 18,
                color: isFree ? const Color(0xFF16A34A) : AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isFree
                      ? 'Congratulations! You unlocked FREE shipping 🎉'
                      : 'Add ${formatPrice(remaining)} more for FREE delivery',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                    color: isFree
                        ? const Color(0xFF15803D)
                        : AppColors.homePrimaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(
                isFree ? const Color(0xFF22C55E) : AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool isDiscount;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.isDiscount = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      color: bold
          ? AppColors.textPrimary
          : (isDiscount ? const Color(0xFF16A34A) : AppColors.textSecondary),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: bold
              ? style.copyWith(color: AppColors.homePrimary)
              : (isDiscount
                    ? style.copyWith(fontWeight: FontWeight.bold)
                    : style),
        ),
      ],
    );
  }
}
