import 'package:flutter/material.dart';
import 'package:proj_management_project/utils/extensions/localized_context_extension.dart';

import '../../config/data.dart';
import '../../config/di/injection_container.dart';
import '../remote/firestore_service.dart';

class RankingService {
  static List<LevelData> generateLevels(BuildContext context) {
    List<LevelData> levels = [];

    int titleIndex = 0;
    int colorIndex = 0;

    for (int i = 1; i <= 100; i++) {
      if ((i - 1) % 5 == 0 && i != 1) {
        colorIndex = (colorIndex + 1) % rankBaseColors.length;
        titleIndex = (titleIndex + 1) % rankTitlesEn.length;
      }

      levels.add(LevelData(
        level: i,
        title: context.localizedValueList(
          kz: rankTitlesKk,
          ru: rankTitlesRu,
          en: rankTitlesEn,
        )![titleIndex],
        color: rankBaseColors[colorIndex],
      ));
    }

    return levels;
  }

  static LevelData getLevelData(BuildContext context, int level) {
    List<LevelData> levels = generateLevels(context);
    return levels.firstWhere((data) => data.level == level);
  }

  static Future<int> getCurrentUserLevel() {
    return sl<FirestoreService>().getCurrentUserLevel();
  }

  static Future<void> levelUp() async {
    final service = sl<FirestoreService>();
    int level = await service.getCurrentUserLevel();
    int progress = await service.getCurrentUserProgress();

    if (level < 100) {
      await service.updateUserLevelData(level: level + 1, progress: progress);
    }
  }

  static Future<void> levelDown() async {
    final service = sl<FirestoreService>();
    int level = await service.getCurrentUserLevel();
    int progress = await service.getCurrentUserProgress();

    if (level > 1) {
      await service.updateUserLevelData(level: level - 1, progress: progress);
    }
  }

  static Future<void> addProgress(int points) {
    return sl<FirestoreService>().addProgress(points);
  }

  static Future<double> getUserLevelProgress() {
    return sl<FirestoreService>().getUserLevelProgress();
  }
}

class LevelData {
  final int level;
  final String title;
  final Color color;

  LevelData({
    required this.level,
    required this.title,
    this.color = Colors.pink,
  });
}