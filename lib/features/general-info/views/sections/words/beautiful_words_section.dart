import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/features/home/views/home_page.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../services/local/app_data_box_manager.dart';
import '../../../models/rare_kazakh_word.dart';
import '../../../widgets/daily_info_card.dart';
import 'learn_word_page.dart';

class BeautifulWordSectionsPage extends StatefulWidget {
  final int contentTypeIndex;

  const BeautifulWordSectionsPage({super.key, required this.contentTypeIndex});

  @override
  State<BeautifulWordSectionsPage> createState() =>
      _BeautifulWordSectionsPageState();
}

class _BeautifulWordSectionsPageState extends State<BeautifulWordSectionsPage> {
  late List<dynamic> rareWordTypes;
  final boxManager = sl<AppDataBoxManager>();

  @override
  void initState() {
    super.initState();
    _loadRareWords();
  }

  void _loadRareWords() {
    setState(() {
      rareWordTypes = boxManager.getAllRareWordTypes();
    });
  }

  void _refreshProgress() {
    // This method will be called when a word's learned status changes
    setState(() {
      rareWordTypes = boxManager.getAllRareWordTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;

    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: CustomAppBar(
          title: '',
          color: Colors.transparent,
          leading: AppIconButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => const HomePage())),
            child: const Icon(Icons.arrow_back_ios_new_outlined),
          )),
      body: Column(
        children: [
          DailyItemCard<RareKazakhWord>(
            title: 'Daily Word'.tr(),
            item: boxManager.getDailyRareWord(),
            getContent: (w) => w.word ?? '',
            getMeaning: (w) => w.meaningEn,
            icon: Icons.lightbulb,
            getDetails: (p) => {
              "Examples".tr(): p.examples,
              "Writing Example".tr(): p.writingExample,
              "Meaning".tr(): p.meaningRu,
              "Etymology".tr(): p.etymologyRu,
              "Poem Example".tr(): p.poemExample,
            },
            bgColor: Theme.of(context).primaryColorDark,
            iconColor: Theme.of(context).textTheme.titleLarge!.color,
            textColor: Theme.of(context).textTheme.titleLarge!.color,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rareWordTypes.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final RareKazakhWordType type = rareWordTypes[index];
                final sectionWords = type.words
                    .where((e) => e.level == boxManager.getUserLevel().name)
                    .toList();

                return _SectionCard(
                  title: context.localizedValue(
                        kz: type.sectionKz,
                        ru: type.sectionRu,
                        en: type.sectionEn,
                      ) ??
                      '',
                  translation: _getTranslation(type.section ?? '', locale),
                  imageUrl: type.imageUrl ?? '',
                  words: sectionWords,
                  typeId: type.id,
                  contentTypeId: widget.contentTypeIndex,
                  onLearnedStatusChanged:
                      _refreshProgress, // Pass the refresh callback
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getTranslation(String original, String locale) {
    switch (locale) {
      case 'ru':
        return 'Красивые слова'; // You can enhance this with actual mapping
      case 'en':
        return 'Beautiful Words';
      default:
        return original; // Kazakh
    }
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String translation;
  final String imageUrl;
  final List<RareKazakhWord> words;
  final int typeId;
  final int contentTypeId;
  final VoidCallback onLearnedStatusChanged;

  const _SectionCard({
    required this.title,
    required this.translation,
    required this.imageUrl,
    required this.words,
    required this.typeId,
    required this.contentTypeId,
    required this.onLearnedStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalWords = words.length;
    final learnedWords = words.where((word) => word.isLearned).length;
    final progress = totalWords > 0 ? learnedWords / totalWords : 0.0;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => LearnWordsPage(
                  title: title,
                  words: words,
                  contentTypeId: contentTypeId,
                  typeId: typeId,
                  onWordLearned: onLearnedStatusChanged,
                )),
      ),
      child: Card(
        color: Theme.of(context).primaryColorDark,
        elevation: 20,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ))
                : const SizedBox.shrink(),
            Expanded(
              child: SizedBox(
                height: 120,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                                const SizedBox(height: 4),
                                Text(translation,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const SizedBox(height: 6),
                                Text("${words.length} сөз",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Icon(CupertinoIcons.right_chevron,
                                    size: 20)),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade400,
                      color: Colors.yellow.shade700,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
