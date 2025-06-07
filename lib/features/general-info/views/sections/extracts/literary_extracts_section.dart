import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/config/app_colors.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/services/local/audio_player_service.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';

import '../../../../../config/di/injection_container.dart';
import '../../../../../config/variables.dart';
import '../../../models/literature_extract.dart';
import '../../../widgets/default_app_bar.dart';

class LiteraryExtractListPage extends StatefulWidget {

  const LiteraryExtractListPage({super.key});

  @override
  State<LiteraryExtractListPage> createState() => _LiteraryExtractListPageState();
}

class _LiteraryExtractListPageState extends State<LiteraryExtractListPage> {
  late List<LiteratureExtract> extracts;

  @override
  void initState() {
    super.initState();
    extracts = sl<AppDataBoxManager>().getAllExtracts();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const DefaultAppBar(),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: extracts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final extract = extracts[index];
          final title = context.localizedValue(
            kz: extract.titleKz,
            ru: extract.titleRu,
            en: extract.titleEn,
          ) ?? '';
          final author = context.localizedValue(
            kz: extract.authorKz,
            ru: extract.authorRu,
            en: extract.authorEn,
          ) ?? '';
          final imageUrl = extract.imageUrl;
          final hasImage = imageUrl != null && imageUrl.isNotEmpty;
          final cardColors = isDark ? darkCardColors : lightCardColors;

          final colorIndex = extract.hashCode % cardColors.length;
          final selectedColor = cardColors[colorIndex];

          return Card(
            elevation: 5,
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (_) => Dialog(
                  backgroundColor: Theme.of(context).cardColor,
                  elevation: 5,
                  insetPadding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: FullscreenExtractSheet(extract: extract),
                ),
              ),
              child: Row(
                children: [
                  // Image or icon
                  Container(
                    width: 110,
                    height: 110,
                    color: selectedColor,
                    child: hasImage
                        ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 40),
                    )
                        : const Icon(Icons.book, size: 40),
                  ),
                  const SizedBox(width: 12),
                  // Title & author
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title ?? '',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            author ?? '',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}


class FullscreenExtractSheet extends StatefulWidget {
  final LiteratureExtract extract;
  const FullscreenExtractSheet({required this.extract, super.key});

  @override
  State<FullscreenExtractSheet> createState() => _FullscreenExtractSheetState();
}

class _FullscreenExtractSheetState extends State<FullscreenExtractSheet> {
  int? selectedLineIndex;
  int? selectedKazakhWordIndex;
  int? selectedLocaleWordIndex;

  final audioService = AudioPlayerService();

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  void onWordTap(int lineIndex, int wordIndex, bool isKazakh) {
    setState(() {
      selectedLineIndex = lineIndex;

      if (isKazakh) {
        selectedKazakhWordIndex = wordIndex;
        // Find corresponding locale word index by matching translationIndex where Kazakh index == tapped wordIndex
        final mapping = context.localizedValueGeneric<List<List<int>>?>(
          kz: widget.extract.lines[lineIndex].translationIndexRu,
          ru: widget.extract.lines[lineIndex].translationIndexRu,
          en: widget.extract.lines[lineIndex].translationIndexEn,
        );
        // mapping = List<List<int>>, find where [0] == wordIndex, get [1]
        selectedLocaleWordIndex = mapping?.indexWhere((pair) => pair[0] == wordIndex) != -1
            ? mapping?.firstWhere((pair) => pair[0] == wordIndex)[1]
            : null;
      } else {
        selectedLocaleWordIndex = wordIndex;
        // Find corresponding Kazakh word index by matching translationIndex where locale index == tapped wordIndex
        final mapping = context.localizedValueGeneric<List<List<int>>?>(
          kz: widget.extract.lines[lineIndex].translationIndexRu,
          ru: widget.extract.lines[lineIndex].translationIndexRu,
          en: widget.extract.lines[lineIndex].translationIndexEn,
        );
        selectedKazakhWordIndex = mapping?.indexWhere((pair) => pair[1] == wordIndex) != -1
            ? mapping?.firstWhere((pair) => pair[1] == wordIndex)[0]
            : null;
      }
    });
  }

  Widget buildLine(List<String> words, List<String> translatedWords, int lineIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kazakh card
        SizedBox(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).cardColor,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(words.length, (wordIndex) {
                  final selected = selectedLineIndex == lineIndex &&
                      selectedKazakhWordIndex == wordIndex;
                  return GestureDetector(
                    onTap: () => onWordTap(lineIndex, wordIndex, true),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.yellowAccent.withValues(alpha: 0.4)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(words[wordIndex]),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),

        // Translated card
        SizedBox(
          width: double.infinity,
          child: Card(
            color: Theme.of(context).cardColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Wrap(
                spacing: 4,
                runSpacing: 4,
                children: List.generate(translatedWords.length, (wordIndex) {
                  final selected = selectedLineIndex == lineIndex &&
                      selectedLocaleWordIndex == wordIndex;
                  return GestureDetector(
                    onTap: () => onWordTap(lineIndex, wordIndex, false),
                    child: Container(
                      decoration: BoxDecoration(
                        color: selected
                            ? Theme.of(context).primaryColor.withOpacity(0.6)
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(translatedWords[wordIndex]),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final lines = widget.extract.lines;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColors = isDark ? darkCardColors : lightCardColors;

    // Choose color based on extract's hashCode to avoid index out of range
    final colorIndex = widget.extract.hashCode % cardColors.length;
    final selectedColor = cardColors[colorIndex];

    final imageUrl = widget.extract.imageUrl;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.85),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Colored Header with Image or Icon
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: hasImage
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.book, size: 60),
                    ),
                  ),
                ),
              )
                  : const Icon(Icons.book, size: 60),
            ),
            const SizedBox(height: 12),

            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 16,
              children: [
                Text(
                  context.localizedValue(
                      kz: widget.extract.titleKz,
                      ru: widget.extract.titleRu,
                      en: widget.extract.titleEn
                  ) ?? '',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  onPressed: () async {
                    await audioService.playAsset(widget.extract.audioUrl ?? "");
                  },
                  icon: Icon(
                    Icons.volume_up, color: Theme
                      .of(context)
                      .textTheme
                      .titleLarge!
                      .color,
                  )
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Lines
            ...List.generate(lines.length, (lineIndex) {
              final line = lines[lineIndex];
              final kz = line.kz?.cast<String>();
              final List<String> localeWords = context.localizedValueList(
                  kz: kz,
                  ru: line.ru?.cast<String>(),
                  en: line.en?.cast<String>()
              ) ?? [];

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: buildLine(kz ?? [], localeWords, lineIndex),
              );
            }),
          ],
        ),
      ),
    );
  }
}
