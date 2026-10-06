import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../models/address.dart';

/// Reusable Address Card component.
class AddressCard extends StatelessWidget {
  final ShippingAddress address;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const AddressCard({
    super.key,
    required this.address,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: address.isDefault
              ? AppColors.homePrimaryLight
              : AppColors.homeSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: address.isDefault ? AppColors.primary : AppColors.border,
            width: address.isDefault ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: address.isDefault
                    ? AppColors.primary
                    : AppColors.textMuted.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                address.isDefault
                    ? Icons.home_rounded
                    : Icons.location_on_outlined,
                size: 18,
                color: address.isDefault ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            'DEFAULT',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.address,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    address.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: AppColors.textSecondary,
                ),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }
}
