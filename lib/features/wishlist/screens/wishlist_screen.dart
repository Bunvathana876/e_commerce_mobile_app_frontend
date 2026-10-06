import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/empty_state/empty_state.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../home/data/home_mock_data.dart';
import '../../products/screens/product_detail_screen.dart';
import '../controllers/wishlist_controller.dart';

/// Wishlist page: products the user marked with a heart.
class WishlistScreen extends StatelessWidget {
  /// Called when the user taps "Browse Products" (e.g. go to the Home tab).
  final VoidCallback? onBrowse;

  const WishlistScreen({super.key, this.onBrowse});

  @override
  Widget build(BuildContext context) {
    final wishlist = WishlistController.instance;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Wishlist',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: wishlist,
        builder: (context, _) {
          final products = wishlist.products;
          if (products.isEmpty) {
            return EmptyState(
              icon: LucideIcons.heart,
              title: 'No favorites yet',
              message: 'Tap the heart on any product to save it here.',
              buttonText: 'Browse Products',
              onButtonTap: onBrowse,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) =>
                _WishlistTile(product: products[index]),
          );
        },
      ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  final HomeProduct product;

  const _WishlistTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: product.cardBackground,
                borderRadius: BorderRadius.circular(14),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: product.imageUrl != null
                    ? Image.network(
                        product.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => Icon(
                          product.fallbackIcon,
                          size: 36,
                          color: AppColors.homePrimary.withValues(alpha: 0.75),
                        ),
                      )
                    : Icon(
                        product.fallbackIcon,
                        size: 36,
                        color: AppColors.homePrimary.withValues(alpha: 0.75),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formatPrice(product.price),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.homePrimary,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                InkWell(
                  onTap: () => WishlistController.instance.toggle(product.id),
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.favorite_rounded,
                      size: 22,
                      color: Color(0xFFEF4444),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () {
                    CartController.instance.add(product);
                    showAppToast(context, 'Added "${product.name}" to cart!');
                  },
                  customBorder: const CircleBorder(),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.homePrimary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.shoppingBag,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
