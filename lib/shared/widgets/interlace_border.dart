import 'package:flutter/material.dart';

/// A thin repeating diamond/interlace band, echoing the geometric borders
/// common in Ethiopian manuscript and textile art.
class InterlaceBorder extends StatelessWidget {
  final Color color;
  final double height;
  const InterlaceBorder({super.key, required this.color, this.height = 14});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _InterlacePainter(color: color)),
    );
  }
}

class _InterlacePainter extends CustomPainter {
  final Color color;
  _InterlacePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final unit = size.height;
    final count = (size.width / unit).ceil();
    for (int i = 0; i < count; i++) {
      final cx = i * unit + unit / 2;
      final path = Path()
        ..moveTo(cx - unit / 2, size.height / 2)
        ..lineTo(cx, 0)
        ..lineTo(cx + unit / 2, size.height / 2)
        ..lineTo(cx, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _InterlacePainter old) => old.color != color;
}
