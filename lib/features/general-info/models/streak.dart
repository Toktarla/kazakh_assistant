import 'package:objectbox/objectbox.dart';

@Entity()
class StreakModel {
  @Id()
  int id;

  String userId;
  int streakCount;
  int bestStreak;
  int lastActiveDate;
  bool isStreakLost;

  @Property(type: PropertyType.byteVector)
  List<int> activityDates;

  StreakModel({
    this.id = 0,
    required this.userId,
    required this.streakCount,
    required this.bestStreak,
    required this.lastActiveDate,
    required this.isStreakLost,
    required this.activityDates,
  });
}