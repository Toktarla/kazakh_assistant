import 'package:flutter/material.dart';
import 'package:path_drawing/path_drawing.dart';

import '../models/region.dart';

class MapPainter extends CustomPainter {
  final List<Region> regions;
  final String? selectedId;

  MapPainter(this.regions, this.selectedId);

  @override
  void paint(Canvas canvas, Size size) {
    if (regions.isEmpty) return;

    final paths = regions.map((r) => parseSvgPathData(r.path)).toList();
    final allBounds = paths
        .map((p) => p.getBounds())
        .reduce((a, b) => a.expandToInclude(b));

    final double scaleX = size.width / allBounds.width;
    final double scaleY = size.height / allBounds.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final Matrix4 transform = Matrix4.identity()
      ..translate(-allBounds.left, -allBounds.top)
      ..scale(scale, scale);

    for (int i = 0; i < regions.length; i++) {
      final region = regions[i];
      final path = paths[i].transform(transform.storage);

      final color = region.id == selectedId
          ? const Color.fromRGBO(136, 13, 13, 1.0)
          : _hexToColor(region.colorHex);

      final paint = Paint()..color = color;
      canvas.drawPath(path, paint);
    }
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
