import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:proj_management_project/features/general-info/models/phrase.dart';
import 'package:proj_management_project/features/general-info/views/sections/phrase/phrase_learning_page.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';

import '../../../../../config/di/injection_container.dart';

class PhrasesWidget extends StatefulWidget {
  const PhrasesWidget({Key? key}) : super(key: key);

  @override
  State<PhrasesWidget> createState() => _PhrasesWidgetState();
}

class _PhrasesWidgetState extends State<PhrasesWidget> {
  List<PhraseTheme> _data = [];
  int currentIndex = 0;
  final manager = sl<AppDataBoxManager>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure this only runs once
    if (_data.isEmpty) {
      _data = manager.getAllPhraseThemes();
    }
    print(_data);
  }

  IconData _getIconForIndex(int index) {
    const icons = [
      LucideIcons.smile,
      LucideIcons.heart,
      LucideIcons.sun,
      LucideIcons.moon,
      LucideIcons.star,
      LucideIcons.messageCircle,
      LucideIcons.thumbsUp,
      LucideIcons.award,
    ];
    return icons[index % icons.length];
  }
  void _nextTheme() {
    setState(() {
      currentIndex = ((currentIndex + 1) % _data.length);
    });
  }

  void _prevTheme() {
    if (currentIndex == 0) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      currentIndex = (currentIndex - 1 + _data.length) % _data.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isEmpty) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final themeData = _data[currentIndex];
    final types = themeData.phraseTypes;
    final theme = context.localizedValue(
      kz: themeData.themeKz,
      ru: themeData.themeRu,
      en: themeData.themeEn,
    ) ?? '';
    final description = context.localizedValue(
      kz: themeData.descriptionKz,
      ru: themeData.descriptionRu,
      en: themeData.descriptionEn,
    ) ?? '';

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.white10 : Colors.pink[200],
      appBar: const DefaultAppBar(),
      body: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// Indicator
            buildIndicator(
              context,
              currentIndex,
            ),
            const SizedBox(height: 24),

            /// Theme name and description
            Text(
              theme,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description!,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),

            /// Grid of types
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 8,
                childAspectRatio: 0.9,
                padding: const EdgeInsets.all(8),
                children: List.generate(types.length, (index) {
                  final item = types[index];
                  final type = context.localizedValue(
                    kz: item.typeKz,
                    ru: item.typeRu,
                    en: item.typeEn,
                  ) ?? '';
                  final phrases = item.phrases;

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PhraseLearningPage(
                                        phrases: phrases,
                                      )));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.08)
                                : Colors.white.withOpacity(0.2),
                            border: Border.all(
                              color: isDarkMode
                                  ? Colors.tealAccent.withOpacity(0.3)
                                  : Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            _getIconForIndex(index),
                            size: 28,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Expanded(
                        child: Text(
                          type!,
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                          softWrap: true,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),

      /// Prev / Next Buttons
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Prev
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                iconSize: 28,
                onPressed: _prevTheme,
              ),
            ),

            // Next
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_forward,
                  color: Colors.black87,
                ),
                iconSize: 28,
                onPressed: _nextTheme,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildIndicator(BuildContext context, int currentThemeIndex) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeCount = _data.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(themeCount, (index) {
        final isSelected = index == currentThemeIndex;
        const activeColor = Colors.white;
        final inactiveColor = Colors.grey.withOpacity(isDark ? 0.3 : 0.5);

        return Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Левая точка (только если активен)
              if (isSelected)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                ),
              // Линия
              Expanded(
                child: Container(
                  height: 6,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
              // Правая точка (только если активен)
              if (isSelected)
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: activeColor,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
