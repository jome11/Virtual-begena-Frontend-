import 'dart:math' as math;
import 'package:flutter/material.dart';

/// An authentic Ethiopian manuscript braid painter ("ሐረግ")
/// using traditional liturgical colors: Red (#C8102E), Blue (#0033A0),
/// Gold (#FCD116), and Green (#007A3D).
class HaregBraidPainter extends CustomPainter {
  final double strokeWidth;
  final double opacity;

  HaregBraidPainter({
    this.strokeWidth = 6.0,
    this.opacity = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final double amplitude = (size.height / 2 - strokeWidth / 2).clamp(2.0, 24.0);
    const double frequency = 0.035;

    // Traditional Ethiopian color palette
    final List<Color> colors = [
      const Color(0xFFC8102E).withValues(alpha: opacity), // Red
      const Color(0xFF0033A0).withValues(alpha: opacity), // Blue
      const Color(0xFFFCD116).withValues(alpha: opacity), // Gold/Yellow
      const Color(0xFF007A3D).withValues(alpha: opacity), // Green
    ];

    for (int i = 0; i < colors.length; i++) {
      final Paint paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final Path path = Path();
      final double phaseShift = i * (math.pi / 2);

      for (double x = 0; x <= size.width; x += 1.0) {
        final double y = size.height / 2 +
            amplitude * math.sin(frequency * x + phaseShift);
        if (x == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HaregBraidPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth || oldDelegate.opacity != opacity;
  }
}

/// A reusable header band displaying the traditional Ethiopian Hareg braid motif.
class HaregHeader extends StatelessWidget {
  final double height;
  final double strokeWidth;
  final double opacity;
  final EdgeInsetsGeometry? margin;

  const HaregHeader({
    super.key,
    this.height = 32.0,
    this.strokeWidth = 6.0,
    this.opacity = 0.9,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: HaregBraidPainter(
          strokeWidth: strokeWidth,
          opacity: opacity,
        ),
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    return content;
  }
}
