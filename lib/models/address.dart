/// Shipping address model for user profile and checkout.
class ShippingAddress {
  final String id;
  final String title;
  final String address;
  final String phone;
  final bool isDefault;

  const ShippingAddress({
    required this.id,
    required this.title,
    required this.address,
    required this.phone,
    this.isDefault = false,
  });

  ShippingAddress copyWith({
    String? id,
    String? title,
    String? address,
    String? phone,
    bool? isDefault,
  }) {
    return ShippingAddress(
      id: id ?? this.id,
      title: title ?? this.title,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

/// Default mock shipping addresses for the app.
const List<ShippingAddress> mockAddresses = [
  ShippingAddress(
    id: 'addr_1',
    title: 'Home (Default)',
    address: 'Street 2004, Toul Kork, Phnom Penh, Cambodia',
    phone: '+855 12 345 678',
    isDefault: true,
  ),
  ShippingAddress(
    id: 'addr_2',
    title: 'Work / Office',
    address: 'Canadia Tower, Monivong Blvd, Phnom Penh, Cambodia',
    phone: '+855 98 765 432',
    isDefault: false,
  ),
];
