import 'package:objectbox/objectbox.dart';

@Entity()
class Proverb {
  @Id()
  int id = 0;

  String? proverb;
  String? audioUrl;
  String? meaningKz;
  String? meaningRu;
  String? meaningEn;
  String? usageKz;
  String? usageRu;
  String? usageEn;
  String? example;
  String? authorKz;
  String? authorRu;
  String? authorEn;
  bool isFavorite = false;
  bool? shareable = true;
  bool isLearned = false;
  String? imagePath;
  String? whenToUseKz;
  String? whenToUseRu;
  String? whenToUseEn;
  String? literalMeaningKz;
  String? literalMeaningRu;
  String? literalMeaningEn;
  List<String>? relatedProverbs;
  List<String>? tags;
  List<String>? tagsKz;
  List<String>? tagsRu;
  List<String>? tagsEn;
  List<String>? categories;
  List<String>? categoriesEn;
  List<String>? categoriesRu;
  List<String>? categoriesKz;

  String? level;
}