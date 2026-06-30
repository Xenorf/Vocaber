import 'package:hive_ce/hive.dart';

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
    final today = DateTime.now();

    final hasToday = dates.any(
      (d) =>
          d.year == today.year && d.month == today.month && d.day == today.day,
    );

    int offset = hasToday ? 0 : 1;

    for (int i = 0; i < dates.length; i++) {
      final expected = today.subtract(Duration(days: streak + offset));

      final d = dates[i];

      if (d.year == expected.year &&
          d.month == expected.month &&
          d.day == expected.day) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
