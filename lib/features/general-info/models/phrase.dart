import 'package:objectbox/objectbox.dart';

@Entity()
class PhraseTheme {
  @Id()
  int id = 0;

  String? theme;
  String? themeEn;
  String? themeRu;
  String? themeKz;
  String? description;
  String? descriptionEn;
  String? descriptionRu;
  String? descriptionKz;

  @Backlink()
  final phraseTypes = ToMany<PhraseType>();
}

@Entity()
class PhraseType {
  @Id()
  int id = 0;

  String? type;
  String? typeKz;
  String? typeRu;
  String? typeEn;

  @Backlink()
  final phrases = ToMany<Phrase>();

  final phraseTheme = ToOne<PhraseTheme>();
}

@Entity()
class Phrase {
  @Id()
  int id = 0;

  final phraseType = ToOne<PhraseType>();

  String? phrase;
  String? audioUrl;
  bool isFavorite = false;
  bool isLearned = false;
  String? meaningKz;
  String? meaningRu;
  String? meaningEn;
  String? usageKz;
  String? usageRu;
  String? usageEn;
  String? example;
  String? whenToUseKz;
  String? whenToUseRu;
  String? whenToUseEn;
  String? noteKz;
  String? noteRu;
  String? noteEn;
  List<String>? alternatives;
  String? level;
}

