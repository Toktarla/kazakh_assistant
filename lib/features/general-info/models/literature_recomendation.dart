import 'package:objectbox/objectbox.dart';

@Entity()
class LiteratureRecomendation {
  @Id()
  int id = 0;

  String? idiom;
  String? titleKz;
  String? titleRu;
  String? titleEn;
  String? authorKz;
  String? authorRu;
  String? authorEn;
  String? imageUrl;
  String? descriptionKz;
  String? descriptionRu;
  String? descriptionEn;
  String? genreRu;
  String? genreKz;
  String? genreEn;
  double? rating;
  int? pages;
  String? releaseDate;
  String? link;
  String? level;
}