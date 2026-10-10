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
21. UI/UX Modernization & Tier-1 Commercial Polish (Anti-AI Styling):
    - **Header & Search**: Replaced boxy saturated containers with slate neutral surfaces (`Color(0xFFF1F5F9)` light / `AppColors.darkSurface` dark), hairline borders (`Color(0xFFE2E8F0)` / `AppColors.darkBorder`), drop-down delivery chips, and refined circular actions.
    - **Cards & Catalogs**: Studio image tints (`Color(0xFFF8FAFC)` light / `Color(0xFF0F172A)` dark), 10px soft ambient shadows, uppercase category badge typography, and sleek circular Add-to-Cart buttons.
    - **Flash Sale & Deals**: High-end commercial midnight gradient card (`#1E3A8A` to `#2563EB`) with gold bolt icon, frosted countdown timeboxes, and glowing filter chips.
    - **Cart & Checkout**: Full dark/light adaptivity, hairline separators, tabular figures for price calculations, and modern payment selector cards.
    - **Categories Screen**: Polished search input, segmented view switcher, category rail navigation, and subcategory filter pills.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
22. Login & Register UI/UX Polish:
    - Ambient mascot glow containers (`105x105` - `140x140`), light/dark surface adaptivity, refined input typography and focus outlines, custom checkmark styling, and high-contrast social buttons. 0 analyzer issues, 63/63 passing tests.
23. Home Screen Premium UI/UX Polish:
    - Compact header with capsule location chip, elevated 50px search bar with ambient shadow, promotional carousel with "Shop Now" arrow pill and theme-adaptive pagination indicators, 44px category selector chips, midnight-to-royal-blue flash sale banner with glowing gold bolt, and product cards with rating, review count `(${product.reviewsCount})`, price hierarchy, discount tags, and 32px circular Add-to-Cart buttons. 0 analyzer issues, 63/63 passing tests.
24. Categories Screen Commercial UI/UX Polish:
    - **Visual Grid Mode**: 18px radius cards, soft ambient drop shadow, 46x46 gradient icon container with micro-border, badge pills with uppercase styling, bold typography (16.5px, -0.2 tracking), item count chip, subcategory tags with subtle borders, and "Explore Category →" call to action.
    - **Split Explorer Mode**: 92px left rail with left active indicator border (3.5px), glowing category icon active state, 220ms `AnimatedSwitcher` category transitions, 18px radius gradient hero banner with frosted badge, 12px radius filter chips with drop shadow, subcategory section header with item counter badge, and responsive 0.65 child aspect ratio product grid using `HomeProductCard`.
    - **Controls & UX**: 50px elevated search input with ambient shadow, 44px segmented tab pill switcher, full light and dark mode adaptation, zero layout overflows. 0 analyzer issues, 63/63 passing tests.
25. Deals & Flash Sale Screen Commercial UI/UX Polish:
    - **Countdown Hero Banner**: Replaced flat red container with ShopPanda signature midnight-navy-to-royal-blue gradient (`#0F172A` to `#2563EB`), gold bolt badge, and explicit Hours (`HRS`), Minutes (`MIN`), and Seconds (`SEC`) digit boxes with tabular figures.
    - **Deal of the Day**: Built a visually dominant hero deal card (`_FeaturedDealCard`) featuring studio image background, `-60%` discount pill, gold star rating, live stock progress bar (`⚡ Almost Gone! • Only 6 left in stock`), price savings badge (`Save $80.00`), and full-width `Claim Deal` button.
    - **Filter Chips**: High-contrast active royal blue capsule with soft glow shadow and unselected bordered cards.
    - **Product Grid**: Enhanced `_DealCard` with studio tinted background, micro stock tags, price hierarchy, and clean `Claim Deal` buttons with `0.58` aspect ratio to prevent overflow.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
