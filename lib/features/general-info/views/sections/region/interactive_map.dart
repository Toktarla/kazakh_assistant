import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/region_compare_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/region_information_bs.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/regional_dialect_types_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/regional_dialects_section.dart';
import 'package:proj_management_project/utils/get_color_hex.dart';
import 'package:xml/xml.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import '../../../models/map_mode.dart';
import '../../../models/region.dart';
import '../../../widgets/map_painter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  List<Region> regions = [];
  Region? selectedRegion;
  MapMode currentMode = MapMode.overview;

  @override
  void initState() {
    super.initState();
    loadRegions().then((data) {
      setState(() {
        regions = data;
      });
    });
  }

  Future<List<Region>> loadRegions() async {
    final content = await rootBundle.loadString('assets/svg/kzmap.svg');
    final document = XmlDocument.parse(content);
    final paths = document.findAllElements('path');
    final regions = <Region>[];

    for (var element in paths) {
      final partId = element.getAttribute("id") ?? "";
      if (partId.isEmpty) continue;
      final partPath = element.getAttribute('d').toString();
      final colorHex = element.getAttribute('fill')?.toUpperCase() ?? '#CCCCCC';
      regions.add(Region(id: partId, path: partPath, colorHex: colorHex));
    }

    return regions;
  }

  void _handleTap(Offset localPosition, Size size) {
    final paths = regions.map((r) => parseSvgPathData(r.path)).toList();
    final allBounds =
        paths.map((p) => p.getBounds()).reduce((a, b) => a.expandToInclude(b));

    final double scaleX = size.width / allBounds.width;
    final double scaleY = size.height / allBounds.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final Matrix4 transform = Matrix4.identity()
      ..translate(-allBounds.left, -allBounds.top)
      ..scale(scale, scale);

    for (int i = 0; i < paths.length; i++) {
      final path = paths[i].transform(transform.storage);
      if (path.contains(localPosition)) {
        setState(() {
          selectedRegion = regions[i];
        });

        if (currentMode == MapMode.dialects) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegionDialectTypesPage(
                  regionId: regions[i].id
              ),
            ),
          );
        } else if (currentMode == MapMode.overview) {
          RegionInformationBS.show(context,
              regionId: regions[i].id,
              color: hexToColor(regions[i].colorHex) ??
                  Theme.of(context).primaryColor);
        }

        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EDF5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Карта регионов Казахстана",
                style: GoogleFonts.montserrat(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              FadeIn(
                duration: const Duration(milliseconds: 800),
                child: Text(
                  "Нажмите на регион, чтобы узнать особенности его диалекта",
                  style: GoogleFonts.montserrat(
                      fontSize: 16, color: Colors.black54),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildModeButton("Обзор", MapMode.overview),
                  _buildModeButton("Диалекты", MapMode.dialects),
                  _buildModeButton("Сравнение", MapMode.compare),
                ],
              ),
              const SizedBox(height: 50),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return GestureDetector(
                        onTapDown: (details) {
                          final RenderBox box =
                              context.findRenderObject() as RenderBox;
                          final localPosition =
                              box.globalToLocal(details.globalPosition);
                          _handleTap(localPosition, box.size);
                        },
                        child: CustomPaint(
                          size:
                              Size(constraints.maxWidth, constraints.maxHeight),
                          painter: MapPainter(regions, selectedRegion?.id),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (currentMode == MapMode.compare)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegionComparePage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey.shade800,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Открыть режим сравнения",
                        style: GoogleFonts.montserrat(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String text, MapMode mode) {
    final isSelected = currentMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() => currentMode = mode);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
