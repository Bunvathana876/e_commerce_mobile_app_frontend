import 'package:flutter/material.dart';

// ============================================================================
// HOME SCREEN DATA MODELS & MOCK DATA
// ============================================================================
// Tip: Edit, add, or remove items in the lists below to customize your store!
// ============================================================================

/// Model representing a category in the horizontal category bar.
class HomeCategory {
  final String id;
  final String title;
  final IconData icon;

  const HomeCategory({
    required this.id,
    required this.title,
    required this.icon,
  });
}

/// Model representing a promotional banner on the home carousel.
class PromoBanner {
  final String id;
  final String tag;
  final String title;
  final String subtitle;
  final String buttonText;
  final List<Color> gradientColors;
  final String? assetImage;
  final IconData? fallbackIcon;

  const PromoBanner({
    required this.id,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.gradientColors,
    this.assetImage,
    this.fallbackIcon,
  });
}

/// Model representing a product item displayed on the home screen.
class HomeProduct {
  final String id;
  final String name;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewsCount;
  final String? imageUrl;
  final String? assetImage;
  final IconData fallbackIcon;
  final Color cardBackground;
  final bool isNew;
  final String? discountTag;
  final bool isFavorite;

  const HomeProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.originalPrice,
    this.rating = 4.8,
    this.reviewsCount = 120,
    this.imageUrl,
    this.assetImage,
    this.fallbackIcon = Icons.shopping_bag_outlined,
    this.cardBackground = const Color(0xFFF5F9FF),
    this.isNew = false,
    this.discountTag,
    this.isFavorite = false,
  });

  HomeProduct copyWith({bool? isFavorite}) {
    return HomeProduct(
      id: id,
      name: name,
      category: category,
      price: price,
      originalPrice: originalPrice,
      rating: rating,
      reviewsCount: reviewsCount,
      imageUrl: imageUrl,
      assetImage: assetImage,
      fallbackIcon: fallbackIcon,
      cardBackground: cardBackground,
      isNew: isNew,
      discountTag: discountTag,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

// ============================================================================
// DEFAULT MOCK DATA (EASY TO MODIFY)
// ============================================================================

/// Categories displayed in the horizontal selector.
final List<HomeCategory> mockCategories = [
  const HomeCategory(id: 'all', title: 'All', icon: Icons.grid_view_rounded),
  const HomeCategory(
    id: 'fashion',
    title: 'Fashion',
    icon: Icons.checkroom_rounded,
  ),
  const HomeCategory(
    id: 'shoes',
    title: 'Shoes',
    icon: Icons.roller_skating_outlined,
  ),
  const HomeCategory(
    id: 'electronics',
    title: 'Electronics',
    icon: Icons.devices_rounded,
  ),
  const HomeCategory(
    id: 'beauty',
    title: 'Beauty',
    icon: Icons.face_retouching_natural_rounded,
  ),
  const HomeCategory(
    id: 'bags',
    title: 'Bags',
    icon: Icons.shopping_bag_rounded,
  ),
  const HomeCategory(
    id: 'watches',
    title: 'Watches',
    icon: Icons.watch_rounded,
  ),
];

/// Banners displayed in the hero carousel.
final List<PromoBanner> mockPromoBanners = [
  const PromoBanner(
    id: 'b1',
    tag: 'LIMITED TIME',
    title: 'Autumn Sale 🍂',
    subtitle: 'Get up to 50% discount on all new autumn collections',
    buttonText: 'Shop Now',
    gradientColors: [Color(0xFF2563EB), Color(0xFF1E40AF)],
    assetImage: 'assets/images/logo/Blue-and-White Panda Waving.png',
  ),
  const PromoBanner(
    id: 'b2',
    tag: 'NEW ARRIVALS',
    title: 'ShopPanda Special',
    subtitle: 'Free delivery & cashback for first 5 orders this week',
    buttonText: 'Explore',
    gradientColors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    assetImage: 'assets/images/logo/Blue-and-White Panda LoveB.png',
  ),
  const PromoBanner(
    id: 'b3',
    tag: 'WEEKEND DEAL',
    title: 'Exclusive Brands',
    subtitle: 'Luxury cosmetics & fashion with extra coupon discounts',
    buttonText: 'Claim Coupon',
    gradientColors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
    fallbackIcon: Icons.local_offer_rounded,
  ),
];

/// Products shown under Flash Sale & Popular Products sections.
final List<HomeProduct> mockProducts = [
  const HomeProduct(
    id: 'p1',
    name: 'Casual Minimalist Hoodie',
    category: 'Fashion',
    price: 38.00,
    originalPrice: 48.00,
    rating: 4.9,
    reviewsCount: 230,
    discountTag: '-20%',
    fallbackIcon: Icons.accessibility_new_rounded,
    cardBackground: Color(0xFFEFF6FF),
  ),
  const HomeProduct(
    id: 'p2',
    name: 'Urban Street Sneakers',
    category: 'Shoes',
    price: 75.50,
    originalPrice: 95.00,
    rating: 4.8,
    reviewsCount: 185,
    discountTag: '-25%',
    fallbackIcon: Icons.directions_run_rounded,
    cardBackground: Color(0xFFF5F9FF),
  ),
  const HomeProduct(
    id: 'p3',
    name: 'Classic Leather Crossbody Bag',
    category: 'Bags',
    price: 52.00,
    originalPrice: 65.00,
    rating: 4.7,
    reviewsCount: 94,
    discountTag: '-15%',
    fallbackIcon: Icons.shopping_bag_outlined,
    cardBackground: Color(0xFFEFF6FF),
  ),
  const HomeProduct(
    id: 'p4',
    name: 'Wireless Noise-Canceling Buds',
    category: 'Electronics',
    price: 89.99,
    originalPrice: 119.99,
    rating: 4.9,
    reviewsCount: 412,
    discountTag: '-30%',
    fallbackIcon: Icons.headphones_rounded,
    cardBackground: Color(0xFFDBEAFE),
  ),
  const HomeProduct(
    id: 'p5',
    name: 'Hydrating Glow Serum 50ml',
    category: 'Beauty',
    price: 24.50,
    rating: 4.6,
    reviewsCount: 88,
    isNew: true,
    fallbackIcon: Icons.spa_rounded,
    cardBackground: Color(0xFFE0F2FE),
  ),
  const HomeProduct(
    id: 'p6',
    name: 'Minimal Chronograph Watch',
    category: 'Watches',
    price: 135.00,
    originalPrice: 160.00,
    rating: 4.9,
    reviewsCount: 156,
    discountTag: '-15%',
    fallbackIcon: Icons.watch_outlined,
    cardBackground: Color(0xFFF5F9FF),
  ),
];
