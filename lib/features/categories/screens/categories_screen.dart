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

/// Categories Screen matching the reference commercial design.
///
/// Layout:
/// - Top Header: Circular blue icon box, bold "Categories" title, "Find what you love" subtitle, and shopping bag action.
/// - Search Bar: Clean pill container with "Search categories" placeholder.
/// - Popular Section: Horizontal carousel with image cards (Fashion, Shoes, Bags) and "See all →".
/// - Shop by category Section: 2-column grid showing 4 category boxes with photographic preview surfaces.
class CategoriesScreen extends StatefulWidget {
  final String? initialCategoryId;

  const CategoriesScreen({super.key, this.initialCategoryId});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  String? _selectedCategoryId;
  String _selectedSubcategory = '';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final _cart = CartController.instance;
  final _wishlist = WishlistController.instance;

  @override
  void initState() {
    super.initState();
    _selectedCategoryId = widget.initialCategoryId;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  CategoryDetails? get _currentCategory {
    if (_selectedCategoryId == null) return null;
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
    if (_selectedCategoryId == null) return [];
    final categoryId = _selectedCategoryId!.toLowerCase();

    var products = categoryExpandedProducts.where((p) {
      final cat = p.category.toLowerCase();
      if (categoryId == 'all') return true;
      if (categoryId == 'fashion') {
        return cat == 'fashion' || cat == 'clothes' || cat == 'clothing';
      }
      return cat == categoryId;
    }).toList();

    // If a subcategory filter is chosen
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
    final currentCat = _currentCategory;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        leading: currentCat != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                color: isDark
                    ? AppColors.darkTextPrimary
                    : const Color(0xFF0F172A),
                onPressed: () {
                  setState(() {
                    _selectedCategoryId = null;
                    _selectedSubcategory = '';
                  });
                },
              )
            : null,
        title: currentCat != null
            ? Text(
                currentCat.title.split('&').first.trim(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xFF0F172A),
                ),
              )
            : Row(
                children: [
                  // Left circular icon box
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCEBFE),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFBFDBFE),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.grid_view_rounded,
                        color: Color(0xFF2563EB),
                        size: 26,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Categories',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          'Find what you love',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        actions: [
          // Minimalist shopping bag button
          ListenableBuilder(
            listenable: _cart,
            builder: (context, _) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(LucideIcons.shoppingBag, size: 24),
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : const Color(0xFF0F172A),
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
                          color: Color(0xFF2563EB),
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
            // Search Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurface
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : const Color(0xFFE2E8F0),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: TextStyle(
                    fontSize: 15,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search categories',
                    hintStyle: TextStyle(
                      color: isDark
                          ? AppColors.darkTextMuted
                          : const Color(0xFF94A3B8),
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                    ),
                    prefixIcon: Icon(
                      LucideIcons.search,
                      color: isDark
                          ? AppColors.darkTextMuted
                          : const Color(0xFF64748B),
                      size: 20,
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
                      vertical: 14,
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: currentCat != null
                  ? _buildCategoryProductsView(isDark, currentCat)
                  : _buildReferenceCategoriesView(isDark),
            ),
          ],
        ),
      ),
    );
  }

  /// Main view matching reference design:
  /// - Popular horizontal carousel
  /// - Shop by category (4 groups)
  Widget _buildReferenceCategoriesView(bool isDark) {
    if (_filteredCategories.isEmpty) {
      return Center(
        child: PandaEmptyState(
          title: 'No categories found 🐼',
          message: 'Try another keyword!',
          buttonText: 'Clear Search',
          onButtonTap: () {
            _searchController.clear();
            setState(() => _searchQuery = '');
          },
        ),
      );
    }

    // Top 3 categories for Popular horizontal strip
    final popularCategories = allCategoryDetails
        .where((c) => ['fashion', 'shoes', 'bags'].contains(c.id))
        .toList();

    // Exactly 4 categories for "Shop by category"
    final shopByCategories = _searchQuery.isNotEmpty
        ? _filteredCategories
        : _filteredCategories.take(4).toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. "Popular" Header Row
          if (_searchQuery.isEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : const Color(0xFF0F172A),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (popularCategories.isNotEmpty) {
                      _onCategoryTapped(popularCategories.first);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'See all',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        SizedBox(width: 3),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 16,
                          color: Color(0xFF2563EB),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Horizontal Carousel of Popular Cards
            SizedBox(
              height: 182,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: popularCategories.length,
                separatorBuilder: (_, _) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final cat = popularCategories[index];
                  return _PopularPhotoCard(
                    category: cat,
                    onTap: () => _onCategoryTapped(cat),
                  );
                },
              ),
            ),
            const SizedBox(height: 28),
          ],

          // 2. "Shop by category" Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Shop by category',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : const Color(0xFF0F172A),
                ),
              ),
              Text(
                '${shopByCategories.length} groups',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2-Column Grid (Shop by category)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shopByCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.82,
            ),
            itemBuilder: (context, index) {
              final cat = shopByCategories[index];
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

  /// Category products view when user taps any card
  Widget _buildCategoryProductsView(bool isDark, CategoryDetails currentCat) {
    final products = _currentProducts;

    return Column(
      children: [
        // Subcategory chips
        if (currentCat.subcategories.isNotEmpty)
          Container(
            height: 42,
            margin: const EdgeInsets.only(bottom: 10),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: currentCat.subcategories.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final sub = currentCat.subcategories[index];
                final isSubSelected = _selectedSubcategory.isEmpty
                    ? index == 0
                    : _selectedSubcategory == sub;

                return InkWell(
                  onTap: () => setState(() => _selectedSubcategory = sub),
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSubSelected
                          ? const Color(0xFF2563EB)
                          : (isDark ? AppColors.darkCard : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSubSelected
                            ? const Color(0xFF2563EB)
                            : (isDark
                                  ? AppColors.darkBorder
                                  : const Color(0xFFE2E8F0)),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        sub,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: isSubSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
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
              },
            ),
          ),

        // Product Grid
        Expanded(
          child: products.isEmpty
              ? Center(
                  child: PandaEmptyState(
                    title: 'No products yet 🐼',
                    message: 'Check back soon for new arrivals!',
                  ),
                )
              : GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 110),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.68,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
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
        ),
      ],
    );
  }
}

/// Popular horizontal card with photo preview matching reference design
class _PopularPhotoCard extends StatelessWidget {
  final CategoryDetails category;
  final VoidCallback onTap;

  const _PopularPhotoCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final shortTitle = category.title.split('&').first.trim();

    return Container(
      width: 148,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFF1F5F9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.035),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top photo preview surface
              Container(
                height: 108,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(19)),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(19),
                  ),
                  child: category.imageAsset != null
                      ? Image.asset(
                          category.imageAsset!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, _, _) => _buildFallback(isDark),
                        )
                      : _buildFallback(isDark),
                ),
              ),

              // Bottom content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      shortTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${category.itemCount} items',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(bool isDark) {
    return Container(
      color: category.accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
      child: Center(
        child: Icon(category.icon, color: category.accentColor, size: 28),
      ),
    );
  }
}
