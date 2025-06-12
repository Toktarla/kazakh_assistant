import 'dart:math';

import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import 'package:proj_management_project/features/general-info/models/fill_in_the_blank.dart';
import 'package:proj_management_project/features/general-info/models/streak.dart';
import 'package:proj_management_project/features/general-info/models/user_level.dart';
import 'package:proj_management_project/objectbox.g.dart';
import 'package:proj_management_project/services/local/ranking_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/general-info/models/section.dart';
import '../../features/general-info/models/idiom.dart';
import '../../features/general-info/models/phrase.dart';
import '../../features/general-info/models/proverb.dart';
import '../../features/general-info/models/literature_extract.dart';
import '../../features/general-info/models/literature_recomendation.dart';
import '../../features/general-info/models/rare_kazakh_word.dart';
import '../../features/general-info/models/regional_dialect.dart';
import '../../features/general-info/models/section_type.dart';

class AppDataBoxManager {
  final Store store;
  final SharedPreferences prefs;
  static const String _favoriteCountKey = 'favoriteCount';
  ValueNotifier<int> favoriteCountNotifier = ValueNotifier<int>(0);


  late final Box<Section> sectionBox;
  late final Box<IdiomType> idiomTypeBox;
  late final Box<PhraseTheme> phraseThemeBox;
  late final Box<LiteratureExtract> extractBox;
  late final Box<LiteratureRecomendation> recommendationBox;
  late final Box<RareKazakhWordType> rareTypeBox;
  late final Box<RegionalDialectType> dialectTypeBox;
  late final Box<Proverb> proverbBox;
  late final Box<RareKazakhWord> rareWordBox;
  late final Box<Phrase> phraseBox;
  late final Box<Idiom> idiomBox;
  late final Box<StreakModel> streakBox;
  late final Box<FillInTheBlank> fillInTheBlankBox;

  AppDataBoxManager(this.store, this.prefs) {
    sectionBox = store.box<Section>();
    idiomTypeBox = store.box<IdiomType>();
    phraseThemeBox = store.box<PhraseTheme>();
    extractBox = store.box<LiteratureExtract>();
    recommendationBox = store.box<LiteratureRecomendation>();
    rareTypeBox = store.box<RareKazakhWordType>();
    dialectTypeBox = store.box<RegionalDialectType>();
    proverbBox = store.box<Proverb>();
    rareWordBox = store.box<RareKazakhWord>();
    phraseBox = store.box<Phrase>();
    idiomBox = store.box<Idiom>();
    streakBox = store.box<StreakModel>();
    fillInTheBlankBox = store.box<FillInTheBlank>();
  }

  T? _getDailyItemOncePerDay<T extends Object>({
    required Box<T> box,
    required bool Function(T) isLearnedGetter,
    required String Function(T) levelGetter,
    required String prefsKeyPrefix,
  }) {
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";

    final storedDate = prefs.getString('${prefsKeyPrefix}_date');
    final storedId = prefs.getInt('${prefsKeyPrefix}_id');

    if (storedDate == todayString && storedId != null) {
      final cachedItem = box.get(storedId);
      if (cachedItem != null) return cachedItem;
    }

    // No valid cache, select a new daily item
    final userLevel = getUserLevel().name;
    final filteredItems = box.getAll()
        .where((item) => !isLearnedGetter(item) && levelGetter(item) == userLevel)
        .toList();

    if (filteredItems.isEmpty) return null;

    final random = Random();
    final newItem = filteredItems[random.nextInt(filteredItems.length)];

    final id = (newItem as dynamic).id as int;
    prefs.setString('${prefsKeyPrefix}_date', todayString);
    prefs.setInt('${prefsKeyPrefix}_id', id);

    return newItem;
  }

  void loadFavoriteCount() {
    int count = prefs.getInt(_favoriteCountKey) ?? 0;
    favoriteCountNotifier.value = count;
  }

  // Method to update the favorite count in SharedPreferences
  void updateFavoriteCount(int newCount) {
    favoriteCountNotifier.value = newCount;
    prefs.setInt(_favoriteCountKey, newCount);
  }

  Future<void> setUserLevel(UserLevel selectedLevel) async {
    await prefs.setString('user_level', selectedLevel.name);
  }

  UserLevel getUserLevel() {
    final levelStr = prefs.getString('user_level') ?? 'Beginner';
    return UserLevelExtension.fromString(levelStr);
  }

  Map<String, List<Object>> getAllFavorites() {
    final idioms = idiomBox.getAll().where((i) => i.isFavorite).toList();
    final proverbs = proverbBox.getAll().where((p) => p.isFavorite).toList();
    final phrases = phraseBox.getAll().where((p) => p.isFavorite).toList();
    final rareWords = rareWordBox.getAll().where((r) => r.isFavorite).toList();

    // Return a map with categorized favorites
    return {
      'Idioms': idioms,
      'Proverbs': proverbs,
      'Phrases': phrases,
      'RareKazakhWords': rareWords,
    };
  }

