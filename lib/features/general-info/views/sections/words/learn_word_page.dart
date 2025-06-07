import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/views/sections/words/beautiful_words_section.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../config/variables.dart';
import '../../../../../services/local/app_data_box_manager.dart';
import '../../../../../services/local/audio_player_service.dart';
import '../../../models/rare_kazakh_word.dart';
import '../../../widgets/default_app_bar.dart';

class LearnWordsPage extends StatefulWidget {
  final String title;
  final List<RareKazakhWord> words;
  final int typeId;
  final int contentTypeId;
  final Function? onWordLearned; // Add callback function

  const LearnWordsPage({
    super.key,
    required this.title,
    required this.typeId,
    required this.contentTypeId,
    required this.words,
    this.onWordLearned, // Optional callback when a word is learned
  });

  @override
  State<LearnWordsPage> createState() => _LearnWordsPageState();
}

class _LearnWordsPageState extends State<LearnWordsPage> {
  late List<RareKazakhWord> words;

  void _maybeShowTapGuide(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenGuide = prefs.getBool('hasSeenDoubleTapGuide') ?? false;

    if (!hasSeenGuide) {
      await showDialog(
        context: context,
        builder: (_) => _DoubleTapGuideDialog(),
      );
      await prefs.setBool('hasSeenDoubleTapGuide', true);
    }
  }


  @override
  void initState() {
    words = widget.words;
    super.initState();
    Future.delayed(Duration.zero, () {
      _maybeShowTapGuide(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppIconButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BeautifulWordSectionsPage(contentTypeIndex: widget.contentTypeId))),
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          ),
        )
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: words.length,
        itemBuilder: (context, index) {
          final wordData = words[index];
          return _WordTile(
            elementIndex: index,
            wordData: wordData,
            onWordLearned: () {
              // Call the callback when a word is learned
              if (widget.onWordLearned != null) {
                widget.onWordLearned!();
              }
            },
          );
        },
      ),
    );
  }
}

class _WordTile extends StatefulWidget {
  final RareKazakhWord wordData;
  final int elementIndex;
  final Function? onWordLearned;

  const _WordTile({
    required this.wordData,
    required this.elementIndex,
    this.onWordLearned,
  });

  @override
  State<_WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<_WordTile> {
  late RareKazakhWord wordData;
  final audioService = AudioPlayerService();
  final manager = sl<AppDataBoxManager>();

  @override
  void initState() {
    super.initState();
    wordData = widget.wordData;
  }

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    manager.toggleFavorite<RareKazakhWord>(
      wordData,
      manager.rareWordBox,
          (p) => p.isFavorite,
          (p, value) => p.isFavorite = value,
    );
    setState(() {});
  }

  void _markAsLearned() {
    bool wasLearned = wordData.isLearned;
    manager.toggleLearned(wordData, manager.rareWordBox);
    setState(() {});

    // Notify parent if the word's learned status changed to true
    if (!wasLearned && wordData.isLearned && widget.onWordLearned != null) {
      widget.onWordLearned!();
    }
  }



  @override
  Widget build(BuildContext context) {
    final word = wordData.word ?? '';
    final translation =  context.localizedValue(
      kz: wordData.meaningKz,
      ru: wordData.meaningRu,
      en: wordData.meaningEn,
    ) ?? '';
    final transcription = context.localizedValue(
      kz: wordData.etymologyKz,
      ru: wordData.etymologyRu,
      en: wordData.etymologyEn,
    ) ?? '';
    final isDarkMode = sl<SharedPreferences>().get('isDarkMode');
    final backgroundColor = isDarkMode != null
        ? lightCardColors[widget.elementIndex % lightCardColors.length]
        : darkCardColors[widget.elementIndex % darkCardColors.length];

    return GestureDetector(
      onDoubleTap: _markAsLearned,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: backgroundColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            leading: IconButton(
              icon: const Icon(Icons.volume_up, color: Colors.deepPurple),
              onPressed: () async {
                await audioService.playAsset(wordData.audioUrl ?? "");
              },
            ),
            minVerticalPadding: 8,
            title: Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "$word ",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        TextSpan(
                          text: "/[$transcription]/",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (wordData.isLearned)
                  const Icon(Icons.check_circle,
                      color: Colors.green, size: 20),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                translation,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    wordData.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: _toggleFavorite,
                ),
                const Icon(CupertinoIcons.right_chevron),
              ],
            ),
            onTap: () => showDialog(
              context: context,
              builder: (_) => _WordDetailDialog(
                wordData: wordData,
                color: backgroundColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WordDetailDialog extends StatelessWidget {
  _WordDetailDialog(
      {Key? key,
        required this.wordData,
        this.color,
      })
      : super(key: key);

  final RareKazakhWord wordData;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final examples = wordData.examples ?? [];
    final poem = wordData.poemExample ?? '';
    final writing = wordData.writingExample ?? '';
    final etymology = wordData.etymologyRu ?? '';
    final meaning = wordData.meaningEn ?? '';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: color ,
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wordData.word ?? '',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Translation".tr(),
                      style: const TextStyle(color: Colors.white)),
                  Text(meaning,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 8),
                  Text("Etymology".tr(),
                      style: const TextStyle(color: Colors.white)),
                  Text(etymology,
                      style: const TextStyle(color: Colors.white)),
                  const SizedBox(height: 16),
                  if (examples.isNotEmpty) ...[
                    const Text("Examples",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)).tr(),
                    const SizedBox(height: 4),
                    ...examples.map((e) => Text("• $e",
                        style: const TextStyle(color: Colors.white))),
                    const SizedBox(height: 12),
                  ],
                  if (poem.isNotEmpty) ...[
                    const Text("Poem Example",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)).tr(),
                    Text("\"${poem}\"",
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white70)),
                    const SizedBox(height: 12),
                  ],
                  if (writing.isNotEmpty) ...[
                    const Text("Writing Example",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)).tr(),
                    Text(writing, style: const TextStyle(color: Colors.white)),
                  ],
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Close",
                          style: TextStyle(color: Colors.white)).tr(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DoubleTapGuideDialog extends StatelessWidget {
  const _DoubleTapGuideDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.touch_app, size: 60, color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              "Did you know?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Double tap on a word card to mark it as 'learned'.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Got it"),
            ),
          ],
        ),
      ),
    );
  }
}
