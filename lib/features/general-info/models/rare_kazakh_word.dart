import 'package:objectbox/objectbox.dart';

@Entity()
class RareKazakhWordType {
  @Id()
  int id = 0;

  String? section;
  String? sectionKz;
  String? sectionRu;
  String? sectionEn;
  String? imageUrl;
  double? progress;

  @Backlink()
  final words = ToMany<RareKazakhWord>();
}

@Entity()
class RareKazakhWord {
  @Id()
  int id = 0;
  final idiomType = ToOne<RareKazakhWordType>();

  String? word;
  String? audioUrl;
  String? meaningKz;
  String? meaningRu;
  String? meaningEn;
  bool isFavorite = false;
  bool isLearned = false;
  String? etymologyRu;
  String? etymologyEn;
  String? etymologyKz;
  List<String>? examples;
  String? poemExample;
  String? writingExample;
  String? level;
}