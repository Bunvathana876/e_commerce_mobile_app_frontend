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
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.homePrimaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  order.status.label,
                  style: const TextStyle(
                    color: AppColors.homePrimary,
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
            style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 14),
          _StatusProgress(current: order.status),
          const SizedBox(height: 14),
          Text(
            names,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
          const Divider(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${order.itemCount} item${order.itemCount == 1 ? '' : 's'} • ${order.paymentMethod}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
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
                        : AppColors.border,
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
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
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
