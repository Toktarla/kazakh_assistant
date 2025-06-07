import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_colors.dart';
import '../../config/di/injection_container.dart';

class TabBarBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bool isDarkMode = sl<SharedPreferences>().getBool('isDarkMode') ?? false;

    final List<Color> colors = isDarkMode
        ? [AppColors.blueColor, AppColors.darkBlueColor]
        : [Color(0xFF836FFF), Color(0xFF6B50FF)];

    final paint = Paint()
      ..shader = LinearGradient(
        colors: colors,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 20);

    // 1. Downward curve (dip)
    path.quadraticBezierTo(
      size.width * 0.15, size.height,
      size.width * 0.3, size.height - 20,
    );

    // 2. Upward curve (bump)
    path.quadraticBezierTo(
      size.width * 0.45, size.height - 40,
      size.width * 0.6, size.height - 20,
    );

    // 3. Downward again (second dip)
    path.quadraticBezierTo(
      size.width * 0.75, size.height,
      size.width, size.height - 20,
    );

    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
