import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';

/// Friendly animated empty state widget featuring the ShopPanda mascot.
class PandaEmptyState extends StatefulWidget {
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;
  final String imageAsset;
  final double imageSize;

  const PandaEmptyState({
    super.key,
    this.title = "Your cart is lonely! Let's find some deals",
    this.message =
        "Looks like you haven't added anything yet. Explore our trending arrivals and grab your favorites!",
    this.buttonText = "Start Shopping",
    this.onButtonTap,
    this.imageAsset = 'assets/images/logo/Blue-and-White Panda LoveB.png',
    this.imageSize = 160,
  });

  @override
  State<PandaEmptyState> createState() => _PandaEmptyStateState();
}

class _PandaEmptyStateState extends State<PandaEmptyState>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8.0,
      end: 8.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Floating animated mascot with soft shadow
            AnimatedBuilder(
              animation: _floatAnimation,
              builder: (context, child) {
                final double currentOffset = _floatAnimation.value;
                final double shadowScale = 1.0 - (currentOffset + 8.0) / 40.0;

                return Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, currentOffset),
                      child: Container(
                        width: widget.imageSize,
                        height: widget.imageSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (isDark
                                      ? AppColors.darkCard
                                      : AppColors.homeSurface)
                                  .withValues(alpha: 0.8),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          widget.imageAsset,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.sentiment_dissatisfied_rounded,
                            size: widget.imageSize * 0.5,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Ambient ground shadow breathing with float
                    Transform.scale(
                      scaleX: shadowScale.clamp(0.6, 1.0),
                      child: Container(
                        width: widget.imageSize * 0.55,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: (isDark ? Colors.black : Colors.black)
                                  .withValues(alpha: isDark ? 0.4 : 0.08),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Title
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 10),

            // Subtitle
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),

            // Action Button
            if (widget.buttonText != null && widget.onButtonTap != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: widget.onButtonTap,
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: Text(widget.buttonText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Generic icon-based empty state (preserved for backwards compatibility).
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onButtonTap;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.homePrimaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: AppColors.homePrimary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: AppColors.textSecondary,
              ),
            ),
            if (buttonText != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.homePrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  minimumSize: const Size(180, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
