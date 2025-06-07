import 'package:objectbox/objectbox.dart';

@Entity()
class FillInTheBlank {
  int id;

  String textBeforeKk;
  String textBeforeRu;
  String textBeforeEn;

  String answerKk;
  String answerRu;
  String answerEn;

  String textAfterKk;
  String textAfterRu;
  String textAfterEn;

  String level;

  FillInTheBlank({
    this.id = 0,
    required this.textBeforeKk,
    required this.textBeforeRu,
    required this.textBeforeEn,
    required this.answerKk,
    required this.answerRu,
    required this.answerEn,
    required this.textAfterKk,
    required this.textAfterRu,
    required this.textAfterEn,
    required this.level,
  });
}
