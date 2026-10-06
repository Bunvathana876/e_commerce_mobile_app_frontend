import '../../../core/api/client.dart';
import '../../../core/api/endpoints.dart';
import '../controllers/orders_controller.dart';

class OrderApi {
  final ApiClient _client = ApiClient.instance;

  Future<ApiResponse<List<OrderRecord>>> getOrders() async {
    return _client.get<List<OrderRecord>>(
      endpoint: ApiEndpoints.orders,
      mockDataProvider: () => OrdersController.instance.orders,
    );
  }

  Future<ApiResponse<OrderRecord?>> getOrderById(String orderId) async {
    return _client.get<OrderRecord?>(
      endpoint: '${ApiEndpoints.orders}/$orderId',
      mockDataProvider: () {
        try {
          return OrdersController.instance.orders.firstWhere(
            (o) => o.id == orderId,
          );
        } catch (_) {
          return null;
        }
      },
    );
  }
}
