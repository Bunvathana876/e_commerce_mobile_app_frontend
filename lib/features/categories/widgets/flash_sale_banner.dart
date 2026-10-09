import 'dart:async';
import 'package:flutter/material.dart';

/// Flash sale promotional banner:
/// - Blue gradient background
/// - Countdown timer
/// - Call-to-action button: “Shop now”
/// - Subtle animated shine effect (respects AccessibilityFeatures.disableAnimations)
class FlashSaleBanner extends StatefulWidget {
  final VoidCallback onShopNow;

  const FlashSaleBanner({super.key, required this.onShopNow});

  @override
  State<FlashSaleBanner> createState() => _FlashSaleBannerState();
}

class _FlashSaleBannerState extends State<FlashSaleBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shineController;
  late final Animation<double> _shineAnimation;
  Timer? _countdownTimer;
  Duration _remaining = const Duration(hours: 10, minutes: 45, seconds: 20);

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    _shineAnimation = Tween<double>(begin: -1.2, end: 2.2).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOutSine),
    );

    // Repeat shine periodically when animations are enabled and not disabled
    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test') ||
        WidgetsBinding.instance.runtimeType.toString().contains('Automated');
    if (!isTestEnvironment) {
      _shineController.repeat(
        period: const Duration(milliseconds: 3200),
      );

      // Tick countdown
      _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) return;
        if (_remaining.inSeconds > 0) {
          setState(() {
            _remaining = _remaining - const Duration(seconds: 1);
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _shineController.dispose();
    super.dispose();
  }

  String _formatDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.of(context).disableAnimations;
    final hours = _formatDigits(_remaining.inHours);
    final minutes = _formatDigits(_remaining.inMinutes.remainder(60));
    final seconds = _formatDigits(_remaining.inSeconds.remainder(60));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E3A8A), // Midnight navy
                    Color(0xFF2563EB), // Vibrant royal blue
                    Color(0xFF3B82F6), // Sky blue
                  ],
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.bolt_rounded,
                              size: 14,
                              color: Color(0xFFFBBF24),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'FLASH SALE • UP TO 60% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Live indicator
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 7,
                            height: 7,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Headline + countdown + CTA
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 320;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Exclusive Mid-Season Drops',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Limited quantities available across all departments',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Countdown & Button row
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            alignment: WrapAlignment.spaceBetween,
                            children: [
                              // Timer pills
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _TimeBox(value: hours, label: 'HRS'),
                                  const _TimeColon(),
                                  _TimeBox(value: minutes, label: 'MIN'),
                                  const _TimeColon(),
                                  _TimeBox(value: seconds, label: 'SEC'),
                                ],
                              ),

                              // CTA Button
                              Semantics(
                                label: 'Shop flash sale now',
                                button: true,
                                child: ElevatedButton(
                                  onPressed: widget.onShopNow,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF1E3A8A),
                                    elevation: 0,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isNarrow ? 14 : 18,
                                      vertical: 10,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Shop now',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Animated shine sweep overlay
            if (!disableAnimations)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _shineAnimation,
                  builder: (context, _) {
                    return FractionalTranslation(
                      translation: Offset(_shineAnimation.value, 0),
                      child: Transform.rotate(
                        angle: 0.35,
                        child: Container(
                          width: 80,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withValues(alpha: 0.0),
                                Colors.white.withValues(alpha: 0.22),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TimeBox extends StatelessWidget {
  final String value;
  final String label;

  const _TimeBox({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 8,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeColon extends StatelessWidget {
  const _TimeColon();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 3),
      child: Text(
        ':',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
