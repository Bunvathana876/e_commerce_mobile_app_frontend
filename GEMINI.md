# ShopPanda (e_commerce_mobile_app) — Project Context for Gemini

> Paste this file (or point Gemini at it) at the start of a chat. It tells the AI what the project is, how it is organized, and the rules to follow when changing code.

---

## 1. What this project is
- **App name:** ShopPanda (older name "Glamify"; `main.dart` title is "ShopPenda").
- **Type:** Flutter e-commerce mobile app (fashion/shoes/bags/electronics), Material 3.
- **Flutter/Dart:** Dart SDK `^3.11.1`.
- **Dependencies:** `lucide_icons`, `shared_preferences`, `cupertino_icons` (no state-management or networking package yet).
- **Backend:** Mock API client layer ready in `core/api/` and `features/*/api/` with mock data.
- **Brand:** royal blue `#2563EB`, white background, rounded corners (16 px), friendly panda logo.

## 2. Current status

| Area | Status |
|---|---|
| Login screen | ✅ Done (`features/auth/screens/login_screen.dart`) |
| Register screen | ✅ Done (`features/auth/screens/register_screen.dart`) |
| Home screen | ✅ Done (`features/home/...`) |
| Floating bottom nav bar | ✅ Done (`widgets/custom_floating_nav_bar.dart`) |
| Tab Shell Navigator | ✅ Done (`app/navigation/bottom_tab_navigator.dart`) |
| App Routes & Navigator | ✅ Done (`app/navigation/routes.dart`, `app_navigator.dart`) |
| Saved login ("Remember me") | ✅ Done (`core/storage/secure_storage.dart` → `SessionStorage`, `AuthController`) |
| Profile screen & Dark Mode | ✅ Done (`features/profile/screens/profile_screen.dart`) |
| Deals & Offers screen | ✅ Done (`features/deals/screens/deals_screen.dart`) |
| Categories screen & Explorer | ✅ Done (`features/categories/...`) |
| Product Detail & Customer Reviews | ✅ Done (`features/products/...`) |
| Cart screen & Panda Empty State | ✅ Done (`features/cart/...`, `components/empty_state/`) |
| Wishlist screen & controller | ✅ Done (`features/wishlist/...`) |
| Orders screen & controller | ✅ Done (`features/orders/...`) |
| Checkout & Payment screen | ✅ Done (`features/checkout/...`) |
| Shimmer / Skeleton Loaders | ✅ Done (`lib/components/shimmer/shimmer_loading.dart`) |
| Dark Mode Theme Controller | ✅ Done (`lib/core/theme/theme_controller.dart`) |
| Domain Models | ✅ Done (`lib/models/`) |
| Reusable Components | ✅ Done (`lib/components/`) |
| Core API Layer & Endpoints | ✅ Done (`lib/core/api/`, `lib/features/*/api/`) |

**Flow:** `main()` loads the saved user and theme settings. If one exists → `BottomTabNavigator`, otherwise `LoginScreen` → (login success) → `BottomTabNavigator`. Register is reached from Login ("Create an account") and also goes to `BottomTabNavigator`. Profile → "Log out" clears the saved user and returns to `LoginScreen`. Bottom navigation tabs switch smoothly across Home, Deals, Wishlist, Cart, and Profile.

**Theme:** the whole app is **royal blue** (`AppColors.primary #2563EB`). Dark mode uses deep midnight navy (`AppColors.darkBackground #0F172A`, `darkSurface #1E293B`, `darkCard #1E293B`) paired with royal blue accents.

