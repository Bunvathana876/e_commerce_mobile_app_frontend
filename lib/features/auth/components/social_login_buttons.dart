import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;
  final VoidCallback? onAppleTap;

  const SocialLoginButtons({
    super.key,
    this.onGoogleTap,
    this.onFacebookTap,
    this.onAppleTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircleButton(
          onTap: onGoogleTap,
          isDark: isDark,
          child: const _GoogleVectorLogo(size: 22),
        ),
        const SizedBox(width: 18),
        _SocialCircleButton(
          onTap: onFacebookTap,
          isDark: isDark,
          child: const Icon(
            Icons.facebook,
            color: AppColors.facebook,
            size: 28,
          ),
        ),
        const SizedBox(width: 18),
        _SocialCircleButton(
          onTap: onAppleTap,
          isDark: isDark,
          child: Icon(
            Icons.apple,
            color: isDark ? Colors.white : AppColors.apple,
            size: 28,
          ),
        ),
      ],
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final bool isDark;

  const _SocialCircleButton({
    required this.child,
    this.onTap,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap ?? () {},
          child: Center(child: child),
        ),
      ),
    );
  }
}

class _GoogleVectorLogo extends StatelessWidget {
  final double size;

  const _GoogleVectorLogo({this.size = 22});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleVectorLogoPainter()),
    );
  }
}

class _GoogleVectorLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double center = size.width / 2;
    final double radius = size.width / 2;
    final double strokeWidth = size.width * 0.22;
    final Rect rect = Rect.fromCircle(
      center: Offset(center, center),
      radius: radius - (strokeWidth / 2),
    );

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Red arc (Top)
    paint.color = const Color(0xFFEA4335);
    canvas.drawArc(rect, 3.14159 * 1.15, 3.14159 * 0.75, false, paint);

    // Yellow arc (Bottom-Left)
    paint.color = const Color(0xFFFBBC05);
    canvas.drawArc(rect, 3.14159 * 0.65, 3.14159 * 0.5, false, paint);

    // Green arc (Bottom-Right)
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(rect, 3.14159 * 0.15, 3.14159 * 0.5, false, paint);

    // Blue arc (Right)
    paint.color = const Color(0xFF4285F4);
    canvas.drawArc(rect, -3.14159 * 0.15, 3.14159 * 0.3, false, paint);

    // Blue horizontal bar
    final Paint barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;

    final double barHeight = strokeWidth;
    final double barLeft = center - (strokeWidth * 0.2);
    final double barTop = center - (barHeight / 2);
    final double barWidth = radius + (strokeWidth * 0.2);

    canvas.drawRect(
      Rect.fromLTWH(barLeft, barTop, barWidth, barHeight),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
