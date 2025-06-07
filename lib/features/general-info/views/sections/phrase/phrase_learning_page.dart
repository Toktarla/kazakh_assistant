import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/services/local/audio_player_service.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../services/local/app_data_box_manager.dart';
import '../../../models/phrase.dart';
import '../../../widgets/daily_info_card.dart';

class PhraseLearningPage extends StatefulWidget {
  final List<Phrase> phrases;

  const PhraseLearningPage({
    super.key,
    required this.phrases,
  });

  @override
  State<PhraseLearningPage> createState() => _PhraseLearningPageState();
}

class _PhraseLearningPageState extends State<PhraseLearningPage> {
  final dataBoxManager = sl<AppDataBoxManager>();
  final audioService = AudioPlayerService();

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const DefaultAppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        children: [
          DailyItemCard<Phrase>(
            title: 'Daily Phrase'.tr(),
            item: dataBoxManager.getDailyPhrase(),
            getContent: (i) => i.phrase ?? '',
            getMeaning: (i) => i.meaningEn,
            icon: Icons.lightbulb,
            getDetails: (p) => {
              "Meaning".tr(): p.meaningRu,
              "Example".tr(): p.example,
              "When to Use".tr(): p.whenToUseRu,
              "Usage".tr(): p.usageRu,
              "Alternatives".tr(): p.alternatives,
              "Note".tr(): p.noteRu,
            },
            bgColor: Theme.of(context).primaryColorDark,
            iconColor: Theme.of(context).textTheme.titleLarge!.color,
            textColor: Theme.of(context).textTheme.titleLarge!.color,
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1, // tweak this for height
              ),
              itemCount: widget.phrases.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final phrase = widget.phrases[index];
                return GestureDetector(
                  onTap: () => _showDetailsDialog(phrase),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColorDark,
                          Theme.of(context).cardColor,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            phrase.phrase ?? '',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          context.localizedValue(
                            kz: phrase.meaningKz,
                            ru: phrase.meaningRu,
                            en: phrase.meaningEn,
                          ) ?? '',
                          style: Theme.of(context).textTheme.bodySmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                phrase.isFavorite ? Icons.star : Icons.star_border,
                                color: Colors.amber,
                                size: 20,
                              ),
                              onPressed: () {
                                dataBoxManager.toggleFavorite<Phrase>(
                                  phrase,
                                  dataBoxManager.phraseBox,
                                      (p) => p.isFavorite,
                                      (p, value) => p.isFavorite = value,
                                );
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.volume_up, color: Colors.lightBlueAccent),
                              onPressed: () async {
                                await audioService.playAsset(phrase.audioUrl ?? "");
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                phrase.isLearned ? Icons.check_circle : Icons.check_circle_outline,
                                color: Colors.green,
                                size: 20,
                              ),
                              onPressed: () {
                                dataBoxManager.toggleLearned<Phrase>(
                                  phrase,
                                  dataBoxManager.phraseBox,
                                );
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  void _showDetailsDialog(Phrase phrase) {
    final whenToUse = context.localizedValue(
      kz: phrase.whenToUseKz,
      ru: phrase.whenToUseRu,
      en: phrase.whenToUseEn,
    );
    final usage = context.localizedValue(
      kz: phrase.usageKz,
      ru: phrase.usageRu,
      en: phrase.usageEn,
    );
    final note = context.localizedValue(
      kz: phrase.noteKz,
      ru: phrase.noteRu,
      en: phrase.noteEn,
    );
    final alnernatives = phrase.alternatives;

    final example = phrase.example;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Theme.of(context).cardColor,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: SizedBox(
                          child: Lottie.asset('assets/lottie/learning2.json'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 8,
                        children: [
                          if (example?.isNotEmpty == true)
                            Text("ExampleArg".tr(args: [phrase.example ?? ""]), textAlign: TextAlign.center,),
                          if (note?.isNotEmpty == true)
                            Text("Note Arg".tr(args: [note ?? ""]), textAlign: TextAlign.center,),
                          if (usage?.isNotEmpty == true)
                            Text("Usage".tr(args: [usage ?? "N/A"]), textAlign: TextAlign.center,),
                          if (whenToUse?.isNotEmpty == true)
                            Text("When to Use Arg".tr(args: [whenToUse ?? ""]), textAlign: TextAlign.center,),
                        ],
                      ),
                    ),
                    if ((phrase.alternatives ?? []).isNotEmpty)
                      Column(
                        children: [
                          const Text(
                            "Alternatives:",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ).tr(),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: (phrase.alternatives ?? []).map((alt) {
                              return Chip(
                                label: Text(alt),
                                backgroundColor: Theme.of(context).cardColor,
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              // Close icon in top right
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  color: Theme.of(context).colorScheme.onSurface,
                  onPressed: () => Navigator.pop(context),
                  tooltip: 'Close'.tr(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
