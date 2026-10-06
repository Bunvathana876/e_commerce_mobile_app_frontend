import 'package:flutter/material.dart';
import '../../features/cart/screens/cart_screen.dart';
import '../../features/checkout/screens/checkout_screen.dart';
import '../../features/home/data/home_mock_data.dart';
import '../../features/orders/screens/order_history_screen.dart';
import '../../features/products/screens/product_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/wishlist/screens/wishlist_screen.dart';

/// Centralized navigation helper for ShopPanda.
class AppNavigator {
  AppNavigator._();

  static Future<T?> push<T>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).push<T>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushReplacement<T, TO>(BuildContext context, Widget page) {
    return Navigator.of(
      context,
    ).pushReplacement<T, TO>(MaterialPageRoute(builder: (_) => page));
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  static void pop<T>(BuildContext context, [T? result]) {
    Navigator.of(context).pop<T>(result);
  }

  static Future<void> toProductDetail(
    BuildContext context,
    HomeProduct product,
  ) {
    return push(context, ProductDetailScreen(product: product));
  }

  static Future<void> toCart(BuildContext context) {
    return push(context, const CartScreen());
  }

  static Future<void> toCheckout(
    BuildContext context, {
    VoidCallback? onViewOrders,
    VoidCallback? onContinueShopping,
  }) {
    return push(
      context,
      CheckoutScreen(
        onViewOrders: onViewOrders,
        onContinueShopping: onContinueShopping,
      ),
    );
  }

  static Future<void> toOrders(BuildContext context) {
    return push(context, const OrderHistoryScreen());
  }

  static Future<void> toWishlist(BuildContext context) {
    return push(context, const WishlistScreen());
  }

  static Future<void> toProfile(BuildContext context) {
    return push(context, const ProfileScreen());
  }
}
