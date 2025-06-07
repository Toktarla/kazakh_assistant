import 'package:objectbox/objectbox.dart';

@Entity()
class IdiomType {
  int id = 0;

  String? type;
  String? typeEn;
  String? typeRu;
  String? typeKz;

  String? imageUrl;

  @Backlink()
  final idioms = ToMany<Idiom>();
}

@Entity()
class Idiom {
  @Id()
  int id = 0;

  final idiomType = ToOne<IdiomType>();

  String? idiom;
  String? audioUrl;

  String? meaningRu;
  String? meaningEn;
  String? meaningKz;
  bool isFavorite = false;
  bool isLearned = false;
  String? usageRu;
  String? usageEn;
  String? usageKz;
  String? example;
  String? whenToUseRu;
  String? whenToUseKz;
  String? whenToUseEn;
  String? literalMeaningKz;
  String? literalMeaningRu;
  String? literalMeaningEn;
  List<String>? synonyms;
  String? level;
}