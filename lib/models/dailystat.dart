import 'package:hive/hive.dart';

part 'dailystat.g.dart';

@HiveType(typeId: 1)
class DailyStat extends HiveObject {
  @HiveField(0)
  String date;

  @HiveField(1)
  int count;

  DailyStat({required this.date, required this.count});
  static int calculateStreak() {
    final box = Hive.box<DailyStat>('dailyStats');
    final stats = box.values.toList();

    final dates = stats.map((e) => DateTime.parse(e.date)).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime today = DateTime.now();

    bool hasToday = dates.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );

    int j = 0;
    if (!hasToday) {
      j++;
    }

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final expected = today.subtract(Duration(days: streak + j));
      if (date.year == expected.year &&
          date.month == expected.month &&
          date.day == expected.day) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}