## 2b. Change log (what has been done)
1. Built Login + Register screens (panda logos, validators, social buttons).
2. Built Home screen (header, search, promo carousel, categories, flash sale, product grid) with editable mock data.
3. Added the dark floating pill nav bar (`CustomFloatingNavBar`) with `scale`, `shellColor`, `activeColor` options; Home uses it with 5 tabs at `scale: 1.2`, navy shell and blue active pill.
4. Changed the app colors from green to blue.
5. Added saved login: `SessionStorage` (`save`, `load`, `clear`, `currentUser`) and reactive `AuthController`. Login/Register save the user; it is written to the phone only when "Remember me" is ticked.
6. Added `ProfileScreen`: user card (name + email), menu rows (edit `_menuItems`), interactive bottom sheets for addresses, payments, notification preferences, FAQ, and Log out button.
7. Built Product Detail screen with image preview, specs, quantity stepper, color/size selectors, trust badges, and reactive Add to Cart & Buy Now.
8. Built Cart screen with `CartController` (reactive singleton, increment/decrement, free shipping progress toward \$100, promo code "PANDA10", subtotal calculation).
9. Built Wishlist screen with `WishlistController` (toggle hearts across home, product details, and wishlist).
10. Built Orders screen with `OrdersController` (order history, status filter chips, 3-step progress bar).
11. Built Checkout screen with full delivery form, payment selector, and confirmation dialog.
12. Added `BottomTabNavigator` shell holding all 5 screens with `IndexedStack`.
13. Filled all placeholder directories with clean, modular, beginner-friendly architecture:
    - `lib/models/`: `product.dart`, `category.dart`, `cart.dart`, `order.dart`, `user.dart`, `payment.dart`, `address.dart`.
    - `lib/components/`: `custom_button.dart`, `custom_badge.dart`, `custom_input.dart`, `custom_toast.dart`, `empty_state.dart`.
    - `lib/core/`: `colors.dart`, `layout.dart`, `validation.dart`, `currency.dart`, `secure_storage.dart`, `client.dart`, `endpoints.dart`.
    - `lib/app/navigation/`: `app_navigator.dart`, `bottom_tab_navigator.dart`, `routes.dart`.
    - `lib/features/*/api/`: `auth_api.dart`, `product_api.dart`, `cart_api.dart`, `checkout_api.dart`, `order_api.dart`.
14. Expanded test coverage across all layers (utils, custom components, controllers, auth, home, profile, wishlist, cart, orders, checkout). 0 static analysis errors.
15. Upgraded bottom navigation bar (`CustomFloatingNavBar` & `HomeBottomNavBar`) with glassmorphism transparency effect: translucent background container (`Colors.white.withValues(alpha: 0.85)` / `Colors.black.withValues(alpha: 0.85)` based on theme), frosted glass look via `BackdropFilter` with `ImageFilter.blur(sigmaX: 12, sigmaY: 12)`, subtle hairline border, soft ambient shadow, and smooth tab transition animations.
16. Implemented 4 major UI/UX upgrades:
    - **Dark Mode Theme Toggle**: Added dynamic `ThemeController` singleton persisting preference to `SharedPreferences`, `AppTheme` with deep midnight navy background (`#0F172A`), dark surfaces (`#1E293B`), borders (`#334155`), and adaptive `SwitchListTile.adaptive` in `ProfileScreen`.
    - **Shimmer / Skeleton Loading Screens**: Created pure Flutter animated skeleton placeholders in `lib/components/shimmer/shimmer_loading.dart` (`Shimmer`, `PromoBannerSkeleton`, `ProductCardSkeleton`, `ProductGridSkeleton`) integrated into `HomeScreen` pull-to-refresh.
    - **Interactive Customer Reviews & Ratings**: Built `ProductReviewsSection` with 5-star progress bars, customer comments list, verified buyer badges, helpful thumbs-up counter, and an interactive `WriteReviewModal` bottom sheet dialog on `ProductDetailScreen`.
    - **Panda Mascot Empty States**: Created `PandaEmptyState` with floating micro-animations and breathing ambient ground shadows, integrated into the empty cart state with *"Your cart is lonely! Let's find some deals"*.
17. Refactored floating bottom navigation bar with enhanced frosted glass & added "Deals & Offers" section:
    - **Frosted Glass & Transparency**: Encapsulated bar in `ClipRRect` and `BackdropFilter` with `ImageFilter.blur(sigmaX: 14.0, sigmaY: 14.0)`, subtle translucent surface (`const Color(0x660F172A)` for dark mode / `Colors.white.withValues(alpha: 0.35)` for light mode), soft 1px translucent border (`Colors.white.withValues(alpha: 0.18)`), and soft drop shadow.
    - **Scroll Behind**: Enabled `extendBody: true` on parent `Scaffold`s (`BottomTabNavigator`, `HomeScreen`) with 100px bottom content padding across screens so all list items remain fully visible.
    - **Deals & Offers Tab**: Created `DealsScreen` (`features/deals/screens/deals_screen.dart`) featuring live flash sale countdown timer, discount filter chips, deal-of-the-day hero card, product claim progress indicators, and one-tap Add to Cart.
    - **Balanced Bar Layout**: Adjusted spacing and scale (`scale: 1.1`, horizontal padding `(selected ? 14 : 10) * scale`) across Home, Deals (`Icons.local_fire_department_rounded`), Wishlist, Cart, and Profile without layout overflow.
    - Expanded test suite to **59 passing tests** with 0 analyzer errors.
