import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/empty_state/empty_state.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../cart/screens/cart_screen.dart';
import '../../home/components/home_product_card.dart';
import '../../home/data/home_mock_data.dart';
import '../../products/screens/product_detail_screen.dart';
import '../../wishlist/controllers/wishlist_controller.dart';
import '../components/category_grid_card.dart';
import '../data/category_data.dart';

/// Interactive Categories screen for ShopPanda.
///
/// Provides two intuitive ways to browse:
/// 1. Visual Category Grid: Big, informative department cards with subcategory previews.
/// 2. Category Explorer: Split layout with a left sidebar rail and right subcategories & product feed.
class CategoriesScreen extends StatefulWidget {
  final String? initialCategoryId;

  const CategoriesScreen({super.key, this.initialCategoryId});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  late String _selectedCategoryId;
  String _selectedSubcategory = '';
  int _viewModeIndex = 0; // 0 = Visual Grid, 1 = Category Explorer
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final _cart = CartController.instance;
  final _wishlist = WishlistController.instance;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId =
        widget.initialCategoryId ?? allCategoryDetails.first.id;
    // If an initial category was explicitly requested, jump straight into Explorer mode
    if (widget.initialCategoryId != null) {
      _viewModeIndex = 1;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CategoryDetails get _currentCategory {
    return allCategoryDetails.firstWhere(
      (c) => c.id == _selectedCategoryId,
      orElse: () => allCategoryDetails.first,
    );
  }

  List<CategoryDetails> get _filteredCategories {
    if (_searchQuery.trim().isEmpty) return allCategoryDetails;
    final query = _searchQuery.trim().toLowerCase();
    return allCategoryDetails.where((c) {
      final matchesTitle = c.title.toLowerCase().contains(query);
      final matchesSubtitle = c.subtitle.toLowerCase().contains(query);
      final matchesSubcategories = c.subcategories.any(
        (sub) => sub.toLowerCase().contains(query),
      );
      return matchesTitle || matchesSubtitle || matchesSubcategories;
    }).toList();
  }

  List<HomeProduct> get _currentProducts {
    final categoryId = _selectedCategoryId.toLowerCase();

    var products = categoryExpandedProducts.where((p) {
      final cat = p.category.toLowerCase();
      if (categoryId == 'all') return true;
      if (categoryId == 'fashion') {
        return cat == 'fashion' || cat == 'clothes' || cat == 'clothing';
      }
      return cat == categoryId;
    }).toList();

    // If a subcategory filter is chosen (and not 'All ...')
    if (_selectedSubcategory.isNotEmpty &&
        !_selectedSubcategory.startsWith('All ')) {
      final sub = _selectedSubcategory.toLowerCase();
      final filtered = products
          .where((p) => p.name.toLowerCase().contains(sub))
          .toList();
      if (filtered.isNotEmpty) {
        products = filtered;
      }
    }

    // Apply search filter if query is present
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.trim().toLowerCase();
      products = products
          .where(
            (p) =>
                p.name.toLowerCase().contains(q) ||
                p.category.toLowerCase().contains(q),
          )
          .toList();
    }

    return products;
  }

  void _onCategoryTapped(CategoryDetails cat) {
    setState(() {
      _selectedCategoryId = cat.id;
      _selectedSubcategory = cat.subcategories.first;
      _viewModeIndex = 1; // Switch to explorer view
    });
  }

