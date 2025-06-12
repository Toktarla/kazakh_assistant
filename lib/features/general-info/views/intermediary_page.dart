import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/config/load_json_data.dart';
import 'package:proj_management_project/features/general-info/views/sections/multiple_choice_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/word_association_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/words/beautiful_words_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/idiom/idioms_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/extracts/literary_extracts_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/book-recomendations/literature_recommendations_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/phrase/phrases_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/proverb/proverbs_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/interactive_map.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';
import 'package:proj_management_project/utils/helpers/quiz_helper.dart';

import '../../../config/di/injection_container.dart';
import '../models/content_type.dart';

class IntermediaryPage extends StatelessWidget {
  final ContentType contentType;
  final int contentTypeIndex;
  final String? title;

  const IntermediaryPage({
    super.key,
    required this.contentType,
    required this.contentTypeIndex,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final boxManager = sl<AppDataBoxManager>();
    switch (contentType) {
      case ContentType.beautifulWords:
        return BeautifulWordSectionsPage(
          contentTypeIndex: contentTypeIndex,
        );
      case ContentType.phrases:
        return const PhrasesWidget();
      case ContentType.idioms:
        return const IdiomsWidget();
      case ContentType.proverbs:
        return const ProverbsWidget();
      case ContentType.literaryExtracts:
        return const LiteraryExtractListPage();
      case ContentType.regionalDialects:
        return const MapPage();
      case ContentType.literatureRecommendations:
        return LiteratureRecommendationsWidget(
          recommendationBox: recommendationBox,
        );
      case ContentType.exerciseIdioms: {
        final idioms = boxManager.getAllIdioms();
        final items = QuizHelper.generateIdiomQuestions(context, idioms, context.locale.languageCode);
        return MultipleChoicePage(
            title: title ?? '',
            items: items
        );
      }

      case ContentType.exercisePhrases: {
        final phrases = boxManager.getAllPhrases();
        final items = QuizHelper.generatePhraseQuestions(context, phrases, context.locale.languageCode);
        return MultipleChoicePage(
            title: title ?? '',
            items: items
        );
      }

      case ContentType.exerciseWordVocabulary: {
        final words = boxManager.getAllRareWords();
        final items = QuizHelper.generateWordQuestions(context, words, context.locale.languageCode);
        return MultipleChoicePage(
            title: title ?? '',
            items: items
        );
      }
      case ContentType.exerciseWordAssociation:
        final words = boxManager.getAllRareWords();
        final pairs = QuizHelper.generateWordSynonymPairs(words);
        return WordAssociationPage(wordSynonymPairs: pairs);

    }
  }
}