18. Resolved all layout overflow risks across mobile screens:
    - **`DealsScreen`**: Replaced fixed image height with dynamic `Expanded` in `_DealCard` and made the details container self-sizing with `mainAxisSize: MainAxisSize.min` (eliminating bottom overflow on standard mobile screens). Adjusted grid `childAspectRatio` to `0.62`. Added `Expanded` to the AppBar title `Row`.
    - **`HomeProductCard`**: Added `Expanded` and `TextOverflow.ellipsis` to category and price columns so wide numbers or long categories never overflow against right-aligned elements.
    - **`ProductDetailScreen`**: Wrapped trust badges (`_TrustItem` row) with `FittedBox(fit: BoxFit.scaleDown)` to prevent horizontal overflow on narrow screens. Added `Expanded` to reviews section header and added height constraints (`0.88 * screenHeight`) to `WriteReviewModal` for smooth keyboard scroll without vertical overflow.
    - **`ProfileScreen`**: Wrapped modal bottom sheets (`_showEditProfile` and `_showHelpSupportSheet`) in `SingleChildScrollView` with keyboard insets padding and height bounds.
    - **`OrderTrackingCard`**: Wrapped order item count & payment method text with `Expanded` and `TextOverflow.ellipsis` to safeguard against long payment method names.
    - **`HomeHeader` & `HomeScreen`**: Added `maxLines: 1` and `TextOverflow.ellipsis` to welcome greeting and flash sale ticker texts. Wrapped promo carousel text column in `FittedBox(fit: BoxFit.scaleDown)`.
    - **Verification**: 0 analyzer errors, 59/59 passing tests.
19. Built comprehensive Category browsing experience (`CategoriesScreen`):
    - **Visual Grid Mode**: Large department cards with badges, icons, item counts, subcategory pill previews, and one-tap explore action.
    - **Category Explorer Mode**: Split layout featuring a left vertical navigation rail with department icons and active indicators, and a right content area with promotional department gradient hero card, horizontal subcategory filter chips, and responsive 2-column product grid with reactive Add-to-Cart & Wishlist heart toggling.
    - **Search & Filtering**: Live search bar filtering both departments and products with animated `PandaEmptyState` when queries yield no results.
    - **Navigation & Routing**: Added `AppRoutes.categories = '/categories'` and wired "See All" button on `HomeScreen` Categories section to open `CategoriesScreen`.
    - **Verification**: 0 analyzer errors, 65/65 passing tests.
20. Added "Categories" to Floating Bottom Navigation Bar & enhanced legibility:
    - **6-Tab Frosted Glass Bottom Bar**: Added "Categories" (`Icons.grid_view_rounded`) at index 1 (`0 Home · 1 Categories · 2 Deals · 3 Wishlist · 4 Cart · 5 Profile`). Calibrated item padding `(selected ? 13 : 8.5) * scale` and `scale: 1.0` so all 6 tabs animate smoothly with zero overflow.
    - **Tab Shell Integration**: Added `CategoriesScreen` into `BottomTabNavigator` `IndexedStack` at tab 1 and connected `HomeScreen` "See All" action directly to tab switching.
    - **Typography & Readability**: Enlarged fonts across department cards (`16.5` title, `12.5` subtitle, `11.5` counts, `11` preview tags), search bar (`14.5` text), sidebar rail, and hero banners. Added a cheerful smile icon (`Icons.sentiment_satisfied_alt_rounded`) to the category header.
    - **Layout Overflow Hardening**: Wrapped "Explore Departments" header row in `Expanded` with ellipsis and ensured `110px` bottom scroll padding across both grid and explorer modes.
    - **Verification**: 0 analyzer errors, 63/63 passing tests.

## 3. Folder structure (feature-first)

```
lib/
├── main.dart                          # App entry, theme, starts at LoginScreen
├── app/
│   └── navigation/                    # bottom_tab_navigator.dart, app_navigator.dart, routes.dart
├── core/
│   ├── api/                           # client.dart, endpoints.dart (clean mock API layer)
│   ├── constants/                     # colors.dart (AppColors), layout.dart (AppSpacing, AppRadius)
│   ├── storage/                       # secure_storage.dart (SessionStorage)
│   └── utils/                         # validation.dart (Validators), currency.dart (formatPrice)
├── components/                        # Reusable app-wide UI components
│   ├── badge/                         # custom_badge.dart (StatusBadge)
│   ├── button/                        # custom_button.dart (CustomPrimaryButton)
│   ├── empty_state/                   # empty_state.dart (EmptyStateWidget)
│   ├── input/                         # custom_input.dart (CustomInputField)
│   └── toast/                         # custom_toast.dart (showAppToast)
├── models/                            # Clean domain models (product, category, cart, order, user, payment, address)
├── features/
│   ├── auth/                          # screens, components, controllers, api
│   ├── home/                          # screens, components, data
│   ├── categories/                    # screens, components, data
│   ├── products/                      # screens, components, controllers, api
│   ├── cart/                          # screens, components, controllers, api
│   ├── wishlist/                      # screens, controllers
│   ├── orders/                        # screens, components, controllers, api
│   ├── checkout/                      # screens, components, api
│   └── profile/                       # screens, components
├── widgets/
│   └── custom_floating_nav_bar.dart  # dark floating pill nav bar
assets/images/logo/                    # Blue-and-White Panda Waving.png, Blue-and-White Panda LoveB.png
test/                                  # 65 widget & unit tests across all features, components, and controllers
```

