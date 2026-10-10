import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/empty_state/empty_state.dart';
import '../../../components/header/app_screen_header.dart';
import '../../../core/constants/colors.dart';
import '../components/order_tracking_card.dart';
import '../controllers/orders_controller.dart';

/// Orders page: every order the user has placed, filterable by status.
class OrderHistoryScreen extends StatefulWidget {
  /// Called when the user taps "Start Shopping" (e.g. go to the Home tab).
  final VoidCallback? onStartShopping;

  const OrderHistoryScreen({super.key, this.onStartShopping});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final controller = OrdersController.instance;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final allOrders = controller.orders;
        final filteredOrders = _selectedStatus == null
            ? allOrders
            : allOrders.where((o) => o.status == _selectedStatus).toList();

        return Scaffold(
          backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
          appBar: AppScreenHeader(
            title: 'My Orders',
            subtitle: 'Track & manage',
            badgeText: allOrders.isNotEmpty ? '${allOrders.length} orders' : null,
            showBackButton: Navigator.of(context).canPop(),
            leadingIcon: LucideIcons.package,
            leadingIconColor: const Color(0xFFD97706),
          ),
          body: allOrders.isEmpty
              ? EmptyState(
                  icon: LucideIcons.package,
                  title: 'No orders yet',
                  message: 'When you place an order, you can track it here.',
                  buttonText: 'Start Shopping',
                  onButtonTap: widget.onStartShopping,
                )
              : Column(
                  children: [
                    // Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All (${allOrders.length})',
                            isSelected: _selectedStatus == null,
                            onTap: () => setState(() => _selectedStatus = null),
                          ),
                          const SizedBox(width: 8),
                          for (final status in OrderStatus.values) ...[
                            _FilterChip(
                              label: status.label,
                              isSelected: _selectedStatus == status,
                              onTap: () => setState(() => _selectedStatus = status),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: filteredOrders.isEmpty
                          ? Center(
                              child: Text(
                                'No ${_selectedStatus!.label.toLowerCase()} orders',
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.darkTextSecondary
                                      : AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                              itemCount: filteredOrders.length,
                              itemBuilder: (context, index) =>
                                  OrderTrackingCard(order: filteredOrders[index]),
                            ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.homePrimary
              : (isDark ? AppColors.darkCard : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.homePrimary
                : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}
