import 'package:hive/hive.dart';
import 'package:vocaber/models/appconfig.dart';
import 'scrapers/larousse_scraper.dart';
import 'scrapers/wordreference_scraper.dart';
import 'scrapers/scraper.dart';

part 'word.g.dart';

String capitalize(String s) {
  if (s.isEmpty) return s;
  return s[0].toUpperCase() + s.substring(1);
}

@HiveType(typeId: 0)
class Word {
  @HiveField(0)
  final String term;

  @HiveField(1)
  final List<String> definitions;

  @HiveField(2)
  int reviewCount;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  DateTime lastReviewed;

  @HiveField(5)
  final String language;

  Word clone() {
    return Word(
      term: term,
      definitions: List<String>.from(definitions),
      reviewCount: reviewCount,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        createdAt.millisecondsSinceEpoch,
      ),
      lastReviewed: DateTime.fromMillisecondsSinceEpoch(
        lastReviewed.millisecondsSinceEpoch,
      ),
      language: language,
    );
  }

  Word({
    required this.term,
    required this.definitions,
    required this.language,
    this.reviewCount = 0,
    DateTime? createdAt,
    DateTime? lastReviewed,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastReviewed = lastReviewed ?? DateTime.now();

  static Future<Word> fromTerm(String term) async {
    final language = AppConfig().prefs.getString('language') ?? 'en';
    term = capitalize(term);

    Scraper scraper;
    switch (language) {
      case "fr":
        scraper = LarousseScraper(term);
        break;
      default:
        scraper = WordReferenceScraper(term);
        break;
    }

    final definitions = await scraper.getDefinitions();
    final now = DateTime.now();

    return Word(
      term: term,
      definitions: definitions,
      language: language,
      reviewCount: 0,
      createdAt: now,
      lastReviewed: now,
    );
  }
}
