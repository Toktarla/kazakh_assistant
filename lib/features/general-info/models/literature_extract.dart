import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class LiteratureExtract {
  @Id()
  int id = 0;

  String? audioUrl;
  String? titleKz;
  String? titleRu;
  String? titleEn;
  String? authorKz;
  String? authorRu;
  String? authorEn;
  String? imageUrl;
  String? level;

  @Backlink()
  final lines = ToMany<Line>();
}

@Entity()
class Line {
  @Id()
  int id = 0;

  List<String>? kz;
  List<String>? ru;
  List<String>? en;

  String? translationIndexRuJson;
  String? translationIndexEnJson;

  @Transient()
  List<List<int>>? get translationIndexRu => translationIndexRuJson != null
      ? (jsonDecode(translationIndexRuJson!) as List)
      .map((e) => List<int>.from(e as List))
      .toList()
      : null;

  set translationIndexRu(List<List<int>>? value) =>
      translationIndexRuJson = value != null ? jsonEncode(value) : null;

  @Transient()
  List<List<int>>? get translationIndexEn => translationIndexEnJson != null
      ? (jsonDecode(translationIndexEnJson!) as List)
      .map((e) => List<int>.from(e as List))
      .toList()
      : null;

  set translationIndexEn(List<List<int>>? value) =>
      translationIndexEnJson = value != null ? jsonEncode(value) : null;

  final literatureExtract = ToOne<LiteratureExtract>();

  Line({
    this.kz,
    this.ru,
    this.en,
    this.translationIndexRuJson,
    this.translationIndexEnJson,
  });
}
