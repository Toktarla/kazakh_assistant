import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:proj_management_project/features/general-info/views/sections/beautiful_words_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/idioms_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/literary_extracts_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/literature_recommendations_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/phrases_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/proverbs_section.dart';
import 'package:proj_management_project/features/general-info/views/sections/region/regional_dialects_section.dart';

import '../models/content_type.dart';

class QuestionPage extends StatelessWidget {
  final String sectionTitle;
  final dynamic data;  // Make data dynamic
  final ContentType contentType; // Add ContentType

  QuestionPage({required this.sectionTitle, required this.data, required this.contentType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectionTitle),
        elevation: 0,
      ),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (contentType) {
      case ContentType.beautifulWords:
        return BeautifulWordsWidget(beautifulWords: data);
      case ContentType.phrases:
        return PhrasesWidget(phrases: data);
      case ContentType.idioms:
        return IdiomsWidget(idioms: data);
      case ContentType.proverbs:
        return ProverbsWidget(proverbs: data);
      case ContentType.literaryExtracts:
        return LiteraryExtractsWidget(literaryExtracts: data);
      case ContentType.regionalDialects:
        return RegionalDialectsWidget(regionalDialects: data);
      case ContentType.literatureRecommendations:
        return LiteratureRecommendationsWidget(literatureRecommendations: data);
      default:
        return Center(child: Text("Content not implemented yet").tr());
    }
  }
}