  void toggleFavorite<T extends Object>(
      T item,
      Box<T> box,
      bool Function(T) isFavoriteGetter,
      void Function(T, bool) isFavoriteSetter,
      ) {
    final currentFavoriteStatus = isFavoriteGetter(item);
    isFavoriteSetter(item, !currentFavoriteStatus);

    if (!currentFavoriteStatus) {
      addToFavorites(item, box);
    } else {
      removeFromFavorites(item, box);
    }
  }

  void toggleLearned<T extends Object>(T item, Box<T> box) async {
    if (item is RareKazakhWord) {
      item.isLearned = !item.isLearned;
      if (item.isLearned) await RankingService.addProgress(10);
      box.put(item);
    } else if (item is Idiom) {
      item.isLearned = !item.isLearned;
      if (item.isLearned) await RankingService.addProgress(10);
      box.put(item);
    } else if (item is Phrase) {
      item.isLearned = !item.isLearned;
      if (item.isLearned) await RankingService.addProgress(10);
      box.put(item);
    } else if (item is Proverb) {
      item.isLearned = !item.isLearned;
      if (item.isLearned) await RankingService.addProgress(10);
      box.put(item);
    } else {
      throw Exception("Unsupported type for isLearned toggle: ${T.toString()}");
    }
  }

  void addToFavorites<T>(T item, Box<T> box) {
    if (item is Proverb) {
      item.isFavorite = true;
      box.put(item);
    } else if (item is Idiom) {
      item.isFavorite = true;
      box.put(item);
    } else if (item is Phrase) {
      item.isFavorite = true;
      box.put(item);
    } else if (item is RareKazakhWord) {
      item.isFavorite = true;
      box.put(item);
    }
    int newCount = favoriteCountNotifier.value + 1;
    updateFavoriteCount(newCount);
  }

  void removeFromFavorites<T>(T item, Box<T> box) {
    if (item is Proverb) {
      item.isFavorite = false;
      box.put(item);
    } else if (item is Idiom) {
      item.isFavorite = false;
      box.put(item);
    } else if (item is Phrase) {
      item.isFavorite = false;
      box.put(item);
    }
    else if (item is RareKazakhWord) {
      item.isFavorite = false;
      box.put(item);
    }
    int newCount = favoriteCountNotifier.value - 1;
    updateFavoriteCount(newCount);
  }

  List<T> paginate<T>(Box<T> box, int page, int pageSize) {
    final allItems = box.getAll();
    final start = page * pageSize;

    final end = (start + pageSize).clamp(0, allItems.length);
    return allItems.sublist(start, end);
  }

  List<T> paginateByLevel<T>(List<T> list, int page, int pageSize) {
    final userLevel = getUserLevel().levelName;
    final allItems = list.where((item) {
      return (item as dynamic).level == userLevel;
    }).toList();

    if (allItems.isEmpty) return [];

    // Calculate total pages
    final totalPages = (allItems.length / pageSize).ceil();

    // Ensure page is within bounds (wrap around if necessary)
    final safePage = page % totalPages;

    final start = safePage * pageSize;
    final end = min(start + pageSize, allItems.length);

    return allItems.sublist(start, end);
  }

  List<Idiom> getAllIdioms() {
    final level = getUserLevel().name;
    return idiomTypeBox.getAll().expand((idiomType) {
      return idiomType.idioms.where((idiom) => idiom.level == level).toList();
    }).toList();
  }

  List<IdiomType> getAllIdiomTypes() => idiomTypeBox.getAll();

  List<PhraseTheme> getAllPhraseThemes() {
    final level = getUserLevel().name;

    return phraseThemeBox.getAll().where((phraseTheme) {
      return phraseTheme.phraseTypes.any((phraseType) {
        return phraseType.phrases.any((phrase) => phrase.level == level);
      });
    }).toList();
  }

  List<Phrase> getAllPhrases() {
    final level = getUserLevel().name;
    return phraseThemeBox.getAll().expand((phraseTheme) {
      return phraseTheme.phraseTypes.expand((phraseType) {
        return phraseType.phrases.where((phrase) => phrase.level == level);
      });
    }).toList();
  }

  List<RareKazakhWord> getAllRareWords() {
    final level = getUserLevel().name;
    return rareTypeBox.getAll().expand((wordType) {
      return wordType.words.where((word) => word.level == level).toList();
    }).toList();
  }

  List<RareKazakhWordType> getAllRareWordTypes() {
    final level = getUserLevel().name;

    return rareTypeBox.getAll().where((rareKazakhWordType) {
      return rareKazakhWordType.words.any((word) => word.level == level);
    }).toList();
  }

  List<Proverb> getAllProverbs() {
    final level = getUserLevel().name;
    return proverbBox.getAll().where((proverb) => proverb.level == level).toList();
  }

