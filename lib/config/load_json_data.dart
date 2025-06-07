import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proj_management_project/features/general-info/models/idiom.dart';
import 'package:proj_management_project/features/general-info/models/literature_extract.dart';
import 'package:proj_management_project/features/general-info/models/literature_recomendation.dart';
import 'package:proj_management_project/features/general-info/models/phrase.dart';
import 'package:proj_management_project/features/general-info/models/proverb.dart';
import 'package:proj_management_project/features/general-info/models/rare_kazakh_word.dart';
import 'package:proj_management_project/features/general-info/models/regional_dialect.dart';
import 'package:proj_management_project/features/general-info/models/section.dart';
import 'package:proj_management_project/services/local/app_data_box_manager.dart';

import '../features/general-info/models/fill_in_the_blank.dart';
import 'di/injection_container.dart';



final sectionBox = sl<AppDataBoxManager>().sectionBox;
final idiomTypeBox = sl<AppDataBoxManager>().idiomTypeBox;
final phraseThemeBox = sl<AppDataBoxManager>().phraseThemeBox;
final extractBox = sl<AppDataBoxManager>().extractBox;
final recommendationBox = sl<AppDataBoxManager>().recommendationBox;
final rareTypeBox = sl<AppDataBoxManager>().rareTypeBox;
final rareWordsBox = sl<AppDataBoxManager>().rareWordBox;
final phrasesBox = sl<AppDataBoxManager>().phraseBox;
final idiomsBox = sl<AppDataBoxManager>().idiomBox;
final dialectTypeBox = sl<AppDataBoxManager>().dialectTypeBox;
final proverbBox = sl<AppDataBoxManager>().proverbBox;

final fillInTheBlankBox = sl<AppDataBoxManager>().fillInTheBlankBox;

