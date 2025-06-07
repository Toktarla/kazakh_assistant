import 'package:objectbox/objectbox.dart';
import 'package:proj_management_project/features/general-info/models/content_type.dart';

@Entity()
class Section {
  @Id()
  int id = 0;

  String? title;
  String? titleRu;
  String? titleEn;
  String? titleKz;
  String? description;
  String? descriptionKz;
  String? descriptionRu;
  String? descriptionEn;
  String? contentTypeString;

  int? contentTypeIndex;

  @Transient()
  ContentType get contentType => ContentType.values[contentTypeIndex ?? 0];
  set contentType(ContentType value) => contentTypeIndex = value.index;
}
