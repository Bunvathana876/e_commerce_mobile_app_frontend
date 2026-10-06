import 'package:flutter/material.dart';
import '../../home/data/home_mock_data.dart';

enum ProductSortOption { popular, priceLowToHigh, priceHighToLow, rating }

/// Controller managing product filtering, search, and sorting.
class ProductFilterController extends ChangeNotifier {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  ProductSortOption _sortOption = ProductSortOption.popular;
  RangeValues _priceRange = const RangeValues(0, 300);

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  ProductSortOption get sortOption => _sortOption;
  RangeValues get priceRange => _priceRange;

  void setCategory(String categoryId) {
    if (_selectedCategory == categoryId) return;
    _selectedCategory = categoryId;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    if (_searchQuery == query) return;
    _searchQuery = query;
    notifyListeners();
  }

  void setSortOption(ProductSortOption option) {
    if (_sortOption == option) return;
    _sortOption = option;
    notifyListeners();
  }

  void setPriceRange(RangeValues range) {
    _priceRange = range;
    notifyListeners();
  }

  void reset() {
    _selectedCategory = 'all';
    _searchQuery = '';
    _sortOption = ProductSortOption.popular;
    _priceRange = const RangeValues(0, 300);
    notifyListeners();
  }

  List<HomeProduct> filter(List<HomeProduct> items) {
    final filtered = items.where((item) {
      final matchesCategory =
          _selectedCategory == 'all' ||
          item.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch =
          _searchQuery.isEmpty ||
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          item.category.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesPrice =
          item.price >= _priceRange.start && item.price <= _priceRange.end;
      return matchesCategory && matchesSearch && matchesPrice;
    }).toList();

    switch (_sortOption) {
      case ProductSortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case ProductSortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case ProductSortOption.rating:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
      case ProductSortOption.popular:
        break;
    }

    return filtered;
  }
}
