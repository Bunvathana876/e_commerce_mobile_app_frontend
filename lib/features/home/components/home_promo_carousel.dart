import 'package:flutter/material.dart';
import '../data/home_mock_data.dart';

/// Hero promotional banner slider with page dots.
class HomePromoCarousel extends StatefulWidget {
  final List<PromoBanner> banners;
  final ValueChanged<PromoBanner>? onBannerTap;

  const HomePromoCarousel({super.key, required this.banners, this.onBannerTap});

  @override
  State<HomePromoCarousel> createState() => _HomePromoCarouselState();
}

class _HomePromoCarouselState extends State<HomePromoCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: InkWell(
                  onTap: () => widget.onBannerTap?.call(banner),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: banner.gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: banner.gradientColors.first.withValues(
                            alpha: 0.3,
                          ),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Decorative Background Circles
                        Positioned(
                          right: -20,
                          bottom: -30,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                        ),

                        // Content
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18.0,
                            vertical: 14.0,
                          ),
                          child: Row(
                            children: [
                              // Left: Texts & Button
                              Expanded(
                                flex: 6,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.2,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                        ),
                                        child: Text(
                                          banner.tag,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        banner.title,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        banner.subtitle,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white.withValues(
                                            alpha: 0.9,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 4,
                                              offset: const Offset(0, 1.5),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              banner.buttonText,
                                              style: TextStyle(
                                                color:
                                                    banner.gradientColors.first,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 13,
                                              color:
                                                  banner.gradientColors.first,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Right: Panda Logo or Icon
                              Expanded(
                                flex: 4,
                                child: Center(
                                  child: banner.assetImage != null
                                      ? Image.asset(
                                          banner.assetImage!,
                                          height: 90,
                                          fit: BoxFit.contain,
                                          errorBuilder:
                                              (
                                                context,
                                                error,
                                                stackTrace,
                                              ) => Icon(
                                                banner.fallbackIcon ??
                                                    Icons.card_giftcard_rounded,
                                                size: 60,
                                                color: Colors.white,
                                              ),
                                        )
                                      : Icon(
                                          banner.fallbackIcon ??
                                              Icons.local_offer_rounded,
                                          size: 60,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),

        // Indicator Dots
        Builder(
          builder: (context) {
            final isDark = Theme.of(context).brightness == Brightness.dark;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.banners.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 22 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? widget.banners[_currentPage].gradientColors.first
                        : (isDark ? Colors.white24 : const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