Future<void> loadDataFromJson(Store store) async {
  final sectionData = json.decode(await rootBundle.loadString('assets/data/sections.json'));
  final phrasesData = json.decode(await rootBundle.loadString('assets/data/phrases.json'));
  final wordsData = json.decode(await rootBundle.loadString('assets/data/words.json'));
  final idiomsData = json.decode(await rootBundle.loadString('assets/data/idioms.json'));
  final literatureRecommendationsData = json.decode(await rootBundle.loadString('assets/data/recommendations.json'));
  final literaryExtractsData = json.decode(await rootBundle.loadString('assets/data/extracts.json'));
  final proverbsData = json.decode(await rootBundle.loadString('assets/data/proverbs.json'));
  final dialectsData = json.decode(await rootBundle.loadString('assets/data/dialects.json'));
  final fillInTheBlankData = json.decode(await rootBundle.loadString('assets/data/fill_in_blank.json'));

  final items = (fillInTheBlankData['data'] as List<dynamic>).map((json) => FillInTheBlank(
    textBeforeKk: json['textBefore']['kk'] ?? '',
    textBeforeRu: json['textBefore']['ru'] ?? '',
    textBeforeEn: json['textBefore']['en'] ?? '',
    answerKk: json['answer']['kk'] ?? '',
    answerRu: json['answer']['ru'] ?? '',
    answerEn: json['answer']['en'] ?? '',
    textAfterKk: json['textAfter']['kk'] ?? '',
    textAfterRu: json['textAfter']['ru'] ?? '',
    textAfterEn: json['textAfter']['en'] ?? '',
    level: json['level'] ?? 'Intermediate',
  )).toList();
  fillInTheBlankBox.putMany(items);

  // Sections
  for (final s in sectionData['sections']) {
    final section = Section()
      ..titleKz = s['titleKz']
      ..titleRu = s['titleRu']
      ..titleEn = s['titleEn']
      ..descriptionKz = s['descriptionKz']
      ..descriptionRu = s['descriptionRu']
      ..descriptionEn = s['descriptionEn']
      ..contentTypeString = s['contentTypeString']
      ..contentTypeIndex = s['contentTypeIndex'];
    sectionBox.put(section);
  }

  // IdiomTypes
  for (final typeData in idiomsData['data']) {
    final idiomType = IdiomType()
      ..typeKz = typeData['typeKz']
      ..typeRu = typeData['typeRu']
      ..typeEn = typeData['typeEn']
      ..imageUrl = typeData['imageUrl'];

    for (final idiomData in typeData['idioms']) {
      final idiom = Idiom()
        ..idiom = idiomData['idiom']
        ..audioUrl = idiomData['audioUrl']
        ..meaningKz = idiomData['meaningKz']
        ..meaningRu = idiomData['meaningRu']
        ..meaningEn = idiomData['meaningEn']
        ..usageKz = idiomData['usageKz']
        ..usageRu = idiomData['usageRu']
        ..usageEn = idiomData['usageEn']
        ..example = idiomData['example']
        ..whenToUseKz = idiomData['whenToUseKz']
        ..whenToUseRu = idiomData['whenToUseRu']
        ..whenToUseEn = idiomData['whenToUseEn']
        ..literalMeaningKz = idiomData['literalMeaningKz']
        ..literalMeaningRu = idiomData['literalMeaningRu']
        ..literalMeaningEn = idiomData['literalMeaningEn']
        ..synonyms = List<String>.from(idiomData['synonyms'] ?? [])
        ..level = idiomData['level'];

      idiomType.idioms.add(idiom);
      idiomsBox.put(idiom);
    }

    idiomTypeBox.put(idiomType);
  }

  // Phrases
  for (final themeData in phrasesData['data']) {
    final phraseTheme = PhraseTheme()
      ..themeKz = themeData['themeKz']
      ..themeRu = themeData['themeRu']
      ..themeEn = themeData['themeEn']
      ..descriptionKz = themeData['descriptionKz']
      ..descriptionRu = themeData['descriptionRu']
      ..descriptionEn = themeData['descriptionEn'];

    for (final typeData in themeData['types']) {
      final phraseType = PhraseType()
        ..typeKz = typeData['typeKz']
        ..typeRu = typeData['typeRu']
        ..typeEn = typeData['typeEn'];

      for (final phraseData in typeData['phrases']) {
        final phrase = Phrase()
          ..phrase = phraseData['phrase']
          ..audioUrl = phraseData['audioUrl']
          ..meaningKz = phraseData['meaningKz']
          ..meaningRu = phraseData['meaningRu']
          ..meaningEn = phraseData['meaningEn']
          ..usageKz = phraseData['usageKz']
          ..usageRu = phraseData['usageRu']
          ..usageEn = phraseData['usageEn']
          ..example = phraseData['example']
          ..whenToUseKz = phraseData['whenToUseKz']
          ..whenToUseRu = phraseData['whenToUseRu']
          ..whenToUseEn = phraseData['whenToUseEn']
          ..noteKz = phraseData['noteKz'] ?? ''
          ..noteRu = phraseData['noteRu'] ?? ''
          ..noteEn = phraseData['noteEn'] ?? ''
          ..alternatives = List<String>.from(phraseData['alternatives'] ?? [])
          ..level = phraseData['level'];

        phraseType.phrases.add(phrase);
        phrasesBox.put(phrase);
      }
      phraseTheme.phraseTypes.add(phraseType);
    }

    phraseThemeBox.put(phraseTheme);
  }

  // Proverbs
  for (final p in proverbsData['data']) {
    proverbBox.put(Proverb()
      ..proverb = p['proverb']
      ..audioUrl = p['audioUrl']
      ..meaningKz = p['meaningKz']
      ..meaningRu = p['meaningRu']
      ..meaningEn = p['meaningEn']
      ..usageKz = p['usageKz']
      ..usageRu = p['usageRu']
      ..usageEn = p['usageEn']
      ..example = p['example']
      ..authorKz = p['authorKz']
      ..authorRu = p['authorRu']
      ..authorEn = p['authorEn']
      ..isFavorite = p['isFavorite'] ?? false
      ..shareable = p['shareable'] ?? true
      ..imagePath = p['imagePath']
      ..whenToUseKz = p['whenToUseKz']
      ..whenToUseRu = p['whenToUseRu']
      ..whenToUseEn = p['whenToUseEn']
      ..literalMeaningKz = p['literalMeaningKz']
      ..literalMeaningRu = p['literalMeaningRu']
      ..literalMeaningEn = p['literalMeaningEn']
      ..relatedProverbs = List<String>.from(p['relatedProverbs'] ?? [])
      ..tagsKz = List<String>.from(p['tagsKz'] ?? [])
      ..tagsRu = List<String>.from(p['tagsRu'] ?? [])
      ..tagsEn = List<String>.from(p['tagsEn'] ?? [])
      ..level = p['level']);
  }

  // Regional Dialects
  for (final dialectData in dialectsData['data']) {
    final dialectType = RegionalDialectType()
      ..typeKz = dialectData['typeKz']
      ..typeRu = dialectData['typeRu']
      ..typeEn = dialectData['typeEn'];

    for (final d in dialectData['dialects']) {
      final dialect = RegionalDialect()
        ..dialect = d['dialect']
        ..standart = d['standart']
        ..meaningKz = d['meaningKz']
        ..meaningRu = d['meaningRu']
        ..meaningEn = d['meaningEn']
        ..usageKz = d['usageKz']
        ..usageRu = d['usageRu']
        ..usageEn = d['usageEn']
        ..level = d['level'];

      dialectType.dialects.add(dialect);
    }

    dialectTypeBox.put(dialectType);
  }

  // Rare Kazakh Words
  for (final wordData in wordsData['data']) {
    final wordType = RareKazakhWordType()
      ..sectionKz = wordData['sectionKz']
      ..sectionRu = wordData['sectionRu']
      ..imageUrl = wordData['imageUrl']
      ..sectionEn = wordData['sectionEn'];

    for (final w in wordData['words']) {
      final word = RareKazakhWord()
        ..word = w['word']
        ..audioUrl = w['audioUrl']
        ..meaningKz = w['meaningKz']
        ..meaningRu = w['meaningRu']
        ..meaningEn = w['meaningEn']
        ..etymologyKz = w['etymologyKz']
        ..etymologyRu = w['etymologyRu']
        ..etymologyEn = w['etymologyEn']
        ..examples = List<String>.from(w['examples'] ?? [])
        ..poemExample = w['poemExample']
        ..level = w['level']
        ..writingExample = w['writingExample'];

      wordType.words.add(word);
      rareWordsBox.put(word);
    }
    rareTypeBox.put(wordType);
  }

  // Literature Recommendations
  for (final l in literatureRecommendationsData['data']) {
    recommendationBox.put(LiteratureRecomendation()
      ..idiom = l['idiom']
      ..titleKz = l['titleKz']
      ..titleRu = l['titleRu']
      ..titleEn = l['titleEn']
      ..authorKz = l['authorKz']
      ..authorRu = l['authorRu']
      ..authorEn = l['authorEn']
      ..imageUrl = l['imageUrl']
      ..descriptionKz = l['descriptionKz']
      ..descriptionRu = l['descriptionRu']
      ..descriptionEn = l['descriptionEn']
      ..genreKz = l['genreKz']
      ..genreRu = l['genreRu']
      ..genreEn = l['genreEn']
      ..rating = (l['rating'] ?? 0).toDouble()
      ..pages = l['pages']
      ..releaseDate = l['releaseDate']
      ..link = l['link']
      ..level = l['level']);
  }

  // Literature Extracts
  for (final extractData in literaryExtractsData['data']) {
    final extract = LiteratureExtract()
      ..audioUrl = extractData['audioUrl']
      ..titleKz = extractData['titleKz']
      ..titleRu = extractData['titleRu']
      ..titleEn = extractData['titleEn']
      ..authorKz = extractData['authorKz']
      ..authorRu = extractData['authorRu']
      ..authorEn = extractData['authorEn']
      ..imageUrl = extractData['imageUrl']
      ..level = extractData['level'];

    for (final lineData in extractData['lines']) {
      final line = Line()
        ..kz = List<String>.from(lineData['kz'] ?? [])
        ..ru = List<String>.from(lineData['ru'] ?? [])
        ..en = List<String>.from(lineData['en'] ?? [])
        ..translationIndexRu = (lineData['translationIndexRu'] as List?)
            ?.map((row) => List<int>.from(row))
            .toList()
        ..translationIndexEn = (lineData['translationIndexEn'] as List?)
            ?.map((row) => List<int>.from(row))
            .toList()
        ..literatureExtract.target = extract;

      extract.lines.add(line);
    }
    extractBox.put(extract);
  }


}


Future<void> seedAppDataIfNeeded(Store store) async {
    sectionBox.removeAll();
    idiomTypeBox.removeAll();
    phraseThemeBox.removeAll();
    extractBox.removeAll();
    recommendationBox.removeAll();
    rareTypeBox.removeAll();
    dialectTypeBox.removeAll();
    proverbBox.removeAll();
    await loadDataFromJson(store);
}
