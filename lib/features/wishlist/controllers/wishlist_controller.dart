import 'package:flutter/foundation.dart';
import '../../home/data/home_mock_data.dart';

/// Shared wishlist (favorite products). Listen with `ListenableBuilder`.
class WishlistController extends ChangeNotifier {
  WishlistController._();
  static final WishlistController instance = WishlistController._();

  final Set<String> _ids = {};

  bool contains(String productId) => _ids.contains(productId);

  /// Favorite products, in the same order as the shop list.
  List<HomeProduct> get products =>
      mockProducts.where((p) => _ids.contains(p.id)).toList();

  void toggle(String productId) {
    if (!_ids.remove(productId)) _ids.add(productId);
    notifyListeners();
  }

  void clear() {
    _ids.clear();
    notifyListeners();
  }
}
