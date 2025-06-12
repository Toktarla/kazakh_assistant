import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../../../config/data.dart';

class RegionComparePage extends StatefulWidget {
  const RegionComparePage({super.key});

  @override
  State<RegionComparePage> createState() => _RegionComparePageState();
}

class _RegionComparePageState extends State<RegionComparePage> {
  final List<String> regions = ["west", "east", "north", "south", "central"];
  String regionA = "west";
  String regionB = "east";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localeCode = Localizations.localeOf(context).languageCode;
    final supportedLocales = ['kk', 'ru', 'en'];
    final langCode = supportedLocales.contains(localeCode) ? localeCode : 'kk';

    final localizedRegionA = localizedRegions[regionA]?[langCode] ?? regionA;
    final localizedRegionB = localizedRegions[regionB]?[langCode] ?? regionB;
    final localizedCompareTitle = localizedCompareStrings['compareDialects']?[langCode] ?? 'Compare Dialects';
    final localizedVS = localizedCompareStrings['vs']?[langCode] ?? 'VS';
    final localizedFact = localizedCompareStrings['interestingFact']?[langCode] ?? '';

    // Filter dialectWords only those having dialect for at least one region? Or all? Here all:
    final filteredWords = dialectWords.where((word) {
      final standardWord = word.localizations[langCode] ?? word.localizations['kk'] ?? '';
      final dialectA = word.regionDialects[regionA] ?? standardWord;
      final dialectB = word.regionDialects[regionB] ?? standardWord;
      return dialectA != dialectB;
    }).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          _buildBackgroundEffects(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(
                            Icons.arrow_back,
                            size: 36,
                          ))),
                  Text(
                    localizedCompareTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildRegionSelectors(theme, langCode, localizedVS),
                  const SizedBox(height: 20),
                  Expanded(child: _buildWordComparisonList(filteredWords, theme, regionA, regionB, langCode)),
                  const SizedBox(height: 20),
                  _buildFooter(theme, localizedFact),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundEffects() {
    return Stack(
      children: [
        Positioned(
          top: -100,
          left: -50,
          child: _coloredBlurCircle(Colors.purpleAccent.withOpacity(0.3), 300),
        ),
        Positioned(
          bottom: -100,
          right: -50,
          child: _coloredBlurCircle(Colors.cyanAccent.withOpacity(0.3), 300),
        ),
      ],
    );
  }

  Widget _coloredBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }

  Widget _buildRegionSelectors(ThemeData theme, String langCode, String localizedVS) {
    // For the left dropdown, exclude regionB
    final leftDropdownRegions = regions.where((r) => r != regionB).toList();

    // For the right dropdown, exclude regionA
    final rightDropdownRegions = regions.where((r) => r != regionA).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _glassDropdown(
          value: regionA,
          onChanged: (v) {
            if (v != null) {
              setState(() {
                regionA = v;
                // Optional: if regionA == regionB, change regionB automatically:
                if (regionA == regionB) {
                  // Change regionB to something else (choose first different from regionA)
                  regionB = regions.firstWhere((r) => r != regionA);
                }
              });
            }
          },
          langCode: langCode,
          options: leftDropdownRegions,
        ),
        const SizedBox(width: 12),
        Text(localizedVS, style: theme.textTheme.titleMedium),
        const SizedBox(width: 12),
        _glassDropdown(
          value: regionB,
          onChanged: (v) {
            if (v != null) {
              setState(() {
                regionB = v;
                // Optional: if regionB == regionA, change regionA automatically:
                if (regionB == regionA) {
                  regionA = regions.firstWhere((r) => r != regionB);
                }
              });
            }
          },
          langCode: langCode,
          options: rightDropdownRegions,
        ),
      ],
    );
  }

  Widget _glassDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
    required String langCode,
    required List<String> options,  // <-- New param for filtered options
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        border: Border.all(color: Theme.of(context).primaryColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: Theme.of(context).cardColor,
          iconEnabledColor: Theme.of(context).primaryColor,
          style: Theme.of(context).textTheme.titleLarge,
          value: value,
          onChanged: onChanged,
          items: options
              .map((r) => DropdownMenuItem(
            value: r,
            child: Text(localizedRegions[r]?[langCode] ?? r),
          ))
              .toList(),
        ),
      ),
    );
  }


  Widget _buildWordComparisonList(List dialectWords, ThemeData theme, String regionA, String regionB, String langCode) {
    if (dialectWords.isEmpty) {
      return Center(child: Text('No words found'));
    }
    return ListView.separated(
      itemCount: dialectWords.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final word = dialectWords[index];

        // Get standard localized word (fallback to kk)
        final standardWord = word.localizations[langCode] ?? word.localizations['kk'] ?? '';

        // Dialect forms for selected regions, fallback to standard if missing
        final dialectA = word.regionDialects[regionA] ?? standardWord;
        final dialectB = word.regionDialects[regionB] ?? standardWord;

        // If dialect forms are the same, don't show this word
        if (dialectA == dialectB) {
          return const SizedBox.shrink();
        }

        return _glassWordCard(dialectA, standardWord, dialectB, theme);
      },
    );
  }

  Widget _glassWordCard(String left, String center, String right, ThemeData theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(child: Text(left, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
            Container(width: 1, height: 24, color: Theme.of(context).primaryColor),
            Expanded(child: Text(center, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
            Container(width: 1, height: 24, color: Theme.of(context).primaryColor),
            Expanded(child: Text(right, textAlign: TextAlign.center, style: theme.textTheme.bodyLarge)),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(ThemeData theme, String localizedFact) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.primaryColor.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          localizedFact,
          style: theme.textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
        ),
      ),
    );
  }
}
