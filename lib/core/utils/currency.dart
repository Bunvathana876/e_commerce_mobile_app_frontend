/// Formats a number as a dollar price, e.g. 38 -> "$38.00".
String formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

/// Alias for [formatPrice].
String formatCurrency(double value) => formatPrice(value);
