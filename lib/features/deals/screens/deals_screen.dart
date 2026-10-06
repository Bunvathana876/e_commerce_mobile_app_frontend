import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../home/data/home_mock_data.dart';
import '../../products/screens/product_detail_screen.dart';
import '../../wishlist/controllers/wishlist_controller.dart';

/// Dedicated "Deals & Offers" (Flash Sale) screen for ShopPanda.
///
/// Features daily discounts, limited-time flash sales with live countdowns,
/// discount filter chips, and interactive Add to Cart & Wishlist actions.
class DealsScreen extends StatefulWidget {
  final VoidCallback? onStartShopping;
  final VoidCallback? onViewCart;

  const DealsScreen({super.key, this.onStartShopping, this.onViewCart});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  String _selectedFilter = 'all'; // 'all', 'flash', '50off', 'fashion', 'shoes'
  final _cart = CartController.instance;
  final _wishlist = WishlistController.instance;

  // Flash sale countdown simulation
  late Timer _timer;
  int _secondsRemaining = 14820; // ~4 hours, 7 mins

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final hours = (totalSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((totalSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  List<HomeProduct> get _dealProducts {
    // Generate specialized discount deals from mockProducts
    final List<HomeProduct> deals = [
      mockProducts[0].copyWith(), // Hoodie (-20%)
      mockProducts[1].copyWith(), // Sneakers (-25%)
      mockProducts[2].copyWith(), // Bag (-15%)
      mockProducts[3].copyWith(), // Buds (-30%)
      const HomeProduct(
        id: 'deal_1',
        name: 'Pro Noise Canceling Wireless Headset',
        category: 'Electronics',
        price: 49.99,
        originalPrice: 129.99,
        rating: 4.9,
        reviewsCount: 312,
        discountTag: '-60%',
        fallbackIcon: Icons.headphones_rounded,
        cardBackground: Color(0xFFEFF6FF),
      ),
      const HomeProduct(
        id: 'deal_2',
        name: 'Polarized UV400 Designer Sunglasses',
        category: 'Fashion',
        price: 24.50,
        originalPrice: 59.00,
        rating: 4.8,
        reviewsCount: 178,
        discountTag: '-58%',
        fallbackIcon: Icons.wb_sunny_rounded,
        cardBackground: Color(0xFFFFFBEB),
      ),
      const HomeProduct(
        id: 'deal_3',
        name: 'AeroLite Breathable Running Shoes',
        category: 'Shoes',
        price: 45.00,
        originalPrice: 90.00,
        rating: 4.9,
        reviewsCount: 240,
        discountTag: '-50%',
        fallbackIcon: Icons.directions_run_rounded,
        cardBackground: Color(0xFFF0FDF4),
      ),
      const HomeProduct(
        id: 'deal_4',
        name: 'Waterproof Minimalist Smartwatch V2',
        category: 'Electronics',
        price: 35.00,
        originalPrice: 70.00,
        rating: 4.7,
        reviewsCount: 165,
        discountTag: '-50%',
        fallbackIcon: Icons.watch_rounded,
        cardBackground: Color(0xFFEFF6FF),
      ),
    ];

    switch (_selectedFilter) {
      case 'flash':
        return deals
            .where((p) => (p.originalPrice ?? 0) - p.price > 30)
            .toList();
      case '50off':
        return deals
            .where(
              (p) =>
                  p.discountTag != null &&
                  (p.discountTag!.contains('50') ||
                      p.discountTag!.contains('60') ||
                      p.discountTag!.contains('58')),
            )
            .toList();
      case 'fashion':
        return deals
            .where((p) => p.category.toLowerCase() == 'fashion')
            .toList();
      case 'shoes':
        return deals.where((p) => p.category.toLowerCase() == 'shoes').toList();
      default:
        return deals;
    }
  }

  void _openProduct(HomeProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  void _addToCart(HomeProduct product) {
    _cart.add(product);
    showAppToast(context, 'Added deal "${product.name}" to cart!');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final timeStr = _formatTime(_secondsRemaining).split(':');

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFEF4444),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Deals & Offers',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Exclusive daily discounts',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, size: 22),
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            onPressed: () {
              if (widget.onViewCart != null) {
                widget.onViewCart!();
              } else {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
              }
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListenableBuilder(
        listenable: Listenable.merge([_cart, _wishlist]),
        builder: (context, _) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 1. Flash Sale Countdown Hero Banner
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'FLASH SALE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Up to 70% Off Today',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Limited quantity available!',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Countdown Digits
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'ENDS IN',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                _TimeBox(value: timeStr[0]),
                                const Text(
                                  ' : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _TimeBox(value: timeStr[1]),
                                const Text(
                                  ' : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                _TimeBox(value: timeStr[2]),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // 2. Deals Category Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'All Deals',
                        isSelected: _selectedFilter == 'all',
                        onTap: () => setState(() => _selectedFilter = 'all'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '🔥 Flash Sale',
                        isSelected: _selectedFilter == 'flash',
                        onTap: () => setState(() => _selectedFilter = 'flash'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '🏷️ 50% Off+',
                        isSelected: _selectedFilter == '50off',
                        onTap: () => setState(() => _selectedFilter = '50off'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '👕 Fashion',
                        isSelected: _selectedFilter == 'fashion',
                        onTap: () =>
                            setState(() => _selectedFilter = 'fashion'),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '👟 Shoes',
                        isSelected: _selectedFilter == 'shoes',
                        onTap: () => setState(() => _selectedFilter = 'shoes'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Featured Deal of the Day
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deal of the Day 🔥',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${_dealProducts.length} items',
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 4. Deals Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _dealProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.62,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                        ),
                    itemBuilder: (context, index) {
                      final product = _dealProducts[index];
                      final isFav = _wishlist.contains(product.id);

                      return _DealCard(
                        product: product.copyWith(isFavorite: isFav),
                        onTap: () => _openProduct(product),
                        onFavoriteTap: () => _wishlist.toggle(product.id),
                        onAddToCart: () => _addToCart(product),
                      );
                    },
                  ),
                ),

                // Generous bottom spacing for floating glassmorphic nav bar
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  const _TimeBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Color(0xFFDC2626),
          fontSize: 13,
          fontWeight: FontWeight.w800,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

class _DealCard extends StatelessWidget {
  final HomeProduct product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCart;

  const _DealCard({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Preview with Discount & Favorite Badge
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : product.cardBackground,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(17),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        product.fallbackIcon,
                        size: 44,
                        color: AppColors.primary.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  // Discount Pill
                  if (product.discountTag != null)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.discountTag!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  // Favorite Heart
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: onFavoriteTap,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.black.withValues(alpha: 0.6)
                              : Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: product.isFavorite
                              ? const Color(0xFFEF4444)
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Card Body
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      height: 1.25,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Price Row
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                      if (product.originalPrice != null) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            formatPrice(product.originalPrice!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                              color: isDark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Add to Cart Button
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(LucideIcons.shoppingBag, size: 13),
                          SizedBox(width: 6),
                          Text(
                            'Claim Deal',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
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
