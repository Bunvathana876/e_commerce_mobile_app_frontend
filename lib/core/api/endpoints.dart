/// API Endpoints for ShopPanda.
class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://api.shoppanda.com/v1';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';

  // Products
  static const String products = '/products';
  static const String categories = '/categories';
  static const String banners = '/banners';

  // Cart & Checkout
  static const String cart = '/cart';
  static const String checkout = '/checkout';

  // Orders
  static const String orders = '/orders';
}
