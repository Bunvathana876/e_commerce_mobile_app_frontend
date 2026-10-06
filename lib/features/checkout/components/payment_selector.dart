import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';

/// A payment choice. 💡 EASY TO CHANGE: edit [paymentOptions] below.
class PaymentOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const PaymentOption(this.id, this.title, this.subtitle, this.icon);
}

const List<PaymentOption> paymentOptions = [
  PaymentOption(
    'cash',
    'Cash on Delivery',
    'Pay when you receive',
    LucideIcons.banknote,
  ),
  PaymentOption(
    'card',
    'Credit / Debit Card',
    'Visa, Mastercard',
    LucideIcons.creditCard,
  ),
  PaymentOption(
    'wallet',
    'Mobile Wallet',
    'ABA Pay, Wing, KHQR',
    LucideIcons.smartphone,
  ),
];

/// Radio-style list of payment methods.
class PaymentSelector extends StatelessWidget {
  final String selectedId;
  final ValueChanged<String> onChanged;

  const PaymentSelector({
    super.key,
    required this.selectedId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final option in paymentOptions)
          _PaymentTile(
            option: option,
            selected: option.id == selectedId,
            onTap: () => onChanged(option.id),
          ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentOption option;
  final bool selected;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected
              ? (isDark
                    ? AppColors.primary.withValues(alpha: 0.15)
                    : AppColors.homePrimaryLight)
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected
                ? AppColors.homePrimary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
            width: selected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(option.icon, color: AppColors.homePrimary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    option.subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected
                  ? AppColors.homePrimary
                  : (isDark ? AppColors.darkTextMuted : AppColors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
