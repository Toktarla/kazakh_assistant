import 'package:flutter/material.dart';

class BlobBackground extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color leftColor;
  final Color rightColor;

  const BlobBackground({
    required this.icon,
    required this.iconColor,
    required this.leftColor,
    required this.rightColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BlobPainter(leftColor, rightColor),
      child: Center(
        child: Icon(icon, size: 45, color: iconColor),
      ),
    );
  }
}

class BlobPainter extends CustomPainter {
  final Color leftColor;
  final Color rightColor;

  BlobPainter(this.leftColor, this.rightColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paintLeft = Paint()..color = leftColor;
    final paintRight = Paint()..color = rightColor;

    final pathLeft = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.7, 0)
      ..quadraticBezierTo(size.width * 0.5, size.height * 0.5, 0, size.height)
      ..close();

    final pathRight = Path()
      ..moveTo(size.width * 0.3, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..quadraticBezierTo(size.width * 0.6, size.height * 0.5, size.width * 0.3, 0)
      ..close();

    canvas.drawPath(pathLeft, paintLeft);
    canvas.drawPath(pathRight, paintRight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

