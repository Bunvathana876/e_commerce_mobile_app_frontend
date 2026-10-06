import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../core/constants/colors.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/utils/currency.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../orders/controllers/orders_controller.dart';
import '../components/payment_selector.dart';

/// Checkout page: delivery details, payment method, order summary, Place Order.
class CheckoutScreen extends StatefulWidget {
  /// Called when the user taps "View my orders" after ordering.
  final VoidCallback? onViewOrders;

  /// Called when the user taps "Continue shopping" after ordering.
  final VoidCallback? onContinueShopping;

  const CheckoutScreen({super.key, this.onViewOrders, this.onContinueShopping});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController = TextEditingController(
    text: SessionStorage.currentUser?.name ?? '',
  );
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  String _paymentId = paymentOptions.first.id;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final cart = CartController.instance;
    if (cart.isEmpty) return;

    final payment = paymentOptions.firstWhere((o) => o.id == _paymentId);
    final order = OrdersController.instance.place(
      items: cart.items,
      total: cart.total,
      address:
          '${_nameController.text.trim()}, ${_phoneController.text.trim()}\n'
          '${_addressController.text.trim()}',
      paymentMethod: payment.title,
    );
    cart.clear();

    final goToOrders = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(orderId: order.id),
    );
    if (!mounted) return;
    Navigator.of(context).pop(); // close checkout
    if (goToOrders == true) {
      widget.onViewOrders?.call();
    } else {
      widget.onContinueShopping?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartController.instance;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const _SectionLabel('Delivery details'),
            _Field(
              controller: _nameController,
              label: 'Full name',
              icon: LucideIcons.user,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your name'
                  : null,
            ),
            _Field(
              controller: _phoneController,
              label: 'Phone number',
              icon: LucideIcons.phone,
              keyboardType: TextInputType.phone,
              validator: (v) => (v == null || v.trim().length < 6)
                  ? 'Please enter a valid phone number'
                  : null,
            ),
            _Field(
              controller: _addressController,
              label: 'Delivery address',
              icon: LucideIcons.mapPin,
              maxLines: 2,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'Please enter your address'
                  : null,
            ),
            const SizedBox(height: 8),
            const _SectionLabel('Payment method'),
            PaymentSelector(
              selectedId: _paymentId,
              onChanged: (id) => setState(() => _paymentId = id),
            ),
            const SizedBox(height: 8),
            const _SectionLabel('Order summary'),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.homeSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  for (final item in cart.items)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.quantity} × ${item.product.name}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Text(
                            formatPrice(item.total),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 20),
                  _TotalRow('Subtotal', formatPrice(cart.subtotal)),
                  const SizedBox(height: 6),
                  _TotalRow(
                    'Shipping',
                    cart.shipping == 0 ? 'Free' : formatPrice(cart.shipping),
                  ),
                  const SizedBox(height: 10),
                  _TotalRow('Total', formatPrice(cart.total), bold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _placeOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.homePrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              child: Text('Place Order • ${formatPrice(cart.total)}'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.homePrimary,
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _TotalRow(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 17 : 14,
      fontWeight: bold ? FontWeight.bold : FontWeight.w500,
      color: bold ? AppColors.homePrimary : AppColors.textSecondary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

class _SuccessDialog extends StatelessWidget {
  final String orderId;

  const _SuccessDialog({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.homePrimaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 48,
                color: AppColors.homePrimary,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Order placed!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Thank you! Your order $orderId is being prepared.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 22),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.homePrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text('View my orders'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Continue shopping'),
            ),
          ],
        ),
      ),
    );
  }
}