  void _openProduct(HomeProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
    );
  }

  void _addToCart(HomeProduct product) {
    _cart.add(product);
    showAppToast(context, 'Added "${product.name}" to cart 🐼');
  }

  @override
  Widget build(BuildContext context) {
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.category_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Browse all departments',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.sentiment_satisfied_alt_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Cart shortcut button with badge
          ListenableBuilder(
            listenable: _cart,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.shoppingBag, size: 22),
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CartScreen()),
                      );
                    },
                  ),
                  if (_cart.totalCount > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_cart.totalCount}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Search Bar & Mode Switcher Row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Column(
                children: [
                  // Search Bar
                  Container(
                    height: 48,
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
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchQuery = val),
                      style: TextStyle(
                        fontSize: 14.5,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search categories or products...',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textSecondary,
                          size: 21,
                        ),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.close_rounded, size: 18),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() => _searchQuery = '');
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // View Switcher (Overview vs Explorer)
                  Container(
                    height: 42,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ViewTabButton(
                            icon: Icons.grid_view_rounded,
                            label: 'All Categories',
                            isSelected: _viewModeIndex == 0,
                            onTap: () => setState(() => _viewModeIndex = 0),
                          ),
                        ),
                        Expanded(
                          child: _ViewTabButton(
                            icon: Icons.view_sidebar_rounded,
                            label: 'Category Explorer',
                            isSelected: _viewModeIndex == 1,
                            onTap: () => setState(() => _viewModeIndex = 1),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Main Content
            Expanded(
              child: _filteredCategories.isEmpty
                  ? Center(
                      child: PandaEmptyState(
                        title: 'No categories found 🐼',
                        message:
                            'We could not find any category matching "$_searchQuery". Try another keyword!',
                        buttonText: 'Clear Search',
                        onButtonTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ),
                    )
                  : (_viewModeIndex == 0
                        ? _buildGridView(isDark)
                        : _buildExplorerView(isDark)),
            ),
          ],
        ),
      ),
    );
  }

  /// 1. Visual Category Grid View
  Widget _buildGridView(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Explore Departments (${_filteredCategories.length})',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Tap to explore items',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.69,
            ),
            itemBuilder: (context, index) {
              final cat = _filteredCategories[index];
              return CategoryGridCard(
                category: cat,
                onTap: () => _onCategoryTapped(cat),
              );
            },
          ),
        ],
      ),
    );
  }

  /// 2. Split Explorer View (Left rail navigation + right products)
  Widget _buildExplorerView(bool isDark) {
    final currentCat = _currentCategory;
    final products = _currentProducts;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Vertical Rail Navigation
        Container(
          width: 88,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : const Color(0xFFF8FAFC),
            border: Border(
              right: BorderSide(
                color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
                width: 1,
              ),
            ),
          ),
          child: ListView.builder(
            itemCount: allCategoryDetails.length,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemBuilder: (context, index) {
              final cat = allCategoryDetails[index];
              final isSelected = cat.id == _selectedCategoryId;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategoryId = cat.id;
                    _selectedSubcategory = cat.subcategories.first;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (isDark ? AppColors.darkCard : Colors.white)
                        : Colors.transparent,
                    border: Border(
                      left: BorderSide(
                        color: isSelected
                            ? cat.accentColor
                            : Colors.transparent,
                        width: 3.5,
                      ),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? cat.accentColor.withValues(alpha: 0.15)
                              : (isDark
                                    ? AppColors.darkBackground
                                    : const Color(0xFFF1F5F9)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          cat.icon,
                          size: 21,
                          color: isSelected
                              ? cat.accentColor
                              : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.textSecondary),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat.title.split(' ').first,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? (isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary)
                              : (isDark
                                    ? AppColors.darkTextMuted
                                    : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // Right Content: Department Hero Banner + Subcategory Chips + Product Grid
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 110),
            children: [
              // Hero Department Gradient Card
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      currentCat.accentColor,
                      currentCat.accentColor.withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: currentCat.accentColor.withValues(alpha: 0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              currentCat.badge ?? 'FEATURED',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentCat.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            currentCat.heroBannerText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        currentCat.icon,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Subcategories Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: currentCat.subcategories.map((sub) {
                    final isSubSelected = _selectedSubcategory.isEmpty
                        ? sub == currentCat.subcategories.first
                        : _selectedSubcategory == sub;

                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () {
                          setState(() => _selectedSubcategory = sub);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: isSubSelected
                                ? currentCat.accentColor
                                : (isDark ? AppColors.darkCard : Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSubSelected
                                  ? currentCat.accentColor
                                  : (isDark
                                        ? AppColors.darkBorder
                                        : const Color(0xFFE2E8F0)),
                            ),
                          ),
                          child: Text(
                            sub,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: isSubSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSubSelected
                                  ? Colors.white
                                  : (isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 14),

              // Subcategory section header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedSubcategory.isEmpty
                          ? currentCat.subcategories.first
                          : _selectedSubcategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      '${products.length} items',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Product Grid for this Category
              if (products.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 44,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.textMuted,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'No products found in this subcategory',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isFav = _wishlist.contains(product.id);

                    return HomeProductCard(
                      product: product.copyWith(isFavorite: isFav),
                      onTap: () => _openProduct(product),
                      onFavoriteTap: () => _wishlist.toggle(product.id),
                      onAddToCart: () => _addToCart(product),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Segmented tab button for switching view modes.
class _ViewTabButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewTabButton({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unselectedColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 17,
              color: isSelected ? Colors.white : unselectedColor,
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? Colors.white : unselectedColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