## 4. Key files and how to use them

**Colors** — `AppColors` in `core/constants/colors.dart`: `primary #2563EB`, `primaryDark`, `primaryLight`, `background`, `surface`, `textPrimary`, `textSecondary`, `textMuted`, `border #E5E7EB`, `error`, `facebook`, `apple`.

**Auth widgets**
- `AuthTextField(label, hintText, prefixIcon, isPassword, controller, keyboardType, validator, textInputAction, onFieldSubmitted, textCapitalization)` — rounded outline field; password eye toggle is built in.
- `AuthPrimaryButton` — full-width blue button. `SocialLoginButtons` — Google / Facebook / Apple circles.
- `LoginForm` — modular reusable login form.
- `LoginScreen` and `RegisterScreen` are StatefulWidgets with a `Form` + validators.

**Home data** — `home_mock_data.dart` defines models `HomeCategory`, `PromoBanner`, `HomeProduct` (has `copyWith`) and lists `mockCategories`, `mockPromoBanners`, `mockProducts`. **To change what the shop shows, edit these lists only.**

**Home components** (all take plain parameters + callbacks, no global state):
`HomeHeader`, `HomeSearchBar`, `HomePromoCarousel`, `HomeCategoriesBar`, `HomeProductCard`, `HomeBottomNavBar`.

**Navigation bar** — `CustomFloatingNavBar(items, initialIndex, onItemSelected, scale, shellColor, activeColor)`:
- Dark pill (`#18181A` by default; Home overrides with navy/blue), active tab shows icon + label, inactive tabs icon only, 250 ms `easeOutCubic` animation.
- `HomeBottomNavBar` wraps it with 5 shop tabs (Home, Wishlist, Cart, Orders, Profile) and `scale: 1.2`.

## 5. Coding rules Gemini must follow
1. Keep the **feature-first** structure: screens in `screens/`, reusable pieces in `components/`, data in `data/`.
2. Use `AppColors` — never hard-code the blue; use `.withValues(alpha: ...)` (not `.withOpacity`).
3. Keep rounded style (radius 16–18), clean white UI, generous spacing, Lucide or Material rounded icons.
4. Prefer small, readable, well-commented widgets. The owner is a beginner and wants code that is **easy to change**.
5. Put editable text/data in one clear place (like `home_mock_data.dart`), not scattered.
6. Do not rewrite or rename existing files unless asked; preserve the user's edits (e.g. branding text, logo size 150, "Confirm Password" label).
7. After every change: run `analyze_files` (must be 0 errors) and `run_tests` (currently 43 pass). Update the matching file in `test/` when UI text/icons change.
8. Add new packages only when needed (`flutter pub add`).

## 6. Known gotchas
- Tests use `MyApp` (starts at Login) and `HomeScreen` directly.
- Inactive nav tabs have no text, so tests find them by icon (e.g. `LucideIcons.shoppingBag`).
- In tests, the Home header notification badge is `5` and the cart badge starts at `2` — keep them different so `find.text` stays unique.
- Tests share static `SessionStorage.currentUser`; `setUp` in the test file resets it and mocks `SharedPreferences`.
- Product images use `Image.network` with an icon fallback; mock data mostly uses icons.
- `HomePromoCarousel` is 175 px high to avoid overflow in tests.

## 7. Ready-to-use prompt template

```
You are helping me with my Flutter e-commerce app "ShopPanda".
Read GEMINI.md first. Follow its structure and coding rules.

Task: <describe the screen or change>
Design: <clean, modern, blue #2563EB, rounded 16, white background>
Put new files in: lib/features/<feature>/{screens,components,data}/
Requirements:
- Use AppColors and existing components where possible.
- Keep the code simple and easy for me to change.
- Update tests and make sure analyze has 0 errors.
```
