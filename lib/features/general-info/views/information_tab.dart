import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:line_icons/line_icons.dart';
import 'package:proj_management_project/features/general-info/views/question_page.dart';
import '../../../config/app_colors.dart';
import '../../../utils/enums/content_type.dart';

class InformationTab extends StatefulWidget {
  const InformationTab({super.key});

  @override
  State<InformationTab> createState() => _InformationTabState();
}

class _InformationTabState extends State<InformationTab> {

  List<dynamic> sections = [];
  final List<Color> lightCardColors = [
    Colors.lightBlue[100]!,
    Colors.lightGreen[100]!,
    Colors.pink[100]!,
    Colors.yellow[100]!,
    Colors.cyan[100]!,
    Colors.amber[100]!,
    Colors.teal[100]!,
  ];

  final List<Color> darkCardColors = [
    Colors.blueGrey[800]!,
    AppColors.darkBlueColor,
    Colors.purple[800]!,
    AppColors.unSelectedBottomBarColorLight,
    Colors.blueGrey[800]!,
    AppColors.blackBrightColor,
    Colors.brown[800]!,
  ];

  final List<IconData> cardIcons = [
    Icons.auto_stories,
    Icons.record_voice_over,
    LineIcons.chalkboardTeacher,
    Icons.menu_book,
    Icons.library_books,
    Icons.map,
    Icons.book,
  ];

  Future<void> _loadData() async {
    final String response = await rootBundle.rootBundle.loadString('assets/data/general_information.json');
    final data = json.decode(response);
    setState(() {
      sections = data['sections'];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final cardColors = isDarkMode ? darkCardColors : lightCardColors;

    return sections.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: sections.length,
      itemBuilder: (context, sectionIndex) {
        final section = sections[sectionIndex];
        final cardColor = cardColors[sectionIndex % cardColors.length];
        final cardIcon = cardIcons[sectionIndex % cardIcons.length];

        return Card(
          color: cardColor,
          elevation: 5,
          shadowColor: Colors.grey.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              ContentType? contentType;
              switch (section['title']) {
                case "Beautiful/Rare Kazakh Words":
                  contentType = ContentType.beautifulWords;
                  break;
                case "Phrases":
                  contentType = ContentType.phrases;
                  break;
                case "Idioms":
                  contentType = ContentType.idioms;
                  break;
                case "Proverbs":
                  contentType = ContentType.proverbs;
                  break;
                case "Literary Extracts":
                  contentType = ContentType.literaryExtracts;
                  break;
                case "Regional Dialects":
                  contentType = ContentType.regionalDialects;
                  break;
                case "Literature Recommendations":
                  contentType = ContentType.literatureRecommendations;
                  break;
              }

              if (contentType != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(
                      sectionTitle: section['title'],
                      data: section['data'],
                      contentType: contentType!,
                    ),
                  ),
                );
              } else {
                print("Unknown content type for section: ${section['title']}");
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section['title'],
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            section['description'],
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Icon(
                    cardIcon,
                    size: 50,
                    color: isDarkMode ? AppColors.pinkColor : Colors.deepPurpleAccent,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