26. Product Detail Screen Tier-1 Commercial UI/UX Polish:
    - **Product Image Presentation**: 330px high studio showcase with frosted circular back & share buttons, favorite heart toggle, and 3-dot pagination capsule indicators.
    - **Information Hierarchy**: Category badge with green "In Stock" indicator, 23px bold title, 5-star rating with review count and "Top Seller" pill, bold 30px current price, strikethrough original price, discount tag, dynamic savings pill (`Save $...`), and readable description.
    - **Options**: Interactive color selector with dynamic color name preview and checkmark inside selected swatch; size selector with active royal blue capsule, clear unselected borders, disabled strikethrough state, and "Size Guide" trigger.
    - **Trust Information**: Compact 3-item trust bar (Free Delivery, 100% Authentic, 30-Day Returns) with circular blue icon badges and `FittedBox` scale-down protection.
    - **Mobile-Friendly Bottom Action Area**: Persistent bottom bar with calculated total price (`_quantity * price`), full-width 52px "Add to Cart" button, and rounded quick "Buy Now" lightning action.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
27. Cart Screen Tier-1 Commercial UI/UX Polish:
    - **Cart Header & Badge**: Added dynamic item counter capsule (`${cart.totalCount} items`) beside "My Cart" title, and clear cart confirmation dialog.
    - **Product Rows (`CartItemRow`)**: 82x82 studio image container with subtle hairline border, bold 2-line title, category pill badge, dynamic unit pricing (`$XX each`) when quantity > 1, accessible `QuantityStepper`, and circular red trash button.
    - **Free Shipping Progress Banner**: Clean progress bar showing current progress, remaining amount toward $100 free delivery, and celebration state (`"Congratulations! You unlocked FREE shipping 🎉"`) with green checkmark.
    - **Promo Code & Voucher**: Modern 48px input with slate surface, tag icon, uppercase code handling, and green applied state with discount badge and quick remove icon.
    - **Order Summary & Checkout Button**: Subtotal, shipping, discount, and total in tabular figures with hairline divider, followed by 54px full-width royal blue Checkout button with forward chevron.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
28. Categories Screen Production-Grade Commercial Redesign:
    - **Fast Discoverability & Navigation**: Page title with friendly panda smile, 50px elevated search input with live query reset, and 44px segmented tab pill switcher (`All Categories` vs `Category Explorer`).
    - **Popular Categories Quick-Strip**: Horizontal scroll strip featuring top-shopped categories (Shoes, Fashion, Electronics, Bags) with circular gradient icons and touch ripple feedback for rapid one-tap navigation.
    - **Explore Departments Grid**: Clear visual hierarchy with 18px rounded department cards, studio icons, item count chips, and subcategory preview tags.
    - **Curated In-Category Product Shelf**: Built "Popular in Departments" product section directly below grid cards utilizing `HomeProductCard` with live pricing, review counters, Wishlist heart toggles, and Add to Cart action.
    - **Split Explorer Mode**: 92px left rail with glowing category icon and vertical active accent line, animated department transitions, high-contrast subcategory filter chips, and 2-column product grid.
    - **Layout Hardening & Verification**: Ellipsis protection on all section title rows preventing horizontal overflow; 110px bottom scroll padding for floating nav bar. 0 analyzer issues, 63/63 passing tests.
