import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:implicitly_animated_list/implicitly_animated_list.dart';
import 'package:intl/intl.dart';
import 'package:vocaber/generated/l10n.dart';
import 'package:vocaber/models/appconfig.dart';

import '../models/word.dart';
import 'detail_screen.dart';

class WordListScreen extends StatefulWidget {
  const WordListScreen({super.key});

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

enum SortOption { date, alphabetical, reviewCount }

class WordEntry {
  final dynamic key;
  final Word word;
  WordEntry(this.key, this.word);
}

class _WordListScreenState extends State<WordListScreen> {
  SortOption _currentSort = SortOption.date;
  final String _language = AppConfig().prefs.getString('language') ?? 'en';

  @override
  void initState() {
    super.initState();
  }

  List<WordEntry> _sortedEntries(Box<Word> box) {
    final filtered = box
        .toMap()
        .entries
        .where((e) => e.value.language == _language)
        .map((e) => WordEntry(e.key, e.value))
        .toList();

    switch (_currentSort) {
      case SortOption.date:
        filtered.sort((a, b) => b.word.createdAt.compareTo(a.word.createdAt));
        break;
      case SortOption.alphabetical:
        filtered.sort((a, b) => a.word.term.compareTo(b.word.term));
        break;
      case SortOption.reviewCount:
        filtered.sort(
          (a, b) => b.word.reviewCount.compareTo(a.word.reviewCount),
        );
        break;
    }

    return filtered;
  }

  Color _reviewColor(BuildContext context, int count) {
    final colorScheme = Theme.of(context).colorScheme;
    if (count <= 0) return colorScheme.error;
    if (count == 1) return colorScheme.secondary;
    if (count == 2) return colorScheme.secondary.withValues(alpha: 0.7);
    if (count == 3) return colorScheme.secondary.withValues(alpha: 0.85);
    if (count == 4) return colorScheme.secondary;
    return colorScheme.secondary.withValues(alpha: 0.5);
  }

  Widget _buildEmptyState() => Center(
    child: Text(
      AppLocalizations.of(
        context,
      )!.noWordsYet(AppConfig().supportedLanguages[_language] ?? _language),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    ),
  );

  Widget _buildWordTile(Box<Word> box, WordEntry entry) {
    final word = entry.word;
    final key = entry.key;
    final locale = Localizations.localeOf(context).toString();
    final formattedDate = DateFormat(
      'dd MMM yyyy',
      locale,
    ).format(word.createdAt);

    return Dismissible(
      key: Key(key.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      onDismissed: (_) {
        box.delete(key);
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          title: Text(
            word.term,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(AppLocalizations.of(context)!.addedOn(formattedDate)),
          trailing: Container(
            decoration: BoxDecoration(
              color: _reviewColor(context, word.reviewCount),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Text(
              word.reviewCount > 5
                  ? AppLocalizations.of(context)!.learned
                  : AppLocalizations.of(context)!.reviews(word.reviewCount),
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => DetailScreen(word: word)),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wordBox = Hive.box<Word>('words');
    final entries = _sortedEntries(wordBox);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myWords),
        actions: [
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (option) => setState(() => _currentSort = option),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: SortOption.date,
                child: Text(AppLocalizations.of(context)!.sortByDate),
              ),
              PopupMenuItem(
                value: SortOption.alphabetical,
                child: Text(AppLocalizations.of(context)!.sortAlphabetically),
              ),
              PopupMenuItem(
                value: SortOption.reviewCount,
                child: Text(AppLocalizations.of(context)!.sortByReviewCount),
              ),
            ],
          ),
        ],
      ),
      body: entries.isEmpty
          ? _buildEmptyState()
          : ImplicitlyAnimatedList<WordEntry>(
              itemData: entries,
              itemBuilder: (context, entry) => _buildWordTile(wordBox, entry),
              itemEquality: (a, b) => a.key == b.key,
              insertDuration: const Duration(milliseconds: 400),
            ),
    );
  }
}
