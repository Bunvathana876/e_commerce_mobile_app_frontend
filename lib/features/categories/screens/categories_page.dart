import 'package:flutter/material.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../deals/screens/deals_screen.dart';
import '../../orders/screens/order_history_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../../models/product.dart';
import '../../../screens/home_screen.dart';
import '../data/categories_data.dart';
import '../models/category.dart';
import '../widgets/app_bottom_navigation.dart';
import '../widgets/app_header.dart';
import '../widgets/category_detail_sheet.dart';
import '../widgets/category_grid.dart';
import '../widgets/filter_chips.dart';
import '../widgets/flash_sale_banner.dart';
import '../widgets/popular_categories.dart';
import '../widgets/search_categories.dart';

/// Polished Flutter shopping categories page inspired by the v0 preview.
///
/// Features:
/// - Responsive layout: Full screen on mobile, max-width 900 centered container on tablet/desktop.
/// - Light modern background (#F8FAFC) with white content card surface.
/// - Vibrant royal blue primary styling.
/// - Rounded cards, subtle borders, accessible contrast.
/// - Real-time category and product search filtering with reset on empty state.
/// - Filter chips: All, Women, Men, Kids, Home, Tech.
/// - Animated flash-sale banner with countdown timer and "Shop now" scroll target.
/// - Popular categories horizontal carousel with scale-animated favorite toggles.
/// - Shop by category section with Grid/List view toggle, item counts, badges, and fade/slide animations.
/// - Modal bottom sheet with category hero preview, description, subcategories, best-sellers, and add-to-cart buttons.
/// - Dynamic cart badge and bottom navigation bar state switching.
class CategoriesPage extends StatefulWidget {
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final ValueChanged<Product>? onProductTap;
  final bool showBottomNav;
  final ValueChanged<int>? onTabSelected;

  const CategoriesPage({
    super.key,
    this.onNotificationTap,
    this.onProfileTap,
    this.onProductTap,
    this.showBottomNav = true,
    this.onTabSelected,
  });

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _gridSectionKey = GlobalKey();

  final CartController _cart = CartController.instance;

  // Filter & Search states
  String _searchQuery = '';
  String _selectedFilterChip = 'All';
  bool _isGridView = true;
  int _selectedNavIndex = 1; // 1 = Categories tab

  // Category data state (allows toggling favorites)
  late List<Category> _categories;

  @override
  void initState() {
    super.initState();
    _categories = List.from(sampleCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Categories filtered by both text query and filter chip
  List<Category> get _filteredCategories {
    var list = _categories;

    // Filter by chip group (e.g. Women, Men, Kids, Home, Tech, All)
    if (_selectedFilterChip.toLowerCase() != 'all') {
      final chipLower = _selectedFilterChip.toLowerCase();
      list = list.where((cat) {
        return cat.filterGroups.any(
              (group) => group.toLowerCase() == chipLower,
            ) ||
            cat.name.toLowerCase().contains(chipLower);
      }).toList();
    }

    // Filter by search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      list = list.where((cat) {
        final matchesName = cat.name.toLowerCase().contains(q);
        final matchesDesc = cat.description.toLowerCase().contains(q);
        final matchesSub = cat.subcategories.any(
          (sub) => sub.toLowerCase().contains(q),
        );
        return matchesName || matchesDesc || matchesSub;
      }).toList();
    }