29. Categories Screen Reference UI Overhaul:
    - **Header**: Rounded square icon box (`AppColors.primary.withValues(alpha: 0.12)`, 42×42), bold 24sp "Categories" title, 13sp "Find what you love" muted subtitle, and minimalist shopping bag icon button with dynamic item count badge linking to Cart.
    - **Search Bar**: 50px pill input with 14px radius (`AppRadius.lg`), `LucideIcons.search`, "Search categories" placeholder, and quick clear action.
    - **Popular Carousel**: "Popular" header with "See all →", 150px rounded cards featuring curved top preview surfaces with studio icon presentation, bold category name, and item count.
    - **Shop by Category Grid**: "Shop by category" section with dynamic group counter, 2-column grid using redesigned `CategoryGridCard` with curved top preview surfaces, centered category icons, optional badges, bottom title, and disclosure chevron (`Icons.chevron_right_rounded`).
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
30. Categories Screen Minimalist & Clean Overhaul:
    - **4-Box Grid Default**: "Shop by category" displays exactly 4 category boxes initially for a clean, distraction-free view.
    - **"Show more categories" Toggle**: Added a clean text toggle button ("Show more categories" / "Show less") to reveal all categories without cluttering the screen.
    - **Visual-First Cards**: Removed noisy subtext, item counts, and badges from `CategoryGridCard` and `_PopularCategoryCard`; cards now focus entirely on studio image/icon surfaces with clean titles.
    - **De-cluttered**: Removed the bottom in-category product shelf from the categories screen to eliminate redundant product text and price walls.
    - **Verification**: 0 analyzer issues, 64/64 passing tests.
31. Categories Screen Ultra-Clean Visual-First Redesign:
    - **Removed Tab Switcher & Clutter**: Removed the "All Categories" / "Category Explorer" tab switcher, duplicate "Popular" carousel, subtitles, and section headers.
    - **Minimalist Text**: The page contains only "Categories" in the app bar, a single-word "Search" bar, 1-word category names ("Fashion", "Shoes", "Bags", etc.), and a simple "Show more" / "Show less" toggle.
    - **Image/Icon as Hero**: Large 60×60 studio icons with ambient glowing backdrops inside 18px rounded cards convey the categories visually without walls of text.
    - **Seamless Navigation**: Tapping any category box displays that department's product feed with a clean back button to return to the 4-box grid.
    - **Verification**: 0 analyzer issues, 64/64 passing tests.
32. Categories Screen Exact Reference UI Alignment:
    - **Pixel-Accurate Header**: Circular light blue icon container (`0xFFDCEBFE`) with royal blue 4-square grid icon (`0xFF2563EB`), bold 25sp "Categories" title, 13.5sp "Find what you love" subtitle, and minimalist shopping bag icon button.
    - **Pill Search Bar**: 52px tall, 18px radius, off-white fill (`0xFFF8FAFC`), hairline border (`0xFFE2E8F0`), search icon, and "Search categories" hint.
    - **"Popular" Horizontal Strip**: "Popular" header with royal blue "See all →", 148px wide rounded cards (20px radius) with actual photographic preview images cropped from reference (Fashion, Shoes, Bags), bold title, and item count ("84 items", "56 items", "42 items").
    - **"Shop by category" 4-Group Grid**: 2-column grid showing exactly 4 photographic preview cards (Fashion, Shoes, Bags, Electronics) with curved top image surfaces and bottom title + chevron rows.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
33. Home Screen Modern UI/UX Polish:
    - **Header & Location**: Streamlined user avatar with hairline border and soft ambient shadow, clean location pill chip with off-white fill (`0xFFF8FAFC`) and refined typography.
    - **Search & Filters**: 50px rounded input with subtle neutral surface (`0xFFF8FAFC`), hairline border (`0xFFE2E8F0`), and soft ambient shadow.
    - **Visual Hierarchy**: Balanced spacing between banners, category selector chips, flash sale countdown ticker, and 2-column product grid with 100px bottom navigation padding.
    - **Verification**: 0 analyzer issues, 63/63 passing tests.
