import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/features/general-info/models/proverb.dart';
import 'package:proj_management_project/features/general-info/models/idiom.dart';
import 'package:proj_management_project/features/general-info/models/rare_kazakh_word.dart';
import 'package:proj_management_project/features/general-info/models/phrase.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../config/di/injection_container.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  late final AppDataBoxManager appData;
  late final TabController _tabController;
  late final List<Proverb> favoriteProverbs;
  late final List<Idiom> favoriteIdioms;
  late final List<RareKazakhWord> favoriteRareWords;
  late final List<Phrase> favoritePhrases;

  final List<String> tabIcons = [
    'assets/icons/proverb_icon.png',
    'assets/icons/idiom_icon.png',
    'assets/icons/rare_word_icon.png',
    'assets/icons/phrase_icon.png',
  ];

  // Animation controllers
  late final AnimationController _fadeController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    appData = sl<AppDataBoxManager>();
    _tabController = TabController(length: 4, vsync: this);
    _fadeController = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);

    // Load data
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    // Simulate loading (you might have real async loading)
    await Future.delayed(const Duration(milliseconds: 300));

    favoriteProverbs = appData.getAllProverbs().where((p) => p.isFavorite).toList();
    favoriteIdioms = appData.getAllIdioms().where((i) => i.isFavorite).toList();
    favoriteRareWords = appData.getAllRareWordTypes()
        .expand((type) => type.words)
        .where((w) => w.isFavorite)
        .toList();
    favoritePhrases = appData.getAllPhraseThemes()
        .expand((theme) => theme.phraseTypes)
        .expand((type) => type.phrases)
        .where((p) => p.isFavorite)
        .toList();

    setState(() {
      isLoading = false;
    });
    _fadeController.forward();
  }

  void _removeFavorite<T>(T item) {
    setState(() {
      if (item is Proverb) {
        appData.removeFromFavorites(item, appData.proverbBox);
        favoriteProverbs.remove(item);
      } else if (item is Idiom) {
        appData.removeFromFavorites(item, appData.idiomBox);
        favoriteIdioms.remove(item);
      } else if (item is Phrase) {
        appData.removeFromFavorites(item, appData.phraseBox);
        favoritePhrases.remove(item);
      } else if (item is RareKazakhWord) {
        appData.removeFromFavorites(item, appData.rareWordBox);
        favoriteRareWords.remove(item);
      }
    });

    // Show snackbar for feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Removed from favorites').tr(),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.deepPurple.shade700,
        duration: const Duration(seconds: 1),
        action: SnackBarAction(
          label: 'UNDO'.tr(),
          textColor: Colors.white,
          onPressed: () {
            // Implement undo functionality if needed
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 0,
              floating: false,
              pinned: true,
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                indicatorWeight: 3,
                labelColor: Theme.of(context).textTheme.titleLarge?.color,
                unselectedLabelColor: Theme.of(context).textTheme.titleLarge?.color,
                labelStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
                tabs: [
                  Tab(
                    text: 'Proverbs'.tr(),
                    icon: Icon(Icons.format_quote, size: 20, color: Theme.of(context).iconTheme.color,),
                  ),
                  Tab(
                    text: 'Idioms'.tr(),
                    icon: Icon(Icons.chat_bubble_outline, size: 20, color: Theme.of(context).iconTheme.color),
                  ),
                  Tab(
                    text: 'Words'.tr(),
                    icon: Icon(Icons.text_fields, size: 20, color: Theme.of(context).iconTheme.color),
                  ),
                  Tab(
                    text: 'Phrases'.tr(),
                    icon: Icon(Icons.record_voice_over, size: 20, color: Theme.of(context).iconTheme.color),
                  ),
                ],
              ),
            ),
          ];
        },
        body: isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: Colors.deepPurple.shade600,
            strokeWidth: 3,
          ),
        )
            : FadeTransition(
          opacity: _fadeController,
          child: TabBarView(
            controller: _tabController,
            children: [
              // Proverbs Tab
              _buildFavoritesList<Proverb>(
                items: favoriteProverbs,
                emptyMessage: 'No favorite proverbs yet'.tr(),
                itemBuilder: (item) => _buildFavoriteCard(
                  type: 'Proverb'.tr(),
                  title: item.proverb ?? 'Unknown proverb'.tr(),
                  subtitle: context.localizedValue(
                    kz: item.meaningKz,
                    ru: item.meaningRu,
                    en: item.meaningEn,
                  ) ?? '',
                  onRemove: () => _removeFavorite(item),
                  typeColor: Colors.amber.shade700,
                  iconData: Icons.format_quote,
                ),
              ),

              // Idioms Tab
              _buildFavoritesList<Idiom>(
                items: favoriteIdioms,
                emptyMessage: 'No favorite idioms yet'.tr(),
                itemBuilder: (item) => _buildFavoriteCard(
                  type: 'Idiom'.tr(),
                  title: item.idiom ?? 'Unknown idiom'.tr(),
                  subtitle: context.localizedValue(
                    kz: item.meaningKz,
                    ru: item.meaningRu,
                    en: item.meaningEn,
                  ) ?? '',
                  onRemove: () => _removeFavorite(item),
                  typeColor: Colors.green.shade700,
                  iconData: Icons.chat_bubble_outline,
                ),
              ),

              // Rare Words Tab
              _buildFavoritesList<RareKazakhWord>(
                items: favoriteRareWords,
                emptyMessage: 'No favorite rare words yet'.tr(),
                itemBuilder: (item) => _buildFavoriteCard(
                  type: 'Rare Word'.tr(),
                  title: item.word ?? 'Unknown word'.tr(),
                  subtitle: context.localizedValue(
                    kz: item.meaningKz,
                    ru: item.meaningRu,
                    en: item.meaningEn,
                  ) ?? '',
                  onRemove: () => _removeFavorite(item),
                  typeColor: Colors.pink.shade700,
                  iconData: Icons.text_fields,
                ),
              ),

              // Phrases Tab
              _buildFavoritesList<Phrase>(
                items: favoritePhrases,
                emptyMessage: 'No favorite phrases yet'.tr(),
                itemBuilder: (item) => _buildFavoriteCard(
                  type: 'Phrase'.tr(),
                  title: item.phrase ?? 'Unknown phrase'.tr(),
                  subtitle: context.localizedValue(
                    kz: item.meaningKz,
                    ru: item.meaningRu,
                    en: item.meaningEn,
                  ) ?? '',
                  onRemove: () => _removeFavorite(item),
                  typeColor: Colors.blue.shade700,
                  iconData: Icons.record_voice_over,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesList<T>({
    required List<T> items,
    required String emptyMessage,
    required Widget Function(T item) itemBuilder,
  }) {
    if (items.isEmpty) {
      return _buildEmptyState(emptyMessage);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return FadeInUp(
          duration: Duration(milliseconds: 300 + (index * 50)),
          from: 20,
          child: itemBuilder(items[index]),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.bookmark_border,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: () {
              // Navigate to the respective category page
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple.shade600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: Text(
              'Explore Content'.tr(),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteCard({
    required String type,
    required String title,
    required String subtitle,
    required VoidCallback onRemove,
    required Color typeColor,
    required IconData iconData,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(iconData, size: 16, color: typeColor),
                const SizedBox(width: 6),
                Text(
                  type,
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.titleMedium
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  final text = title;
                  SharePlus.instance.share(ShareParams(
                      text: text, subject: subtitle
                  ));
                },
                icon: const Icon(Icons.share_outlined, size: 18),
                label: Text(
                  'Share'.tr(),
                  style: GoogleFonts.montserrat(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.deepPurple.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.bookmark_remove_outlined, size: 18),
                label: Text(
                  'Remove'.tr(),
                  style: GoogleFonts.montserrat(fontSize: 13),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}