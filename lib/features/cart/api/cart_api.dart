import '../../../core/api/client.dart';
import '../../../core/api/endpoints.dart';
import '../controllers/cart_controller.dart';

class CartApi {
  final ApiClient _client = ApiClient.instance;

  Future<ApiResponse<List<CartItem>>> getCartItems() async {
    return _client.get<List<CartItem>>(
      endpoint: ApiEndpoints.cart,
      mockDataProvider: () => CartController.instance.items,
    );
  }

  Future<ApiResponse<bool>> updateCartItemQuantity({
    required String productId,
    required int quantity,
  }) async {
    return _client.post<bool>(
      endpoint: '${ApiEndpoints.cart}/update',
      body: {'productId': productId, 'quantity': quantity},
      mockDataProvider: () => true,
    );
  }
}
