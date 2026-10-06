# 🐼 ShopPanda — Modern Flutter E-Commerce App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Material 3](https://img.shields.io/badge/Material_3-7C3AED?style=for-the-badge&logo=materialdesign&logoColor=white)
![Tests Passing](https://img.shields.io/badge/Tests-63%20Passed-brightgreen?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-blue.svg?style=for-the-badge)

**A clean, fast, and feature-rich mobile shopping application built with Flutter & Material 3.**

[Features](#-key-features) • [Screens](#-screens--ui-overview) • [Tech Stack](#-tech-stack--dependencies) • [Architecture](#-project-structure) • [Getting Started](#-getting-started) • [Running Tests](#-running-tests)

</div>

---

## 🌟 Key Features

### 🛍️ Shopping & Browsing Experience
- **Interactive Home Screen**: Dynamic greeting, live search bar, promotional banner carousel, category pills, flash sale countdown timer, and popular product grid.
- **Comprehensive Categories Explorer**: Dual-mode browsing:
  - **Visual Grid**: High-level department overview cards with badges and subcategory previews.
  - **Category Explorer**: Split-rail layout with vertical navigation, hero gradient banners, horizontal subcategory filter chips, and live product search.
- **Deals & Flash Sales**: Dedicated daily discounts screen with live countdown timer, discount percentage filters (30%+, 50%+, 70%+), deal-of-the-day hero card, and claim progress bars.
- **Detailed Product Pages**: Multi-angle preview, dynamic color & size selectors, quantity stepper, buyer trust badges, and reactive add-to-cart.
- **Customer Reviews & Ratings**: 5-star rating breakdown bars, verified buyer badges, thumbs-up helpful counters, and interactive "Write a Review" bottom sheet modal.

### 🛒 Cart, Wishlist & Checkout
- **Reactive State Management**: Centralized reactive controllers (`CartController`, `WishlistController`, `OrdersController`) with instant UI synchronization across all screens.
- **Cart Screen**: Item counter, quantity adjustment, promo code voucher system (`PANDA10`), and free shipping progress tracker toward \$100.
- **Panda Mascot Empty States**: Charming floating panda animations with breathing ground shadows for empty cart and wishlist views.
- **Complete Checkout**: Delivery address selector, payment method options (Credit Card, ABA PAY, Cash on Delivery), order summary calculations, and confirmation dialog.
- **Order History & Tracking**: Status filtering (All, Pending, Shipped, Delivered) with visual 3-step delivery progress indicator.

### 🎨 Design & Visual Polish
- **Frosted Glass Floating Navigation Bar**: 6-tab floating pill nav bar with real glassmorphism (`BackdropFilter` blur: `14px`, translucent tint, hairline border, ambient drop shadow).
- **Dark Mode Theme Support**: Full dark theme with deep midnight navy (`#0F172A`) paired with royal blue accents (`#2563EB`), persisted across app restarts via `ThemeController` and `SharedPreferences`.
- **Skeleton Shimmer Loaders**: Pure Flutter animated shimmer skeletons for hero banners and product grids during data loading.
- **Zero Layout Overflows**: Fully responsive across compact, standard, and wide mobile viewports.

---

## 📱 Screens & UI Overview

| Section | Included Features |
|---|---|
| **Auth** | Login & Registration with input validation, password toggle, social login buttons, and saved login ("Remember Me") |
| **Home** | Search, banner carousel, category shortcuts, flash sale timer, popular products grid |
| **Categories** | Visual grid view & split-rail explorer, live search, subcategory filter chips |
| **Deals** | Flash sales, discount filter chips, deal of the day, stock claimed bars |
| **Product Detail** | Image viewer, variant options, spec details, customer ratings & write review modal |
| **Wishlist** | Favorite items list with one-tap add-to-cart or remove |
| **Cart** | Cart items list, coupon codes, shipping progress bar, checkout CTA |
| **Checkout** | Shipping form, payment method picker, place order dialog |
| **Orders** | Historical purchases, delivery timeline progress, order status badges |
| **Profile** | User card, dark mode switch, delivery addresses, payment methods, notifications sheet |

---

## 🛠️ Tech Stack & Dependencies

- **Framework**: [Flutter](https://flutter.dev) (Channel stable, Material 3)
- **Language**: [Dart](https://dart.dev) (SDK `^3.11.1`)
- **Icons**: [`lucide_icons`](https://pub.dev/packages/lucide_icons), [`cupertino_icons`](https://pub.dev/packages/cupertino_icons)
- **Local Persistence**: [`shared_preferences`](https://pub.dev/packages/shared_preferences)
- **Colors**:
  - Primary Accent: Royal Blue (`#2563EB`)
  - Light Background: `#F8FAFC` / Surface: `#FFFFFF`
  - Dark Background: Midnight Navy (`#0F172A`) / Dark Surface: `#1E293B`

---

## 📂 Project Structure

The project follows a modular, feature-first architectural pattern:

```text
lib/
├── main.dart                          # App entry point, theme provider & session bootstrap
├── app/
│   └── navigation/                    # BottomTabNavigator, AppNavigator, route definitions
├── core/
│   ├── api/                           # Mock API client and endpoints
│   ├── constants/                     # AppColors, layout spacing & border radiuses
│   ├── storage/                       # SessionStorage for user auth state
│   ├── theme/                         # ThemeController & AppTheme definitions (Light & Dark)
│   └── utils/                         # Validation rules, currency formatting
├── components/                        # Reusable app-wide UI components
│   ├── badge/                         # StatusBadge
│   ├── button/                        # CustomPrimaryButton
│   ├── empty_state/                   # PandaEmptyState with floating animations
│   ├── input/                         # CustomInputField
│   ├── shimmer/                       # Pure Flutter animated skeleton loaders
│   └── toast/                         # showAppToast notification popups
├── models/                            # Domain entities (Product, Category, Cart, Order, User)
├── features/                          # Feature modules (screens, components, controllers, data)
│   ├── auth/                          # Login, Register, AuthController
│   ├── home/                          # HomeScreen, carousels, category bars, mock data
│   ├── categories/                    # CategoriesScreen, CategoryGridCard, CategoryData
│   ├── deals/                         # DealsScreen, flash sale countdown, deal cards
│   ├── products/                      # ProductDetailScreen, reviews, filter controllers
│   ├── cart/                          # CartScreen, CartController
│   ├── wishlist/                      # WishlistScreen, WishlistController
│   ├── orders/                        # OrderHistoryScreen, OrdersController
│   ├── checkout/                      # CheckoutScreen, payment selector
│   └── profile/                       # ProfileScreen, theme switch, settings sheets
└── widgets/
    └── custom_floating_nav_bar.dart   # Frosted glass floating pill navigation bar
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) installed (version `3.24.0` or higher recommended).
- [Dart SDK](https://dart.dev/get-dart) `^3.11.1`.
- Android Studio / Xcode / VS Code with Flutter extension.
- An iOS Simulator, Android Emulator, or physical device.

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Bunvathana876/e_commerce_mobile_app.git
   cd e_commerce_mobile_app
   ```

2. **Install Flutter dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify the environment:**
   ```bash
   flutter doctor
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

---

## 🧪 Running Tests & Quality Checks

Run the automated test suite to verify code integrity across all features:

```bash
# Run all 63 widget and unit tests
flutter test

# Run static analysis (0 warnings / 0 errors expected)
flutter analyze
```

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).
