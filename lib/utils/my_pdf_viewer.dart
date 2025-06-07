import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerPage extends StatelessWidget {
  final String url;
  final String title;

  const PdfViewerPage({super.key, required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SfPdfViewer.network(
          url,
          canShowScrollHead: true,
          pageLayoutMode: PdfPageLayoutMode.continuous,
          otherSearchTextHighlightColor: Colors.green,
          maxZoomLevel: 16,
          interactionMode: PdfInteractionMode.pan,
          enableTextSelection: true,
          canShowTextSelectionMenu: true,
          enableDoubleTapZooming: true,
      ),
    );
  }
}
