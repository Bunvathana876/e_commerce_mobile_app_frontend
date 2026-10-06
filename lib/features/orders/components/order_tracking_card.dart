import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/utils/currency.dart';
import '../controllers/orders_controller.dart';

/// Card for one order: id, date, status progress, items and total.
class OrderTrackingCard extends StatelessWidget {
  final OrderRecord order;

  const OrderTrackingCard({super.key, required this.order});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String get _dateText =>
      '${_months[order.date.month - 1]} ${order.date.day}, ${order.date.year}';

  @override
  Widget build(BuildContext context) {
    final names = order.items.map((i) => i.product.name).join(', ');
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                order.id,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.homePrimaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.label,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.primaryLight
                        : AppColors.homePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            _dateText,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextMuted : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 14),
          _StatusProgress(current: order.status),
          const SizedBox(height: 14),
          Text(
            names,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Divider(
              height: 1,
              color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.itemCount} item${order.itemCount == 1 ? '' : 's'} • ${order.paymentMethod}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatPrice(order.total),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.homePrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Three-step bar: Processing → Shipped → Delivered.
class _StatusProgress extends StatelessWidget {
  final OrderStatus current;

  const _StatusProgress({required this.current});

  @override
  Widget build(BuildContext context) {
    final steps = OrderStatus.values;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 5,
                  decoration: BoxDecoration(
                    color: i <= current.index
                        ? AppColors.homePrimary
                        : (isDark
                              ? AppColors.darkSurface
                              : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  steps[i].label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: i == current.index
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: i <= current.index
                        ? (isDark ? Colors.white : AppColors.textPrimary)
                        : (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.textMuted),
                  ),
                ),
              ],
            ),
          ),
          if (i != steps.length - 1) const SizedBox(width: 6),
        ],
      ],
    );
  }
}
