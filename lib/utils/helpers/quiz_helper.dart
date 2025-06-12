import 'package:flutter/cupertino.dart';
import 'package:proj_management_project/features/general-info/views/sections/multiple_choice_page.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';
import '../../features/general-info/models/idiom.dart';
import '../../features/general-info/models/phrase.dart';
import '../../features/general-info/models/rare_kazakh_word.dart';

class QuizHelper {
  static  List<T> getRandomItems<T>(List<T> list, int count) {
    list.shuffle();
    return list.take(count).toList();
  }

  static  List<String> getRandomMeaningsExcept(
    String correct,
    List<String>? pool,
    int count,
  ) {
    final filtered =
        pool?.where((m) => m != null && m != correct).cast<String>().toList() ?? [];
    filtered.shuffle();
    return filtered.take(count).toList();
  }

  static List<MultipleChoiceItem> generateIdiomQuestions(BuildContext context, List<Idiom> idioms, String locale) {
    final List<MultipleChoiceItem> items = [];

    String getMeaning(Idiom i) =>
        {
          'kk': i.meaningKz,
          'ru': i.meaningRu,
          'en': i.meaningEn,
        }[locale] ?? i.meaningEn ?? '';

    final meaningPool = idioms.map(getMeaning).where((e) => e.isNotEmpty).toList();
    final idiomPool = idioms.map((i) => i.idiom).whereType<String>().toList();
    final synonymPool = idioms.expand((i) => i.synonyms ?? []).whereType<String>().toList();

    final selectedIdioms = getRandomItems(idioms, 10);

    for (var idiom in selectedIdioms) {
      final idiomText = idiom.idiom;
      final meaning = getMeaning(idiom);
      final literal = context.localizedValue(
        en: idiom.literalMeaningEn,
        ru: idiom.literalMeaningRu,
        kz: idiom.literalMeaningKz,
      );
      final usage = context.localizedValue(
        en: idiom.usageEn,
        ru: idiom.usageRu,
        kz: idiom.usageKz,
      );
      final synonyms = idiom.synonyms;

      // Idiom → Meaning
      if (items.length < 4 && idiomText != null && meaning.isNotEmpty) {
        final options = getRandomMeaningsExcept(meaning, meaningPool, 3)..add(meaning)..shuffle();
        items.add(MultipleChoiceItem(
          question: idiomText,
          options: options,
          correctIndex: options.indexOf(meaning),
        ));
      }
      // Idiom → Synonym
      else if (items.length < 6 && idiomText != null && synonyms != null && synonyms.isNotEmpty) {
        final correct = synonyms.first;
        final options = getRandomMeaningsExcept(correct, synonymPool!, 3)..add(correct)..shuffle();
        items.add(MultipleChoiceItem(
          question: idiomText,
          options: options,
          correctIndex: options.indexOf(correct),
        ));
      }
      // Literal meaning → Idiom
      else if (items.length < 8 && literal != null && literal.isNotEmpty && idiomText != null) {
        final options = getRandomMeaningsExcept(idiomText, idiomPool, 3)..add(idiomText)..shuffle();
        items.add(MultipleChoiceItem(
          question: literal,
          options: options,
          correctIndex: options.indexOf(idiomText),
        ));
      }
      // When to use → Idiom
      else if (usage != null && usage.isNotEmpty && idiomText != null) {
        final options = getRandomMeaningsExcept(idiomText, idiomPool, 3)..add(idiomText)..shuffle();
        items.add(MultipleChoiceItem(
          question: usage,
          options: options,
          correctIndex: options.indexOf(idiomText),
        ));
      }

      if (items.length == 10) break;
    }

    return items;
  }