34. Clean Modern Modular Shopping Home Screen:
    - **Architecture & Structure**: Created clean, modular components conforming directly to project specifications:
      - `lib/theme/app_theme.dart`: Material 3 theme, primary royal blue (`#2563EB`), midnight navy text (`#0F172A`), soft background (`#F8FAFC`), spacing & radius constants.
      - `lib/models/product.dart`: Modern `Product` domain model with discount badge, ratings, placeholder gradients, and favorite status.
      - `lib/data/sample_products.dart`: Sample products catalog with local image assets and gradient fallbacks.
      - `lib/widgets/home_header.dart` (`HomeHeaderWidget`): Avatar, “Welcome, Lee”, “Phnom Penh, Cambodia” location chip, notification & bag icons with badges.
      - `lib/widgets/search_bar.dart` (`CustomSearchBar`): 48px search field + adjacent filter button opening filter bottom sheet.
      - `lib/widgets/weekend_edit_banner.dart` (`WeekendEditBanner`): “Weekend Edit” promo card with “30% off” badge, “Claim coupon” button, and floating collage image respecting reduce motion accessibility.
      - `lib/widgets/category_selector.dart` (`CategorySelector`): “Shop by category” horizontal list (All, Fashion, Shoes, Electronics) with tap filters.
      - `lib/widgets/flash_sale_card.dart` (`FlashSaleCard`): Midnight gradient card with lightning icon and countdown timeboxes.
      - `lib/widgets/product_card.dart` (`ProductCard`): Made for you product cards with ratings, prices, discount badges, and heart toggle.
      - `lib/widgets/bottom_navigation.dart` (`BottomNavigation`): Fixed SafeArea-aware 5-tab bar (Home, Categories, Deals, Favorites, Profile).
      - `lib/screens/home_screen.dart` (`HomeScreen`): Clean, responsive shopping home screen supporting viewport sizes down to 347x657 without overflow.
    - **Verification**: 0 static analyzer issues (`flutter analyze`), 68/68 passing tests (`flutter test`).
35. Built Full-Featured CategoriesPage & Sub-Widgets:
    - 7 reusable widgets in `lib/features/categories/widgets/` (`app_header.dart`, `search_categories.dart`, `filter_chips.dart`, `flash_sale_banner.dart`, `popular_categories.dart`, `category_grid.dart`, `category_detail_sheet.dart`, `app_bottom_navigation.dart`).
    - Responsive mobile and desktop viewport support, real-time query and chip filtering, animated bottom sheet with bestseller add-to-cart.
36. Settings Screen, Universal Dark Mode Unification & Clean Design Consistency:
    - **Settings Screen (`lib/features/settings/screens/settings_screen.dart`)**: Created a dedicated Settings screen accessible via Profile menu and `/settings` route. Features:
      - **Appearance**: Dark Mode / Light Mode toggle with instant theme synchronization via `ThemeController.instance`.
      - **Preferences**: Display currency switcher (USD `$`, EUR `€`, GBP `£`, KHR `៛`) with interactive bottom sheet modal; In-app sound effects toggle.
      - **Notifications**: Push notifications, live order status updates, and flash sale/promotions alerts toggles.
      - **Security & Storage**: Biometric quick login toggle (Face ID / Touch ID preference) and Clear Temporary Cache function with confirmation dialog and toast feedback.
      - **About**: App version indicator (`v1.0.0`) and Terms of Service / Privacy Policy information.
    - **Universal Dark Mode Support**:
      - Unified `lib/theme/app_theme.dart` with context-aware helpers (`getBackgroundColor`, `getCardBackground`, `getTextPrimary`, `getTextSecondary`, `getTextMuted`, `getBorder`) and `AppTheme.darkTheme`.
      - Updated `HomeScreen` and its widgets (`HomeHeaderWidget`, `CustomSearchBar`, `CategorySelector`, `ProductCard`, and filter/notification bottom sheets) to dynamically react to Dark Mode (`#0F172A` background, `#1E293B` cards, `#334155` borders, white text).
      - Updated `CategoriesPage` scaffold and container surfaces to dynamically adapt to dark mode.
    - **Consolidation**: Removed deprecated `categories_screen.dart` and its outdated test, consolidating all category navigation directly into the modular `CategoriesPage`.
    - **Clean UI & Material 3 Styling**: Unified 16px corner radiuses, soft subtle shadows, consistent typography, and clean contrast across all screens.
    - **Verification**: Zero analyzer warnings (`flutter analyze`), **76 passing tests** (`flutter test`).
