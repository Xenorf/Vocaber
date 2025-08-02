import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vocaber/generated/l10n.dart';

import '../models/dailystat.dart';
import '../models/word.dart';

class DetailScreen extends StatelessWidget {
  final Word word;

  const DetailScreen({super.key, required this.word});

  String formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_jm().format(date);
  }

  int calculateStreak(List<DailyStat> stats) {
    final dates = stats.map((e) => DateTime.parse(e.date)).toList()
      ..sort((a, b) => b.compareTo(a));

    int streak = 0;
    DateTime today = DateTime.now();

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final expected = today.subtract(Duration(days: streak));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                word.term,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.definitions,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...word.definitions.asMap().entries.map((entry) {
                final definition = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Text(
                    definition,
                    style: const TextStyle(fontSize: 18, color: Colors.black87),
                  ),
                );
              }),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Icon(Icons.repeat, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.reviewedTimes(word.reviewCount),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.added(formatDate(context, word.createdAt)),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.update, size: 20, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.lastReviewed(formatDate(context, word.lastReviewed)),
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
