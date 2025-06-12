import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:proj_management_project/features/chat/views/chat_history_screen.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../config/variables.dart';
import '../../../../../services/local/app_data_box_manager.dart';
import '../../../../../services/local/audio_player_service.dart';
import '../../../../../services/local/ranking_service.dart';
import '../../../models/idiom.dart';

class IdiomLearningPage extends StatefulWidget {
  final List<Idiom> idioms;
  final String title;

  const IdiomLearningPage({
    super.key,
    required this.idioms,
    required this.title,
  });

  @override
  State<IdiomLearningPage> createState() => _IdiomLearningPageState();
}

class _IdiomLearningPageState extends State<IdiomLearningPage> {
  late PageController _pageController;
  final manager = sl<AppDataBoxManager>();
  int _currentIndex = 0;
  final audioService = AudioPlayerService();

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  List<Color> get currentCardColors => isDarkMode ? darkCardColors : lightCardColors;

  Color get cardColor =>
      currentCardColors[_currentIndex % currentCardColors.length];


  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _toggleFavorite(Idiom idiom) {
    final box = manager.idiomBox;
    manager.toggleFavorite<Idiom>(
      idiom,
      box,
          (i) => i.isFavorite,
          (i, val) => i.isFavorite = val,
    );
    setState(() {});
  }

  void _toggleLearned(Idiom idiom) {
    final box = sl<AppDataBoxManager>().idiomBox;
    manager.toggleLearned<Idiom>(idiom, box);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final idiom = widget.idioms[_currentIndex];
    final meaning = context.localizedValue(
      kz: idiom.meaningKz,
      ru: idiom.meaningRu,
      en: idiom.meaningEn,
    ) ?? '';

    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        centerTitle: true,
        color: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.assistant),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => HistoryPage())),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            flex: 4,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemCount: widget.idioms.length,
              itemBuilder: (context, index) {
                final currentIdiom = widget.idioms[index];
                final synonyms = currentIdiom.synonyms ?? [];
            
                return AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 1.0;
                    if (_pageController.position.haveDimensions) {
                      value = (_pageController.page! - index).abs();
                      value = (1 - (value * 0.3)).clamp(0.8, 1.0);
                    }
            
                    return Center(
                      child: Transform.scale(
                        scale: Curves.easeInOutBack.transform(value),
                        child: Opacity(
                          opacity: value,
                          child: child,
                        ),
                      ),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.info_outline),
                                  onPressed: () => _showMoreInfo(currentIdiom, context),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentIdiom.idiom ?? '',
                                style: Theme.of(context).textTheme.headlineMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                meaning,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 16),
                              if (synonyms.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: synonyms
                                      .map((syn) => Chip(
                                    label: Text(syn),
                                    backgroundColor: Colors.white.withOpacity(0.2),
                                    shape: const StadiumBorder(
                                      side: BorderSide(color: Colors.black45),
                                    ),
                                  ))
                                      .toList(),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(widget.idioms.length, (index) {
                      return GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentIndex == index ? 20 : 12,
                          height: _currentIndex == index ? 20 : 12,
                          decoration: BoxDecoration(
                            color: _currentIndex == index
                                ? cardColor.withValues(alpha: 0.9)
                                : Colors.grey.shade400,
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(Icons.volume_up, () async {
                      await audioService.playAsset(widget.idioms[_currentIndex].audioUrl ?? "");
                    },
                    ),
                    _buildActionButton(widget.idioms[_currentIndex].isLearned ? Icons.check_circle : Icons.check_circle_outline,
                            () => _toggleLearned(widget.idioms[_currentIndex])),
                    _buildActionButton(
                      widget.idioms[_currentIndex].isFavorite ? Icons.star : Icons.star_border,
                          () => _toggleFavorite(widget.idioms[_currentIndex]),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onPressed) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black12),
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  void _showMoreInfo(Idiom idiom, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final literal = context.localizedValue(
          kz: idiom.literalMeaningKz,
          ru: idiom.literalMeaningRu,
          en: idiom.literalMeaningEn,
        ) ?? '';
        final usage = context.localizedValue(
          kz: idiom.usageKz,
          ru: idiom.usageRu,
          en: idiom.usageEn,
        ) ?? '';
        final whenToUse = context.localizedValue(
          kz: idiom.whenToUseKz,
          ru: idiom.whenToUseRu,
          en: idiom.whenToUseEn,
        ) ?? '';

        final Color bgColor = Theme.of(context).primaryColorDark;

        return Dialog(
          elevation: 10,
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
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
                          child: Lottie.asset('assets/lottie/learning3.json'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 8,
                        children: [
                          if (idiom.example?.isNotEmpty == true)
                            Text("ExampleArg".tr(args: [idiom.example ?? ""]), textAlign: TextAlign.center,),
                          if (literal?.isNotEmpty == true)
                            Text("Literal Meaning Arg".tr(args: [literal ?? ""]), textAlign: TextAlign.center,),
                          if (usage?.isNotEmpty == true)
                            Text("Usage".tr(args: [usage ?? "N/A"]), textAlign: TextAlign.center,),
                          if (whenToUse.isNotEmpty == true)
                            Text("When to Use Arg".tr(args: [whenToUse ?? ""]), textAlign: TextAlign.center,),
                        ],
                      ),
                    )
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