36. Unified Screen Headers, Lazy Loading, Dead Code Cleanup & Lighthouse Web Optimization:
    - **Unified Screen Header Design Language**: Created `lib/components/header/app_screen_header.dart` (`AppScreenHeader` and `AppHeaderActionButton`) implementing `PreferredSizeWidget` with consistent 42×42 icon/avatar containers, clean title + subtitle hierarchy, dynamic counter pills, and 40×40 circular action buttons. Replaced fragmented default app bars across `DealsScreen`, `WishlistScreen`, `CartScreen`, `OrderHistoryScreen`, `ProfileScreen`, `SettingsScreen`, and `CheckoutScreen`.
    - **Lazy Loading & Layout Shift (CLS) Prevention**: Added explicit `cacheWidth` and `cacheHeight` bounds to `Image.asset` and `Image.network` across `ProductCard`, `HomeProductCard`, `CategoryGrid`, `CategoryDetailSheet`, `PopularCategories`, and `WeekendEditBanner`. Constrained images with fixed aspect ratio surfaces to eliminate layout jumps when assets decode.
    - **Dead Code Cleanup**: Safely removed obsolete unused files `lib/features/categories/components/category_grid_card.dart` and `lib/features/categories/data/category_data.dart`.
    - **Lighthouse Web Optimization**: Upgraded `web/index.html` with `<html lang="en">`, `<meta name="viewport">` with scale controls, SEO descriptions, theme color `#2563EB`, font preconnect tags (`fonts.googleapis.com`, `fonts.gstatic.com`), and an inlined non-blocking CSS loader container with smooth fade-out on `flutter-first-frame` to completely eliminate initial CLS. Upgraded `web/manifest.json` with official ShopPanda branding and PWA metadata.
    - **Verification**: 0 analyzer warnings (`flutter analyze`), **76/76 passing tests** (`flutter test`).
37. Professional Project Architecture, Barrel Exports & Categories Visual Alignment:
    - **Modular Barrel Exports**:
      - `lib/core/core.dart`: Barrel export for all constants (`AppColors`, `AppSpacing`, `AppRadius`), storage (`SessionStorage`), theme controller, currency formatting, validators, and core API client.
      - `lib/models/models.dart`: Barrel export for all domain models (`Product`, `Category`, `Cart`, `Order`, `User`, `Payment`, `Address`).
      - `lib/components/components.dart`: Barrel export for all reusable components (`AppScreenHeader`, `AppHeaderActionButton`, `CustomPrimaryButton`, `CustomInputField`, `StatusBadge`, `EmptyStateWidget`, `Shimmer`, `showAppToast`).
      - `lib/features/features.dart`: Barrel export for all primary screen endpoints and controllers.
    - **CategoriesPage Visual Alignment**:
      - Updated `AppHeader` to implement `PreferredSizeWidget` (`preferredSize: const Size.fromHeight(68)`) with `SafeArea(bottom: false, ...)` so it is pinned as `Scaffold.appBar: AppHeader(...)` just like `DealsScreen`, `WishlistScreen`, `CartScreen`, and `ProfileScreen`.
      - Wrapped the greeting and title Column in `FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft)` to prevent RenderFlex overflow across varying device dimensions.
      - Aligned background surfaces to `isDark ? AppColors.darkBackground : AppColors.background` (`#0F172A` / `#F8FAFC`).
      - Replaced outer desktop card borders with clean content-level max-width centering (`ConstrainedBox(constraints: BoxConstraints(maxWidth: isDesktop ? 900 : double.infinity))`), giving full-bleed layout continuity across all tabs.
      - Maintained `110px` bottom scroll clearance ensuring content is never obscured by the frosted glass floating bottom navigation bar.
    - **Verification**: 0 analyzer warnings (`flutter analyze`), **76/76 passing tests** (`flutter test`).

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
