import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proj_management_project/features/general-info/models/literature_recomendation.dart';
import 'package:proj_management_project/features/general-info/widgets/default_app_bar.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import 'book_details_page.dart';

class LiteratureRecommendationsWidget extends StatefulWidget {
  final Box<LiteratureRecomendation> recommendationBox;

  const LiteratureRecommendationsWidget({super.key, required this.recommendationBox});

  @override
  State<LiteratureRecommendationsWidget> createState() => _LiteratureRecommendationsWidgetState();
}

class _LiteratureRecommendationsWidgetState extends State<LiteratureRecommendationsWidget> {
  String selectedGenre = 'All'.tr();
  List<Map<String, dynamic>> allBooks = [];
  final List<String> genres = [
    'All'.tr(),
    'Kazakh Learning'.tr(),
    'Romance'.tr(),
    'Drama'.tr(),
    'Historical'.tr(),
    'Folklore'.tr(),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final locale = context.locale;
    allBooks = getRecommendations(context, widget.recommendationBox, locale);
  }

  List<Map<String, dynamic>> get filteredBooks {
    if (selectedGenre == 'All'.tr()) return allBooks;
    return allBooks.where((book) => book['genre'] == selectedGenre).toList();
  }

  String getGreetingName() {
    final user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Reader'.tr();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const DefaultAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hey Reader'.tr(args: [getGreetingName()]),
                  style: Theme.of(context).textTheme.titleLarge
                ),
                const SizedBox(height: 8),
                Text(
                  'Let your curiosity lead the way.'.tr(),
                  style: Theme.of(context).textTheme.titleLarge
                ),
              ],
            ),
          ),

          // Genre Tabs
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: genres.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final genre = genres[index];
                final isSelected = genre == selectedGenre;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedGenre = genre;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Theme.of(context).primaryColor),
                      boxShadow: isSelected
                          ? [const BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 2))]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        genre,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Book Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ListView.separated(
                itemCount: (filteredBooks.length / 3).ceil(),
                separatorBuilder: (context, index) => const Column(
                  children: [
                    Divider(thickness: 5.0, color: Color(0xFF964B00)),
                    SizedBox(height: 10),
                  ],
                ),
                itemBuilder: (context, rowIndex) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        3,
                            (columnIndex) {
                          final itemIndex = rowIndex * 3 + columnIndex;
                          if (itemIndex < filteredBooks.length) {
                            final bookData = filteredBooks[itemIndex];
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BookDetailsPage(bookData: bookData),
                                      ),
                                    );
                                  },
                                  child: AspectRatio(
                                    aspectRatio: 0.65,
                                    child: Card(
                                      elevation: 15,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: bookData['imageUrl'] != null && bookData['imageUrl'].isNotEmpty
                                            ? Image.network(
                                          bookData['imageUrl'],
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Center(child: Icon(Icons.error)),
                                        )
                                            : const Center(child: Icon(Icons.book)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const Expanded(child: SizedBox.shrink());
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> getRecommendations(BuildContext context, Box<LiteratureRecomendation> box, Locale locale) {
  final books = box.getAll();

  return books.map((book) {
    return {
      'title': context.localizedValue(
        kz: book.titleKz,
        ru: book.titleRu,
        en: book.titleEn,
      ) ?? '',
      'author': context.localizedValue(
        kz: book.authorKz,
        ru: book.authorRu,
        en: book.authorEn,
      ) ?? '',
      'description': context.localizedValue(
        kz: book.descriptionKz,
        ru: book.descriptionRu,
        en: book.descriptionEn,
      ) ?? '',
      'genre': context.localizedValue(
        kz: book.genreKz,
        ru: book.genreRu,
        en: book.genreEn,
      ) ?? '',
      'imageUrl': book.imageUrl,
      'rating': book.rating,
      'pages': book.pages,
      'releaseDate': book.releaseDate,
      'link': book.link,
    };
  }).toList();
}