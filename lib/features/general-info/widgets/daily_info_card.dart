import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:proj_management_project/config/app_colors.dart';

class DailyItemCard<T> extends StatelessWidget {
  final String title;
  final T? item;
  final String Function(T) getContent;
  final String? Function(T)? getMeaning;
  final IconData icon;
  final Color? bgColor;
  final Color? textColor;
  final Color? iconColor;
  final Map<String, Object?> Function(T)? getDetails;

  const DailyItemCard({
    super.key,
    required this.title,
    required this.item,
    required this.getContent,
    this.getMeaning,
    this.getDetails,
    this.bgColor,
    this.iconColor = Colors.cyan,
    this.textColor = Colors.white,
    this.icon = Icons.auto_stories,
  });

  void _showDetailsDialog(BuildContext context) {
    if (item == null || getDetails == null) return;

    final details = getDetails!(item!);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        elevation: 10,
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: SizedBox(
                        child: Lottie.asset('assets/lottie/learning-boy.json'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      getContent(item!),
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: details.entries
                          .where((e) => e.value != null)
                          .map((e) {
                        final value = e.value;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  e.key,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: 4),
                              if (value is String && value.isNotEmpty)
                                Center(
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: theme.colorScheme.onSurface.withOpacity(0.8),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              else if (value is List<String> && value.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: value
                                      .map((item) => Padding(
                                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "• $item",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: theme.colorScheme.onSurface.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                                      .toList(),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Close icon in top right
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: theme.colorScheme.onSurface,
                onPressed: () => Navigator.pop(context),
                tooltip: 'Close'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox.shrink();

    final content = getContent(item!);
    final meaning = getMeaning?.call(item!);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () => _showDetailsDialog(context),
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.blueAccent.withOpacity(0.1),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: bgColor ?? const Color(0xFFEFF1F5),
            borderRadius: BorderRadius.circular(50),
            boxShadow: const [
              BoxShadow(
                color: Colors.white,
                offset: Offset(-4, -4),
                blurRadius: 8,
              ),
              BoxShadow(
                color: Color(0xFFBDC2CB),
                offset: Offset(4, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: bgColor ?? const Color(0xFFEFF1F5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-2, -2),
                      blurRadius: 6,
                    ),
                    BoxShadow(
                      color: Color(0xFFBDC2CB),
                      offset: Offset(2, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Icon(icon, size: 30, color: iconColor),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        )),
                    const SizedBox(height: 8),
                    Text(content,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        )),
                    if (meaning != null && meaning.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          '"$meaning"',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: textColor?.withOpacity(0.7),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.arrow_forward_ios,
                color: iconColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
