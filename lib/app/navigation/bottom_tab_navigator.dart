import 'package:flutter/material.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/categories/screens/categories_screen.dart';
import '../../features/deals/screens/deals_screen.dart';
import '../../features/home/components/home_bottom_nav_bar.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

/// Main app shell: one page per bottom-bar tab.
///
/// Tab order (matches `HomeBottomNavBar.items`):
/// 0 Home · 1 Categories · 2 Deals · 3 Wishlist · 4 Cart · 5 Profile
class BottomTabNavigator extends StatefulWidget {
  const BottomTabNavigator({super.key});

  static const int homeTab = 0;
  static const int categoriesTab = 1;
  static const int dealsTab = 2;
  static const int wishlistTab = 3;
  static const int cartTab = 4;
  static const int profileTab = 5;

  @override
  State<BottomTabNavigator> createState() => _BottomTabNavigatorState();
}

class _BottomTabNavigatorState extends State<BottomTabNavigator> {
  int _index = BottomTabNavigator.homeTab;

  void _goTo(int index) => setState(() => _index = index);

  void _openOrders() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const OrderHistoryScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Allows scrollable content to extend behind the frosted glass nav bar
      extendBody: true,
      // IndexedStack keeps every tab alive, so scroll positions are kept.
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            onCartTap: () => _goTo(BottomTabNavigator.cartTab),
            onCategoriesTap: () => _goTo(BottomTabNavigator.categoriesTab),
            showBottomNav: false,
          ),
          const CategoriesScreen(),
          DealsScreen(
            onStartShopping: () => _goTo(BottomTabNavigator.homeTab),
            onViewCart: () => _goTo(BottomTabNavigator.cartTab),
          ),
          WishlistScreen(onBrowse: () => _goTo(BottomTabNavigator.homeTab)),
          CartScreen(
            onStartShopping: () => _goTo(BottomTabNavigator.homeTab),
            onViewOrders: _openOrders,
          ),
          ProfileScreen(
            onOpenOrders: _openOrders,
            onOpenWishlist: () => _goTo(BottomTabNavigator.wishlistTab),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavBar(currentIndex: _index, onTap: _goTo),
    );
  }
}