    return list;
  }

  /// Popular items (fashion, shoes, bags, electronics)
  List<Category> get _popularCategories {
    return _categories
        .where(
          (c) => [
            'cat_fashion',
            'cat_shoes',
            'cat_bags',
            'cat_electronics',
          ].contains(c.id),
        )
        .toList();
  }

  void _onToggleFavorite(Category category) {
    setState(() {
      final index = _categories.indexWhere((c) => c.id == category.id);
      if (index != -1) {
        final current = _categories[index];
        _categories[index] = current.copyWith(isFavorite: !current.isFavorite);
      }
    });

    final updated = _categories.firstWhere((c) => c.id == category.id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated.isFavorite
              ? 'Added ${updated.name} to favorites ❤️'
              : 'Removed ${updated.name} from favorites',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _scrollToGrid() {
    final ctx = _gridSectionKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _scrollController.animateTo(
        380.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  void _openCategoryDetail(Category category) {
    CategoryDetailSheet.show(
      context: context,
      category: category,
      onAddToCart: (product) {
        _cart.add(product.toHomeProduct());
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added "${product.name}" to cart! 🛍️'),
            backgroundColor: const Color(0xFF1E3A8A),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      onProductTap: widget.onProductTap,
    );
  }

  void _showNotificationDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.notifications_active_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text('Notifications'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🎉 Mid-Season Flash Sale is Live! Up to 60% off fashion & shoes.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
            SizedBox(height: 12),
            Text(
              '📦 Your order #SP8920 is out for delivery.',
              style: TextStyle(fontSize: 14, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleNavTap(int index) {
    setState(() => _selectedNavIndex = index);
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(index);
      return;
    }
    if (index == 0) {
      // Home
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(showBottomNav: true),
        ),
      );
    } else if (index == 2) {
      // Deals
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => DealsScreen(
            onStartShopping: () => Navigator.of(context).pop(),
            onViewCart: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
          ),
        ),
      );
    } else if (index == 3) {
      // Cart
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const CartScreen()),
      );
    } else if (index == 4) {
      // Profile
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfileScreen(
            onOpenOrders: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const OrderHistoryScreen(),
              ),
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 900 : double.infinity,
            ),
            margin: isDesktop
                ? const EdgeInsets.symmetric(vertical: 24, horizontal: 20)
                : EdgeInsets.zero,
            decoration: isDesktop
                ? BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  )
                : null,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isDesktop ? 28 : 0),
              child: Column(
                children: [
                  // Scrollable Body Content
                  Expanded(
                    child: CustomScrollView(
                      controller: _scrollController,
                      slivers: [
                        // 1. App Header
                        SliverToBoxAdapter(
                          child: AppHeader(
                            greeting: 'Good morning, Alex',
                            title: 'Find what you love',
                            notificationCount: 3,
                            onNotificationTap: widget.onNotificationTap ??
                                _showNotificationDialog,
                            onProfileTap: widget.onProfileTap ??
                                () => _handleNavTap(4),
                          ),
                        ),

                        // 2. Search Bar
                        SliverToBoxAdapter(
                          child: SearchCategories(
                            controller: _searchController,
                            onChanged: (val) =>
                                setState(() => _searchQuery = val),
                            onClear: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                        ),

                        // 3. Filter Chips
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: CategoryFilterChips(
                              selectedChip: _selectedFilterChip,
                              onSelected: (chip) =>
                                  setState(() => _selectedFilterChip = chip),
                            ),
                          ),
                        ),

                        // 4. Flash Sale Banner
                        SliverToBoxAdapter(
                          child: FlashSaleBanner(
                            onShopNow: _scrollToGrid,
                          ),
                        ),

                        // 5. Popular Categories
                        SliverToBoxAdapter(
                          child: PopularCategories(
                            categories: _popularCategories,
                            onCategoryTap: _openCategoryDetail,
                            onToggleFavorite: _onToggleFavorite,
                          ),
                        ),

                        const SliverToBoxAdapter(
                          child: SizedBox(height: 18),
                        ),

                        // 6. Shop by Category (with GlobalKey for scroll target)
                        SliverToBoxAdapter(
                          key: _gridSectionKey,
                          child: CategoryGrid(
                            categories: _filteredCategories,
                            isGridView: _isGridView,
                            onToggleView: () =>
                                setState(() => _isGridView = !_isGridView),
                            onCategoryTap: _openCategoryDetail,
                          ),
                        ),

                        // Bottom padding for scroll clearance
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 100),
                        ),
                      ],
                    ),
                  ),

                  // 7. App Bottom Navigation
                  if (widget.showBottomNav)
                    ListenableBuilder(
                      listenable: _cart,
                      builder: (context, _) {
                        return AppBottomNavigation(
                          currentIndex: _selectedNavIndex,
                          cartCount: _cart.totalCount,
                          onTap: _handleNavTap,
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