  static List<MultipleChoiceItem> generatePhraseQuestions(BuildContext context, List<Phrase> phrases, String locale) {
    final List<MultipleChoiceItem> items = [];

    String getMeaning(Phrase p) =>
        {
          'kk': p.meaningKz,
          'ru': p.meaningRu,
          'en': p.meaningEn,
        }[locale] ?? p.meaningEn ?? '';

    final meaningPool = phrases.map(getMeaning).where((e) => e.isNotEmpty).toList();
    final phrasePool = phrases.map((p) => p.phrase).whereType<String>().toList();
    final alternativesPool = phrases.expand((p) => p.alternatives ?? []).whereType<String>().toList();


    final selectedPhrases = getRandomItems(phrases, 10);

    for (var phrase in selectedPhrases) {
      final phraseText = phrase.phrase;
      final meaning = getMeaning(phrase);
      final usage = context.localizedValue(
        en: phrase.usageEn,
        ru: phrase.usageRu,
        kz: phrase.usageKz,
      );
      final alternatives = phrase.alternatives;

      // Phrase → Meaning
      if (items.length < 4 && phraseText != null && meaning.isNotEmpty) {
        final options = getRandomMeaningsExcept(meaning, meaningPool, 3)..add(meaning)..shuffle();
        items.add(MultipleChoiceItem(
          question: phraseText,
          options: options,
          correctIndex: options.indexOf(meaning),
        ));
      }
      // Meaning → Phrase
      else if (items.length < 6 && phraseText != null && meaning.isNotEmpty) {
        final options = getRandomMeaningsExcept(phraseText, phrasePool, 3)..add(phraseText)..shuffle();
        items.add(MultipleChoiceItem(
          question: meaning,
          options: options,
          correctIndex: options.indexOf(phraseText),
        ));
      }
      // Usage → Phrase
      else if (items.length < 8 && usage != null && usage.isNotEmpty && phraseText != null) {
        final options = getRandomMeaningsExcept(phraseText, phrasePool, 3)..add(phraseText)..shuffle();
        items.add(MultipleChoiceItem(
          question: usage,
          options: options,
          correctIndex: options.indexOf(phraseText),
        ));
      }
      // Alternatives → Phrase
      else if (alternatives != null && alternatives.isNotEmpty && phraseText != null) {
        final correct = alternatives.first;
        final options = getRandomMeaningsExcept(correct, alternativesPool, 3)..add(correct)..shuffle();
        items.add(MultipleChoiceItem(
          question: phraseText,
          options: options,
          correctIndex: options.indexOf(correct),
        ));
      }

      if (items.length == 10) break;
    }

    return items;
  }

  static List<MultipleChoiceItem> generateWordQuestions(BuildContext context, List<RareKazakhWord> words, String locale) {
    final List<MultipleChoiceItem> items = [];

    String getMeaning(RareKazakhWord w) =>
        {
          'kk': w.meaningKz,
          'ru': w.meaningRu,
          'en': w.meaningEn,
        }[locale] ?? w.meaningEn ?? '';

    final meaningsPool = words.map(getMeaning).where((e) => e.isNotEmpty).toList();
    final wordPool = words.map((w) => w.word).whereType<String>().toList();

    final selectedWords = getRandomItems(words, 10);

    for (var word in selectedWords) {
      final wordText = word.word;
      final meaning = getMeaning(word);
      final etymology = context.localizedValue(
        en: word.etymologyEn,
        ru: word.etymologyRu,
        kz: word.etymologyKz,
      );

      // 50%: Word → Meaning
      if (items.length < 5 && wordText != null && meaning.isNotEmpty) {
        final options = getRandomMeaningsExcept(meaning, meaningsPool, 3)..add(meaning)..shuffle();
        items.add(MultipleChoiceItem(
          question: wordText,
          options: options,
          correctIndex: options.indexOf(meaning),
        ));
      }
      // 30%: Meaning → Word
      else if (items.length < 8 && wordText != null && meaning.isNotEmpty) {
        final options = getRandomMeaningsExcept(wordText, wordPool, 3)..add(wordText)..shuffle();
        items.add(MultipleChoiceItem(
          question: meaning,
          options: options,
          correctIndex: options.indexOf(wordText),
        ));
      }
      // 20%: Etymology → Word
      else if (etymology != null && etymology.isNotEmpty && wordText != null) {
        final options = getRandomMeaningsExcept(wordText, wordPool, 3)..add(wordText)..shuffle();
        items.add(MultipleChoiceItem(
          question: etymology,
          options: options,
          correctIndex: options.indexOf(wordText),
        ));
      }

      if (items.length == 10) break;
    }

    return items;
  }

  static List<MapEntry<String, String>> generateWordSynonymPairs(List<RareKazakhWord> words) {
    final random = words..shuffle();
    final List<MapEntry<String, String>> pairs = [];

    for (final word in random) {
      if (word.word != null && word.synonyms != null && word.synonyms!.isNotEmpty) {
        final synonym = word.synonyms!.first;
        pairs.add(MapEntry(word.word!, synonym));
      }
      if (pairs.length == 5) break;
    }

    return pairs;
  }

}
