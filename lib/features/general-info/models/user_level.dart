import 'package:easy_localization/easy_localization.dart';

enum UserLevel { Beginner, Intermediate, Native }

extension UserLevelExtension on UserLevel {
  String get levelName {
    switch (this) {
      case UserLevel.Beginner:
        return 'Beginner';
      case UserLevel.Intermediate:
        return 'Intermediate';
      case UserLevel.Native:
        return 'Native';
    }
  }

  static UserLevel fromString(String value) {
    return UserLevel.values.firstWhere(
          (e) => e.name == value,
      orElse: () => UserLevel.Beginner,
    );
  }
}
