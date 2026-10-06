import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/input/custom_input.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../checkout/screens/checkout_screen.dart';
import '../../home/data/home_mock_data.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../components/product_reviews_section.dart';

/// Product page: big picture, details, size & color options, quantity and "Add to Cart".
class ProductDetailScreen extends StatefulWidget {
  final HomeProduct product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  int _selectedColorIndex = 0;
  int _selectedSizeIndex = 1;

  final List<Color> _colors = const [
    Color(0xFF2563EB), // Royal Blue
    Color(0xFF1E293B), // Midnight Slate
    Color(0xFFE2E8F0), // Cool Grey
    Color(0xFFF59E0B), // Amber
  ];

  final List<String> _sizes = const ['S', 'M', 'L', 'XL'];

  late final List<ProductReview> _reviews = getMockProductReviews();

  HomeProduct get _product => widget.product;

  void _addToCart() {
    CartController.instance.add(_product, quantity: _quantity);
    showAppToast(context, 'Added $_quantity × "${_product.name}" to cart!');
  }

  void _buyNow() {
    CartController.instance.add(_product, quantity: _quantity);
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CheckoutScreen()));
  }

  void _openWriteReview() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => WriteReviewModal(
        onSubmit: (newReview) {
          setState(() {
            _reviews.insert(0, newReview);
          });
          if (mounted) {
            showAppToast(
              context,
              'Thank you! Your review has been submitted 🐼',
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  expandedHeight: 300,
                  backgroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : _product.cardBackground,
                  surfaceTintColor: Colors.transparent,
                  leading: _RoundIconButton(
                    icon: LucideIcons.arrowLeft,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    ListenableBuilder(
                      listenable: WishlistController.instance,
                      builder: (context, _) {
                        final liked = WishlistController.instance.contains(
                          _product.id,
                        );
                        return _RoundIconButton(
                          icon: liked
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: liked ? const Color(0xFFEF4444) : null,
                          onTap: () =>
                              WishlistController.instance.toggle(_product.id),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: _product.imageUrl != null
                            ? Image.network(
                                _product.imageUrl!,
                                height: 220,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => Icon(
                                  _product.fallbackIcon,
                                  size: 130,
                                  color: AppColors.homePrimary.withValues(
                                    alpha: 0.75,
                                  ),
                                ),
                              )
                            : Icon(
                                _product.fallbackIcon,
                                size: 130,
                                color: AppColors.homePrimary.withValues(
                                  alpha: 0.75,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: _buildDetails()),
              ],
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category and Rating Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.homePrimaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _product.category,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.homePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 4),
              Text(
                '${_product.rating.toStringAsFixed(1)} (${_product.reviewsCount} reviews)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Product Title
          Text(
            _product.name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),

          // Price Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatPrice(_product.price),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.homePrimary,
                ),
              ),
              if (_product.originalPrice != null) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    formatPrice(_product.originalPrice!),
                    style: TextStyle(
                      fontSize: 15,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ),
              ],
              if (_product.discountTag != null) ...[
                const SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    _product.discountTag!,
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // Color selector
          Text(
            'Select Color',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_colors.length, (index) {
              final color = _colors[index];
              final isSelected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 16,
                            color: color.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
                          )
                        : null,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 18),

          // Size selector
          Text(
            'Select Size',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_sizes.length, (index) {
              final size = _sizes[index];
              final isSelected = _selectedSizeIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedSizeIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.homePrimary
                        : (isDark ? AppColors.darkCard : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.homePrimary
                          : (isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 22),

          // Description
          Text(
            'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'High quality ${_product.name.toLowerCase()} from our '
            '${_product.category.toLowerCase()} collection. Comfortable, '
            'durable and designed to look great every day. Free delivery on '
            'orders over ${formatPrice(CartController.freeShippingFrom)}.',
            style: TextStyle(
              fontSize: 14,
              height: 1.55,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),

          // Trust Highlights Row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TrustItem(icon: LucideIcons.truck, text: 'Free delivery'),
                  SizedBox(width: 16),
                  _TrustItem(
                    icon: LucideIcons.shieldCheck,
                    text: '100% Authentic',
                  ),
                  SizedBox(width: 16),
                  _TrustItem(
                    icon: LucideIcons.rotateCcw,
                    text: '30-day return',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Quantity Stepper
          Row(
            children: [
              Text(
                'Quantity',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              QuantityStepper(
                quantity: _quantity,
                onMinus: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
                onPlus: () => setState(() => _quantity++),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Divider(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 24),

          // Interactive Customer Reviews and Breakdown
          ProductReviewsSection(
            rating: _product.rating,
            reviewsCount: _product.reviewsCount,
            reviews: _reviews,
            onWriteReview: _openWriteReview,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
                Text(
                  formatPrice(_product.price * _quantity),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _addToCart,
                icon: const Icon(LucideIcons.shoppingBag, size: 18),
                label: const Text('Add to Cart'),
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
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Buy Now',
              style: IconButton.styleFrom(
                backgroundColor: isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.homePrimaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                minimumSize: const Size(52, 52),
              ),
              icon: const Icon(LucideIcons.zap, color: AppColors.homePrimary),
              onPressed: _buyNow,
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TrustItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.homePrimary),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Round white button used on top of the product picture.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _RoundIconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkCard.withValues(alpha: 0.9)
                : Colors.white.withValues(alpha: 0.95),
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 20,
            color: color ?? (isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
