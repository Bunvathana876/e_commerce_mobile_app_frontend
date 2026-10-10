import 'package:flutter/material.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/categories/screens/categories_page.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';
import 'bottom_tab_navigator.dart';

/// Application routes definition for ShopPanda.
class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String wishlist = '/wishlist';
  static const String profile = '/profile';
  static const String checkout = '/checkout';
  static const String categories = '/categories';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const BottomTabNavigator(),
    categories: (_) => const CategoriesPage(),
    cart: (_) => const CartScreen(),
    orders: (_) => const OrderHistoryScreen(),
    wishlist: (_) => const WishlistScreen(),
    profile: (_) => const ProfileScreen(),
    checkout: (_) => const CheckoutScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
