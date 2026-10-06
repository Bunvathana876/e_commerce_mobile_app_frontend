import 'package:flutter_test/flutter_test.dart';
import 'package:e_commerce_mobile_app/features/home/data/home_mock_data.dart';
import 'package:e_commerce_mobile_app/features/products/controllers/product_filter_controller.dart';

void main() {
  group('ProductFilterController Tests', () {
    late ProductFilterController controller;

    setUp(() {
      controller = ProductFilterController();
    });

    test('initial values are default', () {
      expect(controller.selectedCategory, 'all');
      expect(controller.searchQuery, '');
      expect(controller.sortOption, ProductSortOption.popular);
    });

    test('filters by category correctly', () {
      controller.setCategory('shoes');
      final results = controller.filter(mockProducts);
      expect(results.every((p) => p.category.toLowerCase() == 'shoes'), isTrue);
      expect(results.isNotEmpty, isTrue);
    });

    test('filters by search query', () {
      controller.setSearchQuery('sneakers');
      final results = controller.filter(mockProducts);
      expect(results.length, 1);
      expect(results.first.name, 'Urban Street Sneakers');
    });

    test('sorts by price low to high', () {
      controller.setSortOption(ProductSortOption.priceLowToHigh);
      final results = controller.filter(mockProducts);
      for (int i = 0; i < results.length - 1; i++) {
        expect(results[i].price <= results[i + 1].price, isTrue);
      }
    });

    test('reset clears filter state', () {
      controller.setCategory('shoes');
      controller.setSearchQuery('sneakers');
      controller.reset();
      expect(controller.selectedCategory, 'all');
      expect(controller.searchQuery, '');
    });
  });
}
