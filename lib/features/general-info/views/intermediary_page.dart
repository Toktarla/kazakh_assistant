import 'package:flutter/material.dart';
import 'package:proj_management_project/config/load_json_data.dart';
import 'package:proj_management_project/features/general-info/views/sections/fill_in_blank_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/listening_comprehension_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/matching_game_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/multiple_choice_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/word_association_page.dart';
import 'package:proj_management_project/features/general-info/views/sections/words/beautiful_words_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/idiom/idioms_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/extracts/literary_extracts_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/book-recomendations/literature_recommendations_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/phrase/phrases_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/proverb/proverbs_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/interactive_map.dart';
import 'package:proj_management_project/features/general-info/views/true_or_false_page.dart';

import '../models/content_type.dart';

class IntermediaryPage extends StatelessWidget {
  final ContentType contentType;
  final int contentTypeIndex;

  const IntermediaryPage(
      {super.key, required this.contentType, required this.contentTypeIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
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
      case ContentType.exerciseFillInTheBlank:
        return const FillInTheBlankPage(

        );
      case ContentType.exerciseMultipleChoice:
        return const MultipleChoicePage();
      case ContentType.exerciseMatchingGame:
        return const MatchingGamePage();
      case ContentType.exerciseListeningComprehension:
        return const ListeningComprehensionPage();
      case ContentType.exerciseTrueFalse:
        return const TrueFalsePage();
      case ContentType.exerciseWordAssociation:
        return const WordAssociationPage();
    }
  }
}
