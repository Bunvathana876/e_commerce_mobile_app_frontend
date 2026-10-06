import '../../../core/api/client.dart';
import '../../../core/api/endpoints.dart';

class CheckoutApi {
  final ApiClient _client = ApiClient.instance;

  Future<ApiResponse<String>> processPayment({
    required double amount,
    required String paymentMethod,
    required String address,
  }) async {
    return _client.post<String>(
      endpoint: ApiEndpoints.checkout,
      body: {
        'amount': amount,
        'paymentMethod': paymentMethod,
        'address': address,
      },
      mockDataProvider: () =>
          'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
    );
  }
}
