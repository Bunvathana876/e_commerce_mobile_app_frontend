import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../components/toast/custom_toast.dart';
import '../../../core/constants/colors.dart';
import '../../../core/storage/secure_storage.dart';
import '../../../core/theme/theme_controller.dart';
import '../../auth/screens/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  /// Open the Orders tab (used by "My Orders" and the order shortcuts).
  final VoidCallback? onOpenOrders;

  /// Open the Wishlist tab.
  final VoidCallback? onOpenWishlist;

  const ProfileScreen({super.key, this.onOpenOrders, this.onOpenWishlist});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// Quick order shortcuts displayed below the user card.
  static const List<_OrderStatusItem> _orderStatuses = [
    _OrderStatusItem(LucideIcons.wallet, 'To Pay'),
    _OrderStatusItem(LucideIcons.package, 'To Ship'),
    _OrderStatusItem(LucideIcons.truck, 'To Receive'),
    _OrderStatusItem(LucideIcons.star, 'To Review'),
  ];

  /// Rows shown under the order section (icon + title + optional badge/subtitle).
  static const List<_MenuItem> _menuItems = [
    _MenuItem(LucideIcons.package, 'My Orders', badge: 'View all'),
    _MenuItem(LucideIcons.heart, 'Wishlist'),
    _MenuItem(LucideIcons.mapPin, 'Shipping Address'),
    _MenuItem(LucideIcons.creditCard, 'Payment Methods'),
    _MenuItem(LucideIcons.bell, 'Notifications'),
    _MenuItem(LucideIcons.helpCircle, 'Help & Support'),
  ];

  Future<void> _logout(BuildContext context) async {
    await SessionStorage.clear();
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _onMenuTap(BuildContext context, _MenuItem item) {
    switch (item.title) {
      case 'My Orders':
        if (widget.onOpenOrders != null) {
          widget.onOpenOrders!();
        } else {
          _showToast(context, 'Orders tab opened');
        }
      case 'Wishlist':
        if (widget.onOpenWishlist != null) {
          widget.onOpenWishlist!();
        } else {
          _showToast(context, 'Wishlist tab opened');
        }
      case 'Shipping Address':
        _showShippingAddressSheet(context);
      case 'Payment Methods':
        _showPaymentMethodsSheet(context);
      case 'Notifications':
        _showNotificationsSheet(context);
      case 'Help & Support':
        _showHelpSupportSheet(context);
      default:
        _showToast(context, '${item.title} opened');
    }
  }

  void _showToast(BuildContext context, String message) {
    showAppToast(context, message);
  }

  void _showEditProfile(BuildContext context) {
    final user = SessionStorage.currentUser;
    final nameController = TextEditingController(
      text: user?.name ?? 'Alex Doe',
    );
    final emailController = TextEditingController(
      text: user?.email ?? 'alex@example.com',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
                prefixIcon: const Icon(LucideIcons.user, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email Address',
                prefixIcon: const Icon(LucideIcons.mail, size: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newName = nameController.text.trim();
                final newEmail = emailController.text.trim();
                if (newName.isNotEmpty && newEmail.isNotEmpty) {
                  await SessionStorage.save(
                    SavedUser(name: newName, email: newEmail),
                    remember: true,
                  );
                  if (!mounted) return;
                  setState(() {});
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                  if (context.mounted) {
                    showAppToast(context, 'Profile updated successfully!');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.homePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showShippingAddressSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Shipping Addresses',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _AddressCard(
              title: 'Home (Default)',
              address: 'Street 2004, Toul Kork, Phnom Penh, Cambodia',
              phone: '+855 12 345 678',
              isDefault: true,
            ),
            const SizedBox(height: 10),
            _AddressCard(
              title: 'Work / Office',
              address: 'Canadia Tower, Monivong Blvd, Phnom Penh, Cambodia',
              phone: '+855 98 765 432',
              isDefault: false,
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(ctx).pop();
                showAppToast(context, 'Address management ready');
              },
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text('+ Add New Address'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.homePrimary,
                side: const BorderSide(color: AppColors.homePrimary),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentMethodsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Payment Methods',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _PaymentCardItem(
              title: 'Visa Credit Card',
              detail: '•••• •••• •••• 4242',
              icon: Icons.credit_card_rounded,
              isDefault: true,
            ),
            const SizedBox(height: 10),
            _PaymentCardItem(
              title: 'ABA Pay / KHQR',
              detail: 'Instant QR payment in Cambodia',
              icon: Icons.qr_code_scanner_rounded,
              isDefault: false,
            ),
            const SizedBox(height: 10),
            _PaymentCardItem(
              title: 'Cash on Delivery',
              detail: 'Pay upon receiving your package',
              icon: Icons.local_atm_rounded,
              isDefault: false,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                showAppToast(context, 'Payment method added');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.homePrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Add Payment Method',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotificationsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notification Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: (val) {},
                  title: const Text(
                    'Order Status Updates',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    'Real-time alerts on your order journey',
                  ),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile.adaptive(
                  value: true,
                  onChanged: (val) {},
                  title: const Text(
                    'Flash Sales & Promos',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Exclusive weekend deals & coupons'),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
                SwitchListTile.adaptive(
                  value: false,
                  onChanged: (val) {},
                  title: const Text(
                    'Email Newsletters',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text('Weekly digest of trending fashion'),
                  activeTrackColor: AppColors.primary,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showHelpSupportSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(ctx).size.height * 0.85,
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Help & Support 🐼',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const _FaqItem(
                question: 'How fast is standard delivery?',
                answer:
                    'Delivery within Phnom Penh takes 1-2 business days. Provincial shipments take 2-4 days.',
              ),
              const _FaqItem(
                question: 'How do I return an item?',
                answer:
                    'You have 30 days from delivery to request a return if items are unworn and in original packaging.',
              ),
              const _FaqItem(
                question: 'How do I get free shipping?',
                answer:
                    'All orders over \$100 automatically qualify for free shipping nationwide!',
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  showAppToast(
                    context,
                    'Support team reached! We will reply shortly.',
                  );
                },
                icon: const Icon(LucideIcons.messageCircle, size: 18),
                label: const Text('Chat with Support'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homePrimary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionStorage.currentUser;
    final name = user?.name ?? 'Guest';
    final email = user?.email ?? 'Not logged in';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.background,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            // User profile card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.homePrimary, AppColors.homePrimaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.homePrimary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo/Blue-and-White Panda Waving.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.person_rounded,
                              size: 34,
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _showEditProfile(context),
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        LucideIcons.edit3,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quick Order Status section
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _orderStatuses.map((status) {
                  return InkWell(
                    onTap: () {
                      if (widget.onOpenOrders != null) {
                        widget.onOpenOrders!();
                      } else {
                        _showToast(context, '${status.label} orders');
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.homePrimaryLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              status.icon,
                              size: 20,
                              color: AppColors.homePrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            status.label,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),

            // Main menu list
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < _menuItems.length; i++) ...[
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.homePrimaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          _menuItems[i].icon,
                          size: 18,
                          color: AppColors.homePrimary,
                        ),
                      ),
                      title: Text(
                        _menuItems[i].title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_menuItems[i].badge != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _menuItems[i].badge!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                        ],
                      ),
                      onTap: () => _onMenuTap(context, _menuItems[i]),
                    ),
                    if (i != _menuItems.length - 1)
                      const Divider(height: 1, indent: 56, endIndent: 16),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // Settings & Dark Mode Toggle
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.border,
                ),
              ),
              child: SwitchListTile.adaptive(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.homePrimaryLight,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                    size: 18,
                    color: AppColors.homePrimary,
                  ),
                ),
                title: Text(
                  'Dark Mode',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                subtitle: Text(
                  isDark ? 'Midnight Navy active' : 'Light Blue active',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary,
                  ),
                ),
                value: ThemeController.instance.isDarkMode,
                activeTrackColor: AppColors.primary,
                onChanged: (_) async {
                  await ThemeController.instance.toggleTheme();
                  if (mounted) setState(() {});
                },
              ),
            ),
            const SizedBox(height: 24),

            // Log out button
            OutlinedButton.icon(
              onPressed: () => _logout(context),
              icon: const Icon(LucideIcons.logOut, size: 18),
              label: const Text('Log out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Bottom spacing for floating frosted glass nav bar
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _OrderStatusItem {
  final IconData icon;
  final String label;

  const _OrderStatusItem(this.icon, this.label);
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String? badge;

  const _MenuItem(this.icon, this.title, {this.badge});
}

class _AddressCard extends StatelessWidget {
  final String title;
  final String address;
  final String phone;
  final bool isDefault;

  const _AddressCard({
    required this.title,
    required this.address,
    required this.phone,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.homePrimaryLight : AppColors.homeSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDefault ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.mapPin, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    if (isDefault) ...[
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
                  address,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  phone,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentCardItem extends StatelessWidget {
  final String title;
  final String detail;
  final IconData icon;
  final bool isDefault;

  const _PaymentCardItem({
    required this.title,
    required this.detail,
    required this.icon,
    required this.isDefault,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.homePrimaryLight : AppColors.homeSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDefault ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.5,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (isDefault)
            const Icon(
              Icons.check_circle_rounded,
              size: 18,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13.5,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            answer,
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
