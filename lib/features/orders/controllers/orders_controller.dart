import 'package:flutter/foundation.dart';
import '../../cart/controllers/cart_controller.dart';

/// Where an order is in its journey.
enum OrderStatus {
  processing('Processing'),
  shipped('Shipped'),
  delivered('Delivered');

  final String label;
  const OrderStatus(this.label);
}

/// A placed order.
class OrderRecord {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double total;
  final String address;
  final String paymentMethod;
  final OrderStatus status;

  const OrderRecord({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.address,
    required this.paymentMethod,
    this.status = OrderStatus.processing,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);
}

/// Shared list of placed orders (newest first).
class OrdersController extends ChangeNotifier {
  OrdersController._();
  static final OrdersController instance = OrdersController._();

  final List<OrderRecord> _orders = [];
  int _counter = 1000;

  List<OrderRecord> get orders => List.unmodifiable(_orders);

  /// Turns the current cart into an order. Does not clear the cart.
  OrderRecord place({
    required List<CartItem> items,
    required double total,
    required String address,
    required String paymentMethod,
  }) {
    final order = OrderRecord(
      id: '#SP${++_counter}',
      date: DateTime.now(),
      items: [for (final i in items) CartItem(i.product, quantity: i.quantity)],
      total: total,
      address: address,
      paymentMethod: paymentMethod,
    );
    _orders.insert(0, order);
    notifyListeners();
    return order;
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}
