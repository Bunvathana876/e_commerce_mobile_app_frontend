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
  int _activeImageIndex = 0;

  final List<Color> _colors = const [
    Color(0xFF2563EB), // Royal Blue
    Color(0xFF1E293B), // Midnight Slate
    Color(0xFFE2E8F0), // Cool Grey
    Color(0xFFF59E0B), // Warm Amber
  ];

  final List<String> _colorNames = const [
    'Royal Blue',
    'Midnight Slate',
    'Cool Grey',
    'Warm Amber',
  ];

  final List<String> _sizes = const ['S', 'M', 'L', 'XL', 'XXL'];

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
                  expandedHeight: 330,
                  backgroundColor: isDark
                      ? const Color(0xFF0F172A)
                      : _product.cardBackground,
                  surfaceTintColor: Colors.transparent,
                  leading: _RoundIconButton(
                    icon: LucideIcons.arrowLeft,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  actions: [
                    _RoundIconButton(
                      icon: LucideIcons.share2,
                      onTap: () {
                        showAppToast(context, 'Link copied to clipboard!');
                      },
                    ),
                    const SizedBox(width: 8),
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
                    const SizedBox(width: 14),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main Product Showcase Preview
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 40, bottom: 24),
                            child: _product.imageUrl != null
                                ? Image.network(
                                    _product.imageUrl!,
                                    height: 230,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, _, _) => Icon(
                                      _product.fallbackIcon,
                                      size: 135,
                                      color: AppColors.primary.withValues(
                                        alpha: 0.7,
                                      ),
                                    ),
                                  )
                                : Icon(
                                    _product.fallbackIcon,
                                    size: 135,
                                    color: AppColors.primary.withValues(
                                      alpha: 0.7,
                                    ),
                                  ),
                          ),
                        ),

                        // Image Pagination Indicators Capsule
                        Positioned(
                          bottom: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.black.withValues(alpha: 0.5)
                                  : Colors.white.withValues(alpha: 0.85),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : Colors.black.withValues(alpha: 0.05),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(3, (index) {
                                final isCurrent = _activeImageIndex == index;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _activeImageIndex = index),
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    width: isCurrent ? 18 : 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: isCurrent
                                          ? AppColors.primary
                                          : (isDark
                                                ? Colors.white38
                                                : Colors.black26),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                      ],
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
    final savings = _product.originalPrice != null
        ? (_product.originalPrice! - _product.price)
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Category and Stock Status Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.2 : 0.1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _product.category.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 12,
                      color: Color(0xFF10B981),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'In Stock',
                      style: TextStyle(
                        color: Color(0xFF059669),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Product Name
          Text(
            _product.name,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),

          // 3. Rating & Reviews Row (directly below product name)
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 18,
                color: Color(0xFFF59E0B),
              ),
              const SizedBox(width: 4),
              Text(
                _product.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(${_product.reviewsCount} reviews)',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 12,
                width: 1,
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
              const SizedBox(width: 10),
              const Text(
                'Top Seller 🔥',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 4. Price & Discount / Original Price Hierarchy
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatPrice(_product.price),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                  color: AppColors.primary,
                ),
              ),
              if (_product.originalPrice != null) ...[
                const SizedBox(width: 10),
                Text(
                  formatPrice(_product.originalPrice!),
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              if (_product.discountTag != null) ...[
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _product.discountTag!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              if (savings != null && savings > 0) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Save ${formatPrice(savings)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),

          // 5. Product Information / Description
          Text(
            'About this item',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
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
          const SizedBox(height: 22),

          // 6. Options: Color selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Color: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: _colorNames[_selectedColorIndex],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${_colors.length} options',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_colors.length, (index) {
              final color = _colors[index];
              final isSelected = _selectedColorIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedColorIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 14),
                  padding: const EdgeInsets.all(2.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.2,
                    ),
                  ),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.15)
                            : Colors.black.withValues(alpha: 0.08),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Icon(
                            Icons.check_rounded,
                            size: 17,
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
          const SizedBox(height: 20),

          // 7. Options: Size selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Size: ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                  children: [
                    TextSpan(
                      text: _sizes[_selectedSizeIndex],
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  showAppToast(context, 'Standard sizing guide available');
                },
                child: const Row(
                  children: [
                    Icon(LucideIcons.ruler, size: 13, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'Size Guide',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(_sizes.length, (index) {
              final size = _sizes[index];
              final isSelected = _selectedSizeIndex == index;
              final isDisabled =
                  size == 'XXL'; // Demonstration of disabled option

              return GestureDetector(
                onTap: isDisabled
                    ? () {
                        showAppToast(
                          context,
                          'Size XXL is currently out of stock',
                        );
                      }
                    : () => setState(() => _selectedSizeIndex = index),
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: isDisabled
                        ? (isDark
                              ? AppColors.darkCard.withValues(alpha: 0.4)
                              : const Color(0xFFF1F5F9))
                        : isSelected
                        ? AppColors.primary
                        : (isDark ? AppColors.darkCard : Colors.white),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDisabled
                          ? Colors.transparent
                          : isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0)),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.w800
                          : FontWeight.w600,
                      decoration: isDisabled
                          ? TextDecoration.lineThrough
                          : null,
                      color: isDisabled
                          ? (isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted)
                          : isSelected
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
          const SizedBox(height: 24),

          // 8. Trust Highlights Container
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
              ),
            ),
            child: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _TrustItem(
                    icon: LucideIcons.truck,
                    title: 'Free delivery',
                    subtitle: 'Over \$100',
                  ),
                  SizedBox(width: 24),
                  _TrustItem(
                    icon: LucideIcons.shieldCheck,
                    title: '100% Authentic',
                    subtitle: 'Verified',
                  ),
                  SizedBox(width: 24),
                  _TrustItem(
                    icon: LucideIcons.rotateCcw,
                    title: '30-day return',
                    subtitle: 'Hassle-free',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // 9. Quantity Stepper
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quantity',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Max 10 per order',
                    style: TextStyle(
                      fontSize: 11.5,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              QuantityStepper(
                quantity: _quantity,
                onMinus: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
                onPlus: () {
                  if (_quantity < 10) setState(() => _quantity++);
                },
              ),
            ],
          ),
          const SizedBox(height: 28),
          Divider(
            color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 24),

          // 10. Interactive Customer Reviews and Breakdown
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
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.textMuted,
                  ),
                ),
                Text(
                  formatPrice(_product.price * _quantity),
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
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
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size.fromHeight(52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              tooltip: 'Buy Now',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(
                  alpha: isDark ? 0.2 : 0.1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                minimumSize: const Size(52, 52),
              ),
              icon: const Icon(LucideIcons.zap, color: AppColors.primary),
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
  final String title;
  final String subtitle;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 15, color: AppColors.primary),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Round white/dark button used on top of the product picture.
class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const _RoundIconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 6, top: 6, bottom: 6),
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
            size: 19,
            color: color ?? (isDark ? Colors.white : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
