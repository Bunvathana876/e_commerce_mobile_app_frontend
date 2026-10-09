import 'package:flutter/material.dart';

/// Typed Category model representing a shopping department/category.
class Category {
  final String id;
  final String name;
  final String description;
  final int itemCount;
  final String? imageAsset;
  final IconData fallbackIcon;
  final String? badge; // e.g. "New", "Sale", "Popular", "Hot"
  final Color accentColor;
  final List<String> subcategories;
  final List<String> filterGroups; // e.g. 'Women', 'Men', 'Kids', 'Home', 'Tech', 'All'
  final bool isFavorite;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    required this.itemCount,
    this.imageAsset,
    this.fallbackIcon = Icons.category_rounded,
    this.badge,
    this.accentColor = const Color(0xFF2563EB),
    this.subcategories = const [],
    this.filterGroups = const ['All'],
    this.isFavorite = false,
  });

  Category copyWith({
    String? id,
    String? name,
    String? description,
    int? itemCount,
    String? imageAsset,
    IconData? fallbackIcon,
    String? badge,
    Color? accentColor,
    List<String>? subcategories,
    List<String>? filterGroups,
    bool? isFavorite,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      itemCount: itemCount ?? this.itemCount,
      imageAsset: imageAsset ?? this.imageAsset,
      fallbackIcon: fallbackIcon ?? this.fallbackIcon,
      badge: badge ?? this.badge,
      accentColor: accentColor ?? this.accentColor,
      subcategories: subcategories ?? this.subcategories,
      filterGroups: filterGroups ?? this.filterGroups,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

