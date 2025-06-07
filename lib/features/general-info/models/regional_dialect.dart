import 'package:objectbox/objectbox.dart';

@Entity()
class RegionalDialectType {
  int id = 0;

  String? type;
  String? typeEn;
  String? typeRu;
  String? typeKz;

  @Backlink()
  final dialects = ToMany<RegionalDialect>();
}

@Entity()
class RegionalDialect {
  @Id()
  int id = 0;

  final dialectType = ToOne<RegionalDialectType>();

  String? dialect;
  String? standart;
  String? meaningKz;
  String? meaningRu;
  String? meaningEn;
  String? usageKz;
  String? usageRu;
  String? usageEn;
  String? level;
}