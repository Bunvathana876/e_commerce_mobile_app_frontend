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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Text(
              'My Cart',
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.3,
              ),
            ),
            if (!cart.isEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${cart.totalCount} items',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
        actions: [
          if (!cart.isEmpty)
            IconButton(
              icon: Icon(
                LucideIcons.trash2,
                size: 19,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
              tooltip: 'Clear Cart',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: isDark ? AppColors.darkCard : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    title: Text(
                      'Clear Cart?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    content: Text(
                      'Are you sure you want to remove all items from your cart?',
                      style: TextStyle(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          cart.clear();
                          Navigator.of(ctx).pop();
                          showAppToast(context, 'Cart cleared');
                        },
                        child: const Text(
                          'Clear All',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          const SizedBox(width: 8),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Promo Code Input
            if (!_promoApplied)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 3,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      LucideIcons.tag,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _promoController,
                        textCapitalization: TextCapitalization.characters,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Promo code (try PANDA10)',
                          hintStyle: TextStyle(
                            fontSize: 12.5,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textMuted,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                        ),
                        onSubmitted: (_) => _applyPromo(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _applyPromo,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12.5,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF10B981,
                  ).withValues(alpha: isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF10B981).withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      size: 17,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'PANDA10 (- \$10.00)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: _removePromo,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(2),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Financial Summary Rows
            _SummaryRow(label: 'Subtotal', value: formatPrice(cart.subtotal)),
            const SizedBox(height: 7),
            _SummaryRow(
              label: 'Shipping',
              value: cart.shipping == 0 ? 'Free' : formatPrice(cart.shipping),
              isDiscount: cart.shipping == 0,
            ),
            if (_promoApplied) ...[
              const SizedBox(height: 7),
              _SummaryRow(
                label: 'Promo Discount',
                value: '- ${formatPrice(_discountAmount)}',
                isDiscount: true,
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            _SummaryRow(
              label: 'Total',
              value: formatPrice(effectiveTotal),
              bold: true,
            ),
            const SizedBox(height: 16),

            // Checkout Button
            ElevatedButton(
              onPressed: () => _openCheckout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  letterSpacing: -0.2,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Checkout'),
                  SizedBox(width: 8),
                  Icon(LucideIcons.arrowRight, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Dynamic Free-Shipping progress banner clearly communicating progress & completion.
class _FreeShippingBanner extends StatelessWidget {
  final double subtotal;

  const _FreeShippingBanner({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    final freeThreshold = CartController.freeShippingFrom;
    final isFree = subtotal >= freeThreshold;
    final progress = (subtotal / freeThreshold).clamp(0.0, 1.0);
    final remaining = freeThreshold - subtotal;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isFree
            ? (isDark
                  ? const Color(0xFF064E3B).withValues(alpha: 0.35)
                  : const Color(0xFFF0FDF4))
            : (isDark
                  ? AppColors.darkCard
                  : AppColors.primary.withValues(alpha: 0.06)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isFree
              ? (isDark
                    ? const Color(0xFF059669).withValues(alpha: 0.4)
                    : const Color(0xFF86EFAC))
              : (isDark
                    ? AppColors.darkBorder
                    : AppColors.primary.withValues(alpha: 0.15)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isFree
                      ? const Color(0xFF22C55E).withValues(alpha: 0.15)
                      : AppColors.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isFree
                      ? Icons.check_circle_rounded
                      : Icons.local_shipping_rounded,
                  size: 16,
                  color: isFree ? const Color(0xFF22C55E) : AppColors.primary,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isFree
                          ? 'Congratulations! You unlocked FREE shipping 🎉'
                          : 'Add ${formatPrice(remaining)} more for FREE delivery',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: isFree
                            ? (isDark
                                  ? const Color(0xFF86EFAC)
                                  : const Color(0xFF15803D))
                            : (isDark ? Colors.white : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      isFree
                          ? 'Free standard shipping applied'
                          : 'Order over ${formatPrice(freeThreshold)} qualifies',
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: isDark
                  ? const Color(0xFF334155)
                  : const Color(0xFFE2E8F0),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = TextStyle(
      fontSize: bold ? 18 : 14,
      fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
      fontFeatures: const [FontFeature.tabularFigures()],
      color: bold
          ? (isDark ? Colors.white : AppColors.textPrimary)
          : (isDiscount
                ? const Color(0xFF16A34A)
                : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary)),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          value,
          style: bold
              ? style.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.3,
                )
              : (isDiscount
                    ? style.copyWith(fontWeight: FontWeight.bold)
                    : style),
        ),
      ],
    );
  }
}
