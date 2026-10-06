import 'package:flutter/material.dart';
import '../../../components/shimmer/shimmer_loading.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/storage/secure_storage.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../categories/screens/categories_screen.dart';
import '../../deals/screens/deals_screen.dart';
import '../../products/screens/product_detail_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../components/home_bottom_nav_bar.dart';
import '../components/home_categories_bar.dart';
import '../components/home_header.dart';
import '../components/home_product_card.dart';
import '../components/home_promo_carousel.dart';
import '../components/home_search_bar.dart';
import '../data/home_mock_data.dart';

/// Clean, modern, and easily customizable Home Screen for ShopPanda.
///
/// 💡 EASY TO CUSTOMIZE:
/// - Modify mock data directly in `lib/features/home/data/home_mock_data.dart`
/// - Change colors in `lib/core/constants/colors.dart`
/// - Customize individual widgets inside `lib/features/home/components/`
class HomeScreen extends StatefulWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onCartTap;
  final ValueChanged<HomeProduct>? onProductTap;
  final VoidCallback? onCategoriesTap;
  final bool showBottomNav;

  const HomeScreen({
    super.key,
    this.onNotificationTap,
    this.onCartTap,
    this.onCategoriesTap,
    this.onProductTap,
    this.showBottomNav = true,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Loading & Navigation state
  bool _isLoading = false;
  int _currentNavIndex = 0;
  int _cartCount = 2;

  // Filter states
  String _selectedCategoryId = 'all';
  String _searchQuery = '';
  String _sortBy = 'popular'; // 'popular', 'price_low', 'price_high', 'rating'

  // Local favorite IDs tracked along with wishlist
  final Set<String> _favoriteProductIds = {};

  // Cart and wishlist controllers
  final _cart = CartController.instance;
  final _wishlist = WishlistController.instance;

  // Filter products by selected category, search text, and sorting
  List<HomeProduct> get _filteredProducts {
    final list = mockProducts.where((item) {
      final matchesCategory =
          _selectedCategoryId == 'all' ||
          item.category.toLowerCase() == _selectedCategoryId.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
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

  void _openProduct(HomeProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  void _openProfile() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
  }

  void _openDeals() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const DealsScreen()));
  }

  void _openCategories([String? categoryId]) {
    if (widget.onCategoriesTap != null && categoryId == null) {
      widget.onCategoriesTap!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CategoriesScreen(initialCategoryId: categoryId),
        ),
      );
    }
  }

  void _openCart() {
    if (widget.onCartTap != null) {
      widget.onCartTap!();
    } else {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const CartScreen()));
    }
  }

  void _toggleFavorite(String productId) {
    setState(() {
      if (_favoriteProductIds.contains(productId)) {
        _favoriteProductIds.remove(productId);
      } else {
        _favoriteProductIds.add(productId);
      }
    });
    _wishlist.toggle(productId);
  }

  void _addToCart(HomeProduct product) {
    _cart.add(product);
    setState(() {
      _cartCount++;
    });
    showAppToast(context, 'Added "${product.name}" to cart!');
  }

  void _showFilterSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter & Sort',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Sort Products By',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _ChoicePill(
                      label: 'Popular',
                      isSelected: _sortBy == 'popular',
                      onTap: () {
                        setModalState(() => _sortBy = 'popular');
                        setState(() {});
                      },
                    ),
                    _ChoicePill(
                      label: 'Price: Low to High',
                      isSelected: _sortBy == 'price_low',
                      onTap: () {
                        setModalState(() => _sortBy = 'price_low');
                        setState(() {});
                      },
                    ),
                    _ChoicePill(
                      label: 'Price: High to Low',
                      isSelected: _sortBy == 'price_high',
                      onTap: () {
                        setModalState(() => _sortBy = 'price_high');
                        setState(() {});
                      },
                    ),
                    _ChoicePill(
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
                    backgroundColor: AppColors.homePrimary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Apply Filter',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
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
      backgroundColor: isDark ? AppColors.darkSurface : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
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
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _NotificationItem(
                icon: Icons.local_offer_rounded,
                title: 'Autumn Sale is Live! 🍂',
                time: '10 mins ago',
                desc: 'Enjoy up to 50% discount on all new clothing.',
              ),
              _NotificationItem(
                icon: Icons.check_circle_rounded,
                title: 'Order Status Update',
                time: '2 hours ago',
                desc: 'Your recent order #SP1001 is being prepared.',
              ),
              _NotificationItem(
                icon: Icons.card_giftcard_rounded,
                title: 'Coupon Gift 🎁',
                time: 'Yesterday',
                desc: 'Use coupon PANDA10 for \$10 off at checkout.',
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
      extendBody: true,
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      body: ListenableBuilder(
        listenable: Listenable.merge([_cart, _wishlist]),
        builder: (context, _) => SafeArea(
          child: RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async {
              setState(() => _isLoading = true);
              await Future.delayed(const Duration(milliseconds: 600));
              if (!mounted) return;
              setState(() {
                _isLoading = false;
                _selectedCategoryId = 'all';
                _searchQuery = '';
                _sortBy = 'popular';
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Header (Greeting, Location, Notification & Cart icons)
                  HomeHeader(
                    userName:
                        SessionStorage.currentUser?.name.split(' ').first ??
                        'Alex',
                    location: 'Phnom Penh, Cambodia',
                    cartItemCount: _cartCount,
                    unreadNotifications: 5,
                    onNotificationTap:
                        widget.onNotificationTap ?? _showNotificationsSheet,
                    onCartTap: _openCart,
                    onProfileTap: _openProfile,
                  ),

                  // 2. Search & Filter Bar
                  HomeSearchBar(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    onFilterTap: _showFilterSheet,
                  ),
                  const SizedBox(height: 12),

                  // 3. Hero Promo Banners Carousel
                  if (_isLoading)
                    const PromoBannerSkeleton()
                  else
                    HomePromoCarousel(
                      banners: mockPromoBanners,
                      onBannerTap: (banner) {
                        if (banner.id == 'b1') {
                          setState(() => _selectedCategoryId = 'fashion');
                          showAppToast(
                            context,
                            '🍂 Autumn Sale applied: showing Fashion',
                          );
                        } else if (banner.id == 'b2') {
                          showAppToast(
                            context,
                            '🎁 Coupon code PANDA10 ready to use in your cart!',
                          );
                        } else {
                          showAppToast(
                            context,
                            '🏷️ ${banner.title}: ${banner.subtitle}',
                          );
                        }
                      },
                    ),
                  const SizedBox(height: 20),

                  // 4. Categories Section
                  _SectionTitle(
                    title: 'Categories',
                    actionText: 'See All',
                    onActionTap: () => _openCategories(
                      _selectedCategoryId == 'all' ? null : _selectedCategoryId,
                    ),
                  ),
                  const SizedBox(height: 12),
                  HomeCategoriesBar(
                    categories: mockCategories,
                    selectedCategoryId: _selectedCategoryId,
                    onSelectCategory: (id) =>
                        setState(() => _selectedCategoryId = id),
                  ),
                  const SizedBox(height: 24),

                  // 5. Flash Sale / Special Offers Banner
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: _openDeals,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? const [Color(0xFF1E293B), Color(0xFF0F172A)]
                                : const [Color(0xFF1E3A8A), Color(0xFF2563EB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.primary.withValues(
                              alpha: isDark ? 0.4 : 0.25,
                            ),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(
                                alpha: isDark ? 0.2 : 0.18,
                              ),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.bolt_rounded,
                                color: Color(0xFFFBBF24),
                                size: 26,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Flash Sale Ends In',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Fresh deals up to 70% off',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const _CountdownBox(text: '02'),
                            const Text(
                              ' : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const _CountdownBox(text: '45'),
                            const Text(
                              ' : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const _CountdownBox(text: '12'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. Popular Products Grid Header
                  _SectionTitle(
                    title: _selectedCategoryId == 'all'
                        ? 'Popular Products'
                        : '${_selectedCategoryId[0].toUpperCase()}${_selectedCategoryId.substring(1)} Products',
                    actionText: 'See All',
                    onActionTap: () =>
                        setState(() => _selectedCategoryId = 'all'),
                  ),
                  const SizedBox(height: 12),

                  // 7. Products Grid
                  if (_isLoading)
                    const ProductGridSkeleton(itemCount: 4)
                  else if (_filteredProducts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.textMuted,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No products found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.68,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          final isFav =
                              _favoriteProductIds.contains(product.id) ||
                              _wishlist.contains(product.id) ||
                              product.isFavorite;
                          return HomeProductCard(
                            product: product.copyWith(isFavorite: isFav),
                            onTap: () {
                              if (widget.onProductTap != null) {
                                widget.onProductTap!(product);
                              } else {
                                _openProduct(product);
                              }
                            },
                            onFavoriteTap: () => _toggleFavorite(product.id),
                            onAddToCart: () => _addToCart(product),
                          );
                        },
                      ),
                    ),

                  // Generous bottom spacing for floating frosted glass nav bar
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),

      // 8. Bottom Navigation Bar
      bottomNavigationBar: widget.showBottomNav
          ? HomeBottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() => _currentNavIndex = index);
              },
            )
          : null,
    );
  }
}

class _ChoicePill extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ChoicePill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.homePrimary : AppColors.homeSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.homePrimary : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String desc;

  const _NotificationItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.desc,
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
              color: AppColors.homePrimaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.homePrimary),
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
                        fontWeight: FontWeight.bold,
                        fontSize: 13.5,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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

/// Small reusable countdown number box.
class _CountdownBox extends StatelessWidget {
  final String text;

  const _CountdownBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11.5,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Header for a content section with title and "See All" button.
class _SectionTitle extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;

  const _SectionTitle({
    required this.title,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),
          InkWell(
            onTap: onActionTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Row(
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
