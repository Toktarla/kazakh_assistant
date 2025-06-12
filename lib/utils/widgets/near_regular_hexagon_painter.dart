import 'package:flutter/material.dart';

class NearRegularHexagonPainter extends CustomPainter {
  final Color color;

  NearRegularHexagonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.fill;

    final path = Path();
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final points = [
      Offset(centerX, centerY - radius),
      Offset(centerX + radius * 0.7, centerY - radius * 0.5),
      Offset(centerX + radius * 0.7, centerY + radius * 0.55),
      Offset(centerX, centerY + radius),
      Offset(centerX - radius * 0.7, centerY + radius * 0.5),
      Offset(centerX - radius * 0.7, centerY - radius * 0.49),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    for (int i = 1; i < 6; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}