import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Promotional banner card:
/// Title “Weekend Edit”, subtitle “Fresh picks, better prices.”,
/// product collage image with subtle floating animation (respects reduce motion),
/// “30% off” badge, and “Claim coupon” button.
class WeekendEditBanner extends StatefulWidget {
  final VoidCallback? onClaimCoupon;

  const WeekendEditBanner({super.key, this.onClaimCoupon});

  @override
  State<WeekendEditBanner> createState() => _WeekendEditBannerState();
}

class _WeekendEditBannerState extends State<WeekendEditBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _floatController;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );

    _floatAnimation = Tween<double>(begin: 0.0, end: -6.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Respect system reduce motion / accessibility settings
    final bool disableAnimations = MediaQuery.of(context).disableAnimations;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingSm,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          gradient: const LinearGradient(
            colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withValues(alpha: 0.28),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.radiusXl),
          child: Stack(
            children: [
              // Decorative background ambient rings
              Positioned(
                right: -25,
                top: -30,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
              ),
              Positioned(
                left: -20,
                bottom: -40,
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),

              // Content layout
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLg),
                child: Row(
                  children: [
                    // Left Column: 30% off badge, Title, Subtitle, Claim button
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 30% off badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3.5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFBBF24),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusSm,
                              ),
                            ),
                            child: const Text(
                              '30% OFF',
                              style: TextStyle(
                                color: Color(0xFF78350F),
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),

                          // Title: Weekend Edit
                          const Text(
                            'Weekend Edit',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 3),

                          // Subtitle: Fresh picks, better prices.
                          const Text(
                            'Fresh picks, better prices.',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Button: Claim coupon
                          Semantics(
                            label: 'Claim 30% discount coupon',
                            button: true,
                            child: InkWell(
                              onTap: widget.onClaimCoupon,
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMd,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMd,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1.5),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'Claim coupon',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppTheme.primaryDark,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 3),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 12,
                                      color: AppTheme.primaryDark,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSm),

                    // Right: Product collage image with subtle floating animation
                    Expanded(
                      flex: 4,
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _floatAnimation,
                          builder: (context, child) {
                            final offsetY = disableAnimations
                                ? 0.0
                                : _floatAnimation.value;
                            return Transform.translate(
                              offset: Offset(0, offsetY),
                              child: child,
                            );
                          },
                          child: Container(
                            height: 95,
                            width: 95,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusLg,
                              ),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            padding: const EdgeInsets.all(AppTheme.spacingSm),
                            child: Image.asset(
                              'assets/images/categories/fashion.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                    Icons.checkroom_rounded,
                                    size: 44,
                                    color: Colors.white,
                                  ),
                            ),
                          ),
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
  }
}
