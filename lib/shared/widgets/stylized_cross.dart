import 'package:flutter/material.dart';

/// A simplified, stylized cross silhouette silhouette.
class StylizedCross extends StatelessWidget {
  final double size;
  final Color color;
  const StylizedCross({super.key, required this.size, required this.color});

  @override
  Widget build(BuildContext context) =>
      CustomPaint(size: Size(size, size), painter: _CrossPainter(color: color));
}

class _CrossPainter extends CustomPainter {
  final Color color;
  _CrossPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final barW = size.width * 0.16;
    // vertical bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height / 2),
          width: barW,
          height: size.height * 0.82,
        ),
        Radius.circular(barW * 0.3),
      ),
      paint,
    );
    // horizontal bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width / 2, size.height * 0.42),
          width: size.width * 0.62,
          height: barW,
        ),
        Radius.circular(barW * 0.3),
      ),
      paint,
    );
    // four small circles at the arm ends
    final r = barW * 0.55;
    final ends = [
      Offset(size.width / 2, size.height * 0.09),
      Offset(size.width / 2, size.height * 0.91),
      Offset(size.width * 0.19, size.height * 0.42),
      Offset(size.width * 0.81, size.height * 0.42),
    ];
    for (final e in ends) {
      canvas.drawCircle(e, r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _CrossPainter old) => old.color != color;
}
