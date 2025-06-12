import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/config/load_json_data.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import 'package:proj_management_project/utils/localized_value_resolver.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../config/app_colors.dart';
import '../../../../../config/di/injection_container.dart';
import '../../../../../services/local/app_data_box_manager.dart';
import '../../../../../services/local/audio_player_service.dart';
import '../../../models/phrase.dart';
import '../../../models/proverb.dart';
import '../../../widgets/daily_info_card.dart';

class ProverbsWidget extends StatefulWidget {
  const ProverbsWidget({Key? key}) : super(key: key);

  @override
  State<ProverbsWidget> createState() => _ProverbsWidgetState();
}

class _ProverbsWidgetState extends State<ProverbsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  late List<Proverb> proverbs;
  late List<String>? filters;
  final dataBoxManager = sl<AppDataBoxManager>();
  final audioService = AudioPlayerService();

  @override
  void dispose() {
    audioService.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    proverbs = dataBoxManager.getAllProverbs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      if (proverbs.isNotEmpty) {
        filters = LocalizedValueResolver.generateCategoryList(context);
      }

      _tabController = TabController(length: filters?.length ?? 0, vsync: this);
  }

  List<dynamic> _filterProverbs(String tag) {
    return proverbs.where((p) => (context.localizedValueList(
      kz: p.tagsKz,
      ru: p.tagsRu,
      en: p.tagsEn,
    ) as List<String?>).contains(tag)).toList();
  }

  void _prev(List proverbs) {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  void _next(List proverbs) {
    if (_currentIndex < proverbs.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("filters $filters");
    if (filters == null || filters!.isEmpty) {
      return Scaffold(
        appBar: const DefaultAppBar(),
        body: Center(
          child: const Text('No proverbs available.').tr(),
        ),
      );
    }

    final currentFilter = (_tabController.length > 0)
        ? filters![_tabController.index]
        : '';

    final filteredProverbs = _filterProverbs(currentFilter);
    if (filteredProverbs.isNotEmpty && _currentIndex < filteredProverbs.length) {
      print(filteredProverbs[_currentIndex]);
    }    return Scaffold(
      appBar: const DefaultAppBar(),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          children: [
            DailyItemCard<Proverb>(
              title: 'Daily Proverb'.tr(),
              item: dataBoxManager.getDailyProverb(),
              getContent: (p) => p.proverb ?? '',
              getMeaning: (p) => context.localizedValue(
                kz: p.meaningKz,
                ru: p.meaningRu,
                en: p.meaningEn,
              ) ?? '',
              icon: Icons.lightbulb,
              getDetails: (p) => {
                "Meaning".tr(): context.localizedValue(
                  kz: p.meaningKz,
                  ru: p.meaningRu,
                  en: p.meaningEn,
                ) ?? '',
                "Example".tr(): p.example,
                "When to Use".tr(): context.localizedValue(
                  kz: p.whenToUseKz,
                  ru: p.whenToUseRu,
                  en: p.whenToUseEn,
                ) ?? '',
                "Usage".tr(): context.localizedValue(
              kz: p.usageKz,
              ru: p.usageRu,
              en: p.usageEn,
              ) ?? '',
                "Literal Meaning".tr(): context.localizedValue(
              kz: p.literalMeaningKz,
              ru: p.literalMeaningRu,
              en: p.literalMeaningEn,
              ) ?? '',
              },
              bgColor: Theme.of(context).primaryColorDark,
              iconColor: Theme.of(context).textTheme.titleLarge!.color,
              textColor: Theme.of(context).textTheme.titleLarge!.color,
            ),
            const SizedBox(height: 12),
            _buildTabBar(),
            const SizedBox(height: 24),
            if (filteredProverbs.isNotEmpty)
              Center(
                child: SizedBox(
                  height: 500,
                  child: filteredProverbs.isNotEmpty
                      ? Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () => _showProverbDetails(filteredProverbs[_currentIndex]),
                          child: _buildProverbCard(filteredProverbs[_currentIndex]),
                        ),
                      ),
                      Positioned(
                        top: 125,
                        left: 5,
                        child: _buildArrowButton(Icons.arrow_back, () => _prev(filteredProverbs)),
                      ),
                      Positioned(
                        top: 125,
                        right: 5,
                        child: _buildArrowButton(Icons.arrow_forward, () => _next(filteredProverbs)),
                      ),
                    ],
                  )
                      : Center(
                    child: const Text('No proverbs available.').tr()
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return SizedBox(
      height: 60,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters!.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final genre = filters![index];
          final isSelected = index == _tabController.index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _tabController.index = index;
                _currentIndex = 0;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? Theme.of(context).primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Theme.of(context).primaryColor),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 2))
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  genre,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProverbCard(Proverb proverb) {
    final proverbText = proverb.proverb ?? '';
    print("proverbText ${proverbText}");
    final author = context.localizedValue(
      kz: proverb.authorKz,
      ru: proverb.authorRu,
      en: proverb.authorEn,
    ) ?? '';
    final isFavorite = proverb.isFavorite;

    return Column(
      children: [
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          clipBehavior: Clip.antiAlias,
          elevation: 6,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 300,
                decoration: const BoxDecoration(
                  color: AppColors.pinkColor
                ),
              ),
              Container(
                height: 300,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                color: Colors.black.withOpacity(0.4),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        proverbText,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "- $author",
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                final text = '"$proverbText"\n— $author';
                SharePlus.instance.share(ShareParams(text: text, subject: 'Beautiful proverb'.tr()));
              },
              child: Row(
                children: [
                  Icon(Icons.share,
                      color: Theme.of(context).textTheme.titleLarge!.color),
                  const SizedBox(width: 5),
                  Text('Share'.tr(),
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.titleLarge!.color)),
                ],
              ),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () {
                sl<AppDataBoxManager>().toggleFavorite<Proverb>(
                  proverb,
                  proverbBox,
                  (p) => p.isFavorite,
                  (p, value) => p.isFavorite = value,
                );
                setState(() {});
              },
              child: Row(
                children: [
                  Icon(
                    proverb.isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: Theme.of(context).textTheme.titleLarge!.color,
                  ),
                  const SizedBox(width: 5),
                  Text('Favorite'.tr(),
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.titleLarge!.color)),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: 24, left: MediaQuery.sizeOf(context).width / 3),
          child: GestureDetector(
            onTap: () async {
              await audioService.playAsset(proverb.audioUrl ?? "");
            },
            child: Row(
              children: [
                Icon(Icons.volume_up,
                    color: Theme.of(context).textTheme.titleLarge!.color),
                const SizedBox(width: 5),
                Text('Listen'.tr(),
                    style: TextStyle(color: Theme.of(context).textTheme.titleLarge!.color)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildArrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue[300],
        ),
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  void _showProverbDetails(Proverb proverb) {
    final locale = context.locale.languageCode;
    final proverbText = proverb.proverb;
    final example = proverb.example;
    final author = context.localizedValue(
      kz: proverb.authorKz,
      ru: proverb.authorRu,
      en: proverb.authorEn,
    ) ?? '';
    final meaning = context.localizedValue(
      kz: proverb.meaningKz,
      ru: proverb.meaningRu,
      en: proverb.meaningEn,
    ) ?? '';
    final whenToUse =context.localizedValue(
      kz: proverb.whenToUseKz,
      ru: proverb.whenToUseRu,
      en: proverb.whenToUseEn,
    ) ?? '';
    final literalMeaning = context.localizedValue(
      kz: proverb.literalMeaningKz,
      ru: proverb.literalMeaningRu,
      en: proverb.literalMeaningEn,
    ) ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            const Icon(Icons.auto_stories, color: Colors.deepPurple),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Proverb Details'.tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '"$proverbText"',
              style: const TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(author),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.redAccent),
                const SizedBox(width: 8),
                Text(literalMeaning),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    meaning,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    whenToUse,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.chat_bubble_outline, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "ExampleArg".tr(args: [example ?? ""]),
                    style: const TextStyle(
                        fontSize: 14, fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close').tr(),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}
