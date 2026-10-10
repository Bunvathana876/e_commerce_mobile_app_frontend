import 'package:flutter/material.dart';
import '../data/sample_products.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/category_selector.dart';
import '../widgets/flash_sale_card.dart';
import '../widgets/home_header.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/weekend_edit_banner.dart';

/// Clean, modern mobile shopping home screen.
/// Designed for responsive viewports (primary target 347x657 up to larger tablets).
class HomeScreen extends StatefulWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onBagTap;
  final VoidCallback? onCartTap;
  final VoidCallback? onCategoriesTap;
  final ValueChanged<Product>? onProductTap;
  final bool showBottomNav;

  const HomeScreen({
    super.key,
    this.onNotificationTap,
    this.onBagTap,
    this.onCartTap,
    this.onCategoriesTap,
    this.onProductTap,
    this.showBottomNav = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Navigation & Cart state
  int _currentNavIndex = 0;
  int _bagCount = 2;
  final int _notificationCount = 3;

  // Filter & Search state
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String _sortBy = 'popular'; // 'popular', 'price_low', 'price_high', 'rating'

  // Products list (local state for interactive favorites & adding to cart)
  late List<Product> _products;

  @override
  void initState() {
    super.initState();
    _products = List.from(sampleProducts);
  }

  List<Product> get _filteredProducts {
    final list = _products.where((p) {
      final matchesCategory =
          _selectedCategoryId == 'all' ||
          p.category.toLowerCase() == _selectedCategoryId.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    switch (_sortBy) {
      case 'price_low':
        list.sort((a, b) => a.price.compareTo(b.price));
      case 'price_high':
        list.sort((a, b) => b.price.compareTo(a.price));
      case 'rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      default:
        break;
    }

    return list;
  }

  void _toggleFavorite(String productId) {
    setState(() {
      _products = _products.map((p) {
        if (p.id == productId) {
          final updated = !p.isFavorite;
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                updated
                    ? 'Saved "${p.name}" to favorites'
                    : 'Removed "${p.name}" from favorites',
              ),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return p.copyWith(isFavorite: updated);
        }
        return p;
      }).toList();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      _bagCount++;
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added "${product.name}" to bag!'),
        action: SnackBarAction(
          label: 'View Bag',
          textColor: Colors.white,
          onPressed: () => (widget.onCartTap ?? widget.onBagTap)?.call(),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _claimCoupon() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Coupon "WEEKEND30" applied successfully!'),
        backgroundColor: AppTheme.primaryDark,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showFilterModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Filter & Sort',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close_rounded,
                          color: isDark ? Colors.white70 : AppTheme.textPrimary,
                        ),
                        tooltip: 'Close filter dialog',
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Sort Products By',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _FilterChoiceChip(
                        label: 'Popular',
                        isSelected: _sortBy == 'popular',
                        onTap: () {
                          setModalState(() => _sortBy = 'popular');
                          setState(() {});
                        },
                      ),
                      _FilterChoiceChip(
                        label: 'Price: Low to High',
                        isSelected: _sortBy == 'price_low',
                        onTap: () {
                          setModalState(() => _sortBy = 'price_low');
                          setState(() {});
                        },
                      ),
                      _FilterChoiceChip(
                        label: 'Price: High to Low',
                        isSelected: _sortBy == 'price_high',
                        onTap: () {
                          setModalState(() => _sortBy = 'price_high');
                          setState(() {});
                        },
                      ),
                      _FilterChoiceChip(
                        label: 'Top Rated',
                        isSelected: _sortBy == 'rating',
                        onTap: () {
                          setModalState(() => _sortBy = 'rating');
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      ),
                    ),
                    child: const Text(
                      'Apply Filters',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showNotificationsSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    tooltip: 'Close notifications',
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const _NotificationTile(
                icon: Icons.local_offer_rounded,
                title: 'Weekend Edit is Live! 🎉',
                subtitle: 'Claim your 30% discount coupon today.',
                time: 'Just now',
              ),
              const _NotificationTile(
                icon: Icons.check_circle_rounded,
                title: 'Order Status Update',
                subtitle: 'Your package #SP2026 has been shipped.',
                time: '2 hrs ago',
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(context),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Header: Avatar, “Welcome, Lee”, Location, Notification, Bag
                    HomeHeaderWidget(
                      userName: 'Lee',
                      location: 'Phnom Penh, Cambodia',
                      notificationCount: _notificationCount,
                      bagCount: _bagCount,
                      onNotificationTap:
                          widget.onNotificationTap ?? _showNotificationsSheet,
                      onBagTap: widget.onCartTap ?? widget.onBagTap,
                    ),

                    // 2. Search Row: Search field + Filter button beside it
                    CustomSearchBar(
                      onChanged: (val) => setState(() => _searchQuery = val),
                      onFilterTap: _showFilterModal,
                    ),
                    const SizedBox(height: AppTheme.spacingXs),

                    // 3. Promo Card: Weekend Edit Banner with floating animation
                    WeekendEditBanner(onClaimCoupon: _claimCoupon),
                    const SizedBox(height: AppTheme.spacingMd),

                    // 4. “Shop by category” horizontal list
                    CategorySelector(
                      selectedCategoryId: _selectedCategoryId,
                      onCategorySelected: (catId) =>
                          setState(() => _selectedCategoryId = catId),
                      onSeeAll: widget.onCategoriesTap,
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // 5. Flash Sale Card with countdown timer styling
                    FlashSaleCard(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Flash Sale deals opened!'),
                            duration: Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppTheme.spacingLg),

                    // 6. “Made for you” Product Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingXl,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Made for you',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppTheme.textPrimary,
                              letterSpacing: -0.2,
                            ),
                          ),
                          Semantics(
                            label: 'See all made for you products',
                            button: true,
                            child: InkWell(
                              onTap: () => setState(() {
                                _selectedCategoryId = 'all';
                                _searchQuery = '';
                              }),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSm,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  'See all',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingSm),

                    // 7. Product Grid with responsive 2-column layout
                    if (_filteredProducts.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 36.0),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 40,
                                color: AppTheme.textMuted,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'No products found',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingXl,
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredProducts.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, index) {
                            final product = _filteredProducts[index];
                            return ProductCard(
                              product: product,
                              onTap: () {
                                if (widget.onProductTap != null) {
                                  widget.onProductTap!(product);
                                } else {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Selected "${product.name}"'),
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                }
                              },
                              onFavoriteTap: () => _toggleFavorite(product.id),
                              onAddToCart: () => _addToCart(product),
                            );
                          },
                        ),
                      ),

                    // Content bottom scroll padding
                    SizedBox(
                      height: widget.showBottomNav ? AppTheme.spacingXxl : 110,
                    ),
                  ],
                ),
              ),
            ),

            // Fixed safe-area aware Bottom Navigation Bar
            if (widget.showBottomNav)
              BottomNavigation(
                currentIndex: _currentNavIndex,
                onTap: (index) {
                  setState(() => _currentNavIndex = index);
                  if (index == 1 && widget.onCategoriesTap != null) {
                    widget.onCategoriesTap!();
                  } else if (index == 4 && (widget.onCartTap != null || widget.onBagTap != null)) {
                    (widget.onCartTap ?? widget.onBagTap)!.call();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

class _FilterChoiceChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String time;

  const _NotificationTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryLight,
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, size: 18, color: AppTheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppTheme.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