  List<LiteratureRecomendation> getAllRecommendations() {
    final level = getUserLevel().name;
    return recommendationBox.getAll().where((e) => e.level == level).toList();
  }

  List<LiteratureExtract> getAllExtracts() {
    final level = getUserLevel().name;
    return extractBox.getAll().where((e) => e.level == level).toList();
  }

  List<RegionalDialectType> getAllDialectTypes() => dialectTypeBox.getAll();

  List<Section> getAllLearnSections() {
    return sectionBox.getAll().where((s) => s.contentTypeString == SectionType.learn.name).toList();
  }

  List<Section> getAllInformationSections() {
    return sectionBox.getAll().where((s) => s.contentTypeString == SectionType.information.name).toList();
  }

  List<Section> getAllExerciseSections() {
    return sectionBox.getAll().where((s) => s.contentTypeString == SectionType.exercise.name).toList();
  }

  Idiom? getDailyIdiom() {
    return _getDailyItemOncePerDay<Idiom>(
      box: idiomBox,
      isLearnedGetter: (item) => item.isLearned,
      levelGetter: (item) => item.level ?? "Intermediate",
      prefsKeyPrefix: 'daily_idiom',
    );
  }

  Phrase? getDailyPhrase() {
    return _getDailyItemOncePerDay<Phrase>(
      box: phraseBox,
      isLearnedGetter: (item) => item.isLearned,
      levelGetter: (item) => item.level ?? "Intermediate",
      prefsKeyPrefix: 'daily_phrase',
    );
  }

  Proverb? getDailyProverb() {
    return _getDailyItemOncePerDay<Proverb>(
      box: proverbBox,
      isLearnedGetter: (item) => item.isLearned,
      levelGetter: (item) => item.level ?? "Intermediate",
      prefsKeyPrefix: 'daily_proverb',
    );
  }

  RareKazakhWord? getDailyRareWord() {
    return _getDailyItemOncePerDay<RareKazakhWord>(
      box: rareWordBox,
      isLearnedGetter: (item) => item.isLearned,
      levelGetter: (item) => item.level ?? "Intermediate",
      prefsKeyPrefix: 'daily_rare_word',
    );
  }

  RegionalDialect? getDailyDialect() {
    final userLevel = getUserLevel().name;
    final dialects = dialectTypeBox.getAll()
        .expand((type) => type.dialects)
        .where((dialect) => dialect.level == userLevel)
        .toList();

    if (dialects.isEmpty) return null;

    final random = Random();
    return dialects[random.nextInt(dialects.length)];
  }

  Future<Map<String, dynamic>> getStreakData(String userId) async {
    final streak = streakBox.query(StreakModel_.userId.equals(userId)).build().findFirst();
    if (streak != null) {
      return {
        'streakCount': streak.streakCount,
        'isStreakLost': streak.isStreakLost,
      };
    }
    return {
      'streakCount': 1,
      'isStreakLost': false,
    };
  }

  Future<Set<DateTime>> getUserActivityDays(String userId) async {
    final streak = streakBox.query(StreakModel_.userId.equals(userId)).build().findFirst();
    if (streak != null && streak.activityDates.isNotEmpty) {
      return streak.activityDates.map((ts) => DateTime.fromMillisecondsSinceEpoch(ts)).toSet();
    }
    return {};
  }

  Future<void> updateStreak(String userId) async {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    final streak = streakBox.query(StreakModel_.userId.equals(userId)).build().findFirst();

    if (streak == null) {
      final newStreak = StreakModel(
        userId: userId,
        streakCount: 1,
        isStreakLost: false,
        activityDates: [todayOnly.millisecondsSinceEpoch],
        bestStreak: 1,
        lastActiveDate: todayOnly.millisecondsSinceEpoch,
      );
      streakBox.put(newStreak);
      return;
    }

    final lastActiveDate = DateTime.fromMillisecondsSinceEpoch(streak.lastActiveDate);
    final diffDays = todayOnly.difference(DateTime(lastActiveDate.year, lastActiveDate.month, lastActiveDate.day)).inDays;

    if (diffDays == 0) return; // already updated today

    if (diffDays == 1) {
      streak.streakCount += 1;
      streak.isStreakLost = false;
    } else {
      streak.streakCount = 1;
      streak.isStreakLost = true;
    }

    streak.lastActiveDate = todayOnly.millisecondsSinceEpoch;

    // Prevent duplicate entries
    final dates = streak.activityDates.map((ts) => DateTime.fromMillisecondsSinceEpoch(ts)).toSet();
    dates.add(todayOnly);
    streak.activityDates = dates.map((d) => d.millisecondsSinceEpoch).toList();

    // Update best streak if needed
    if (streak.streakCount > streak.bestStreak) {
      streak.bestStreak = streak.streakCount;
    }

    streakBox.put(streak);
  }

  int getBestStreak(String userId) {
    final streak = streakBox.query(StreakModel_.userId.equals(userId)).build().findFirst();
    return streak?.bestStreak ?? 0;
  }
}

