import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proj_management_project/config/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../utils/my_pdf_viewer.dart';

class BookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsPage({Key? key, required this.bookData}) : super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  final GlobalKey _releaseDateKey = GlobalKey();
  double _backgroundHeight = 300; // начальное значение

  bool _showFullSynopsis = false;

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final cleaned = rawDate.replaceAll(RegExp(r'[^\d\-]'), '-');
      final parsed = DateTime.parse(cleaned);
      return DateFormat.yMMMMd().format(parsed);
    } catch (e) {
      return '';
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateBgHeight());
  }

  void _calculateBgHeight() {
    final RenderBox? box =
        _releaseDateKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      final position = box.localToGlobal(Offset.zero);
      setState(() {
        _backgroundHeight = position.dy + box.size.height + 24;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.bookData;

    final rating = (data['rating'] ?? 0).toStringAsFixed(1);
    final pages = data['pages']?.toString() ?? '-';
    final date = _formatDate(data['releaseDate']?.toString());

    final primaryColor = Theme.of(context).primaryColor;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: const DividerThemeData(
          color: Colors.transparent,
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Text(data['title'], overflow: TextOverflow.ellipsis),
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w600),
          elevation: 0,
        ),
        extendBody: true,
        body: Stack(
          children: [
            if (data['imageUrl'] != null &&
                data['imageUrl'].toString().isNotEmpty)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _backgroundHeight,
                  child: Opacity(
                    opacity: .15,
                    child: Image.network(
                      data['imageUrl'],
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),
              ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (data['imageUrl'] != null &&
                        data['imageUrl'].toString().isNotEmpty)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          data['imageUrl'],
                          height: 180,
                          width: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 180,
                            width: 120,
                            color: Colors.grey.shade300,
                            child: const Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),

                    // Author & date
                    Text(
                      'Author'.tr(args: [data['author'] ?? 'Unknown'.tr()]),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (date.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          date,
                          key: _releaseDateKey,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.grey),
                        ),
                      ),
                    const SizedBox(height: 24),

                    // Info row
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _InfoItem(
                              icon: Icons.star, label: rating, suffix: '/5'),
                          _VerticalDivider(),
                          _InfoItem(
                              icon: Icons.menu_book_outlined,
                              label: pages,
                              suffix: ' pages'),
                          _VerticalDivider(),
                          _InfoItem(
                              icon: Icons.visibility_outlined,
                              label: (data['reads'] ?? '—').toString(),
                              suffix: ' read'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Synopsis
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Synopsis'.tr(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    const SizedBox(height: 8),
                    AnimatedCrossFade(
                      firstChild: Text(
                        data['description'] ?? '',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      secondChild: Text(
                        data['description'] ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      crossFadeState: _showFullSynopsis
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 250),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _showFullSynopsis = !_showFullSynopsis;
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _showFullSynopsis ? 'Show Less' : 'Show More',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          Icon(_showFullSynopsis
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (data['link'] != null &&
                          data['link'].toString().endsWith('.pdf')) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PdfViewerPage(
                                title: data['title'],
                                url: data['link']
                            ),
                          ),
                        );
                      } else {
                        final uri = Uri.parse(data['link'] ?? '');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                             SnackBar(content: const Text('Cannot open link').tr()),
                          );
                        }
                      }
                    },
                    child: Text('Continue Reading',
                        style: Theme.of(context).textTheme.displayMedium).tr(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String suffix;

  const _InfoItem({required this.icon, required this.label, this.suffix = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber.shade700, size: 20),
        const SizedBox(width: 4),
        RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium,
            children: [
              TextSpan(
                  text: label,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              TextSpan(
                  text: suffix, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 36, color: Colors.grey.shade300);
  }
}
