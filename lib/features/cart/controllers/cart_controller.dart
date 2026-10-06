import 'package:flutter/foundation.dart';
import '../../home/data/home_mock_data.dart';

/// One product in the cart with a quantity.
class CartItem {
  final HomeProduct product;
  int quantity;

  CartItem(this.product, {this.quantity = 1});

  double get total => product.price * quantity;
}

/// Shared cart state. Screens listen to it with `ListenableBuilder`.
///
/// 💡 EASY TO CHANGE: edit [freeShippingFrom] and [shippingFee] below.
class CartController extends ChangeNotifier {
  CartController._();
  static final CartController instance = CartController._();

  /// Orders at or above this subtotal ship free.
  static const double freeShippingFrom = 100;
  static const double shippingFee = 5;

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  /// Total number of products (sum of quantities).
  int get totalCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.total);
  double get shipping =>
      (_items.isEmpty || subtotal >= freeShippingFrom) ? 0 : shippingFee;
  double get total => subtotal + shipping;

  void add(HomeProduct product, {int quantity = 1}) {
    final index = _items.indexWhere((i) => i.product.id == product.id);
    if (index == -1) {
      _items.add(CartItem(product, quantity: quantity));
    } else {
      _items[index].quantity += quantity;
    }
    notifyListeners();
  }

  void increment(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index == -1) return;
    _items[index].quantity++;
    notifyListeners();
  }

  /// Lowers the quantity; removes the item when it reaches 0.
  void decrement(String productId) {
    final index = _items.indexWhere((i) => i.product.id == productId);
    if (index == -1) return;
    if (_items[index].quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index].quantity--;
    }
    notifyListeners();
  }

  void remove(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
