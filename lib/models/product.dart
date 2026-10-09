import 'package:flutter/material.dart';
import '../features/home/data/home_mock_data.dart' show HomeProduct;

/// Product domain model representing a shopping item in ShopPanda.
class Product {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String? imageAsset;
  final String? imageUrl;
  final IconData fallbackIcon;
  final List<Color> placeholderGradient;
  final String? discountBadge;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.imageAsset,
    this.imageUrl,
    this.fallbackIcon = Icons.shopping_bag_outlined,
    this.placeholderGradient = const [Color(0xFFEFF6FF), Color(0xFFDBEAFE)],
    this.discountBadge,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? name,
    String? category,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewsCount,
    String? imageAsset,
    String? imageUrl,
    IconData? fallbackIcon,
    List<Color>? placeholderGradient,
    String? discountBadge,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      imageAsset: imageAsset ?? this.imageAsset,
      imageUrl: imageUrl ?? this.imageUrl,
      fallbackIcon: fallbackIcon ?? this.fallbackIcon,
      placeholderGradient: placeholderGradient ?? this.placeholderGradient,
      discountBadge: discountBadge ?? this.discountBadge,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Converts this [Product] to a [HomeProduct] for store & cart interop.
  HomeProduct toHomeProduct() {
    return HomeProduct(
      id: id,
      name: name,
      category: category,
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      reviewsCount: reviewsCount,
      imageUrl: imageUrl,
      assetImage: imageAsset,
      fallbackIcon: fallbackIcon,
      discountTag: discountBadge,
      isFavorite: isFavorite,
    );
  }
}


