import '../../../core/api/client.dart';
import '../../../core/api/endpoints.dart';
import '../../home/data/home_mock_data.dart';

class ProductApi {
  final ApiClient _client = ApiClient.instance;

  Future<ApiResponse<List<HomeProduct>>> getProducts() async {
    return _client.get<List<HomeProduct>>(
      endpoint: ApiEndpoints.products,
      mockDataProvider: () => List.unmodifiable(mockProducts),
    );
  }

  Future<ApiResponse<List<HomeCategory>>> getCategories() async {
    return _client.get<List<HomeCategory>>(
      endpoint: ApiEndpoints.categories,
      mockDataProvider: () => List.unmodifiable(mockCategories),
    );
  }

  Future<ApiResponse<List<PromoBanner>>> getBanners() async {
    return _client.get<List<PromoBanner>>(
      endpoint: ApiEndpoints.banners,
      mockDataProvider: () => List.unmodifiable(mockPromoBanners),
    );
  }
}
