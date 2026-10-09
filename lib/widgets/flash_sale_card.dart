import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Flash sale card with countdown timer styling, lightning icon,
/// discount details and tap interaction.
class FlashSaleCard extends StatelessWidget {
  final VoidCallback? onTap;

  const FlashSaleCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingXl,
        vertical: AppTheme.spacingSm,
      ),
      child: Semantics(
        label:
            'Flash sale banner: Ends in 2 hours 45 minutes 12 seconds. Up to 70% off.',
        button: true,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingLg,
              vertical: AppTheme.spacingMd,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              border: Border.all(
                color: AppTheme.primary.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryDark.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bolt Icon in glowing badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Color(0xFFFBBF24),
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMd),

                // Text: Flash Sale Ends In + Deals info
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Flash Sale',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Up to 70% off today',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Colors.white70,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppTheme.spacingSm),

                // Countdown digit boxes
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _CountdownBox(text: '02'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _CountdownBox(text: '45'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    _CountdownBox(text: '12'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownBox extends StatelessWidget {
  final String text;

  const _CountdownBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3.5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}
