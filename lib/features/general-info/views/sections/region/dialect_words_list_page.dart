import 'package:flutter/material.dart';
import 'package:proj_management_project/config/data.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';

class DialectWordsListPage extends StatelessWidget {
  final String regionId;

  const DialectWordsListPage({
    super.key,
    required this.regionId,
  });

  @override
  Widget build(BuildContext context) {
    final localeCode = Localizations.localeOf(context).languageCode;
    final supportedLocales = ['kk', 'ru', 'en'];
    final langCode = supportedLocales.contains(localeCode) ? localeCode : 'kk';

    final words = dialectWords;

    final localizedRegion = localizedRegions[regionId]?[langCode] ?? regionId;
    final localizedDialect = localizedStrings['dialect']?[langCode] ?? 'Dialect';
    final localizedStandard = localizedStrings['standard']?[langCode] ?? 'Standard';
    final localizedCategory = localizedStrings['category']?[langCode] ?? 'Category';
    final localizedNoWords = localizedStrings['noWords']?[langCode] ?? 'No words for this category';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedRegion),
        elevation: 2,
      ),
      body: words.isEmpty
          ? Center(
        child: Text(
          localizedNoWords,
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        itemCount: words.length,
        separatorBuilder: (_, __) => const SizedBox(height: 20),
        itemBuilder: (_, index) {
          final word = words[index];

          final standardWord = word.localizations[langCode] ?? word.localizations['kk'] ?? '';
          final dialectWord = word.regionDialects[regionId] ?? standardWord;

          final meaning = word.meanings[langCode] ?? '';

          final examples = context.localizedValueList(
            en: word.examples[langCode],
            ru: word.examples[langCode],
            kz: word.examples[langCode],
          ) ?? [];

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                const BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialect Word with Icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.language),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "$localizedDialect: $dialectWord",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Standard Word
                Row(
                  children: [
                    const Icon(Icons.check_circle_outline, size: 20),
                    const SizedBox(width: 6),
                    Text(
                      "$localizedStandard: $standardWord",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                if (meaning.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    "Meaning:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    meaning,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
                if (examples.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    "Example${examples.length > 1 ? 's' : ''}:",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Show examples as bulleted list
                  ...examples.map(
                        (ex) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '• ',
                            style: TextStyle(
                              fontSize: 18,
                              height: 1.4,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              ex,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
