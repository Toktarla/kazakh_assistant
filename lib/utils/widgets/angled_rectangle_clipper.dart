import 'package:flutter/material.dart';

class AngledRectangleShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width - 20, 0); // Top right angled corner
    path.lineTo(size.width, size.height - 20); // Bottom right angled corner
    path.lineTo(0, size.height); // Bottom left corner
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

