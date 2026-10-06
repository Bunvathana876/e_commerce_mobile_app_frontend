/// Standard API response wrapper.
class ApiResponse<T> {
  final bool isSuccess;
  final T? data;
  final String? errorMessage;
  final int statusCode;

  const ApiResponse.success(this.data, {this.statusCode = 200})
    : isSuccess = true,
      errorMessage = null;

  const ApiResponse.error(this.errorMessage, {this.statusCode = 400})
    : isSuccess = false,
      data = null;
}

/// Simulated API Client for ShopPanda.
///
/// Can easily be swapped with `http` or `dio` when a real backend is connected.
class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  /// Mock network latency simulation.
  Future<void> simulateNetworkLatency([int milliseconds = 300]) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
  }

  /// Perform a simulated GET request.
  Future<ApiResponse<T>> get<T>({
    required String endpoint,
    required T Function() mockDataProvider,
  }) async {
    try {
      await simulateNetworkLatency();
      return ApiResponse.success(mockDataProvider());
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  /// Perform a simulated POST request.
  Future<ApiResponse<T>> post<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    required T Function() mockDataProvider,
  }) async {
    try {
      await simulateNetworkLatency();
      return ApiResponse.success(mockDataProvider());
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
}
