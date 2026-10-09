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
/// discount filter chips, visually dominant Deal of the Day card,
/// product grid with urgency cues, and interactive Add to Cart & Wishlist actions.
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
    final timeParts = _formatTime(_secondsRemaining).split(':');
    final products = _dealProducts;
    final hasDeals = products.isNotEmpty;
    final heroProduct = hasDeals ? products.first : null;
    final gridProducts = hasDeals && products.length > 1
        ? products.sublist(1)
        : <HomeProduct>[];

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
                color: const Color(0xFFEF4444).withValues(alpha: 0.12),
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
                      letterSpacing: -0.3,
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

                // 1. Flash Sale Countdown Hero Banner (ShopPanda Royal Blue Gradient)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF0F172A), // Midnight navy
                          Color(0xFF1E3A8A), // Royal navy
                          Color(0xFF2563EB), // ShopPanda Royal Blue
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.28),
                          blurRadius: 18,
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
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1,
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: Color(0xFFFBBF24), // Gold bolt
                                      size: 15,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'FLASH SALE',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: 0.6,
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
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.3,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Limited quantity available!',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Countdown Digits with Hours, Minutes, Seconds labels
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'ENDS IN',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _TimeBox(value: timeParts[0], label: 'HRS'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 14,
                                    left: 4,
                                    right: 4,
                                  ),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _TimeBox(value: timeParts[1], label: 'MIN'),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 14,
                                    left: 4,
                                    right: 4,
                                  ),
                                  child: Text(
                                    ':',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                _TimeBox(value: timeParts[2], label: 'SEC'),
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

                // 3. Featured Deal of the Day Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deal of the Day 🔥',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.darkCard
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Text(
                          '${products.length} items',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Visually Dominant Deal of the Day Card
                if (heroProduct != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _FeaturedDealCard(
                      product: heroProduct.copyWith(
                        isFavorite: _wishlist.contains(heroProduct.id),
                      ),
                      onTap: () => _openProduct(heroProduct),
                      onFavoriteTap: () => _wishlist.toggle(heroProduct.id),
                      onAddToCart: () => _addToCart(heroProduct),
                    ),
                  ),

                // 4. More Hot Deals Section & Grid
                if (gridProducts.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          'More Hot Deals',
                          style: TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${gridProducts.length} deals',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: gridProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                      itemBuilder: (context, index) {
                        final product = gridProducts[index];
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
                ],

                if (!hasDeals)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 40,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.local_offer_outlined,
                            size: 56,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No deals found in this category',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () =>
                                setState(() => _selectedFilter = 'all'),
                            child: const Text('Show All Deals'),
                          ),
                        ],
                      ),
                    ),
                  ),

                // Generous bottom spacing for floating glassmorphic nav bar
                const SizedBox(height: 110),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Structured countdown digit box communicating Hours, Minutes, Seconds.
class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 36,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF1E3A8A), // Royal navy digit
              fontSize: 14,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 8.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// Filter chip with obvious selected and unselected states.
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
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: isSelected ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: isSelected ? 10 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}

/// Visually dominant hero deal card for "Deal of the Day".
class _FeaturedDealCard extends StatelessWidget {
  final HomeProduct product;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback onAddToCart;

  const _FeaturedDealCard({
    required this.product,
    required this.onTap,
    required this.onFavoriteTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final savings = product.originalPrice != null
        ? (product.originalPrice! - product.price)
        : null;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Tag & Favorite Heart
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 14,
                          color: Color(0xFFD97706),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'FEATURED DEAL',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: Color(0xFFD97706),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: onFavoriteTap,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        product.isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: product.isFavorite
                            ? const Color(0xFFEF4444)
                            : AppColors.textMuted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Studio Image Showcase Area
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF0F172A)
                      : product.cardBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Icon(
                        product.fallbackIcon,
                        size: 64,
                        color: AppColors.primary.withValues(alpha: 0.65),
                      ),
                    ),
                    // Eye-catching Discount Badge
                    if (product.discountTag != null)
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFFEF4444,
                                ).withValues(alpha: 0.35),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            product.discountTag!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Category & Title
              Text(
                product.category.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  height: 1.25,
                  letterSpacing: -0.2,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),

              // Rating Row
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFF59E0B),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${product.rating}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${product.reviewsCount} reviews)',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  if (savings != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Save ${formatPrice(savings)}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF059669),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Urgency Stock Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 13,
                            color: Color(0xFFD97706),
                          ),
                          SizedBox(width: 2),
                          Text(
                            'Almost Gone!',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Only 6 left in stock',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.82,
                      minHeight: 6,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Price Hierarchy & Claim Deal Action Button
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.3,
                          color: AppColors.primary,
                        ),
                      ),
                      if (product.originalPrice != null)
                        Text(
                          formatPrice(product.originalPrice!),
                          style: TextStyle(
                            fontSize: 13,
                            decoration: TextDecoration.lineThrough,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.textMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: onAddToCart,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(LucideIcons.shoppingBag, size: 16),
                            SizedBox(width: 8),
                            Text(
                              'Claim Deal',
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Deal Card for Grid View with Urgency cues, discounts, and Claim button.
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
                  // Micro Urgency Tag at bottom of image
                  Positioned(
                    bottom: 6,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.black.withValues(alpha: 0.7)
                            : Colors.white.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.bolt_rounded,
                            size: 10,
                            color: Color(0xFFD97706),
                          ),
                          Text(
                            'Few left',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ],
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
                  const SizedBox(height: 4),
                  // Rating & Reviews
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '(${product.reviewsCount})',
                        style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Price Row
                  Row(
                    children: [
                      Text(
                        formatPrice(product.price),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
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
                    height: 33,
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
