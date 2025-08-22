import 'package:flutter/material.dart';
import 'package:vocaber/models/bottom_message.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:vocaber/generated/l10n.dart';
import 'package:vocaber/models/appconfig.dart';

import '../models/dailystat.dart';
import '../models/word.dart';
import 'detail_screen.dart';

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});
  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final _controller = CardSwiperController();
  List<Word> _words = [];
  Word? lastWord;
  bool canUndo = false;

  @override
  void initState() {
    super.initState();
    _loadFilteredWords();
  }

  void _onEnd() {
    canUndo = false;
    _loadFilteredWords();
  }

  void _loadFilteredWords() {
    final language = AppConfig().prefs.getString('language') ?? 'en';
    final box = Hive.box<Word>('words');
    final now = DateTime.now();

    final filtered = box.values.where((w) {
      if (w.language != language) return false;
      if (w.reviewCount > 5) return false;
      final intervals = [0, 1, 3, 7, 14, 30];
      return now.isAfter(
        w.lastReviewed.add(
          Duration(days: intervals[w.reviewCount.clamp(0, 5)]),
        ),
      );
    }).toList();
    filtered.shuffle();
    setState(() {
      _words = filtered;
    });
  }

  bool _onUndo(
    int? previousIndex,
    int currentIndex,
    CardSwiperDirection direction,
  ) {
    if (lastWord != null) {
      _words[currentIndex] = lastWord!;
      final box = Hive.box<Word>('words');
      box.put(lastWord!.term.toLowerCase(), lastWord!);
    } else {
      return false;
    }

    canUndo = false;
    return true;
  }

  bool _onSwipe(int prev, int? curr, CardSwiperDirection dir) {
    if (curr != null) {
      lastWord = _words[prev].clone();
      canUndo = true;
    }
    final word = _words[prev];
    final box = Hive.box<Word>('words');
    final statBox = Hive.box<DailyStat>('dailyStats');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final stat = statBox.values.firstWhere(
      (s) => s.date == today,
      orElse: () => DailyStat(date: today, count: 0),
    );
    if (stat.isInBox) {
      stat.count++;
      stat.save();
    } else {
      statBox.add(DailyStat(date: today, count: 1));
    }
    if (dir == CardSwiperDirection.right) {
      word.reviewCount++;
      word.lastReviewed = DateTime.now();
    } else if (dir == CardSwiperDirection.left) {
      word.reviewCount = 0;
    }
    box.put(word.term.toLowerCase(), word);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              AppLocalizations.of(context)!.noWordsDue,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: CardSwiper(
                controller: _controller,
                cardsCount: _words.length,
                allowedSwipeDirection: AllowedSwipeDirection.symmetric(
                  horizontal: true,
                ),
                onSwipe: _onSwipe,
                onUndo: _onUndo,
                onEnd: _onEnd,
                isLoop: true,
                numberOfCardsDisplayed: 1,
                backCardOffset: const Offset(40, 40),
                padding: const EdgeInsets.all(16),
                cardBuilder: (context, i, h, v) {
                  final word = _words[i];
                  final w = MediaQuery.of(context).size.width;
                  final swipe = (h / w).clamp(-1.0, 1.0);
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailScreen(word: word),
                      ),
                    ),
                    child: Center(
                      child: AspectRatio(
                        aspectRatio: 5 / 8,
                        child: Stack(
                          children: [
                            Card(
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                              margin: const EdgeInsets.all(16),
                              color: Theme.of(context).cardColor,
                              child: Center(
                                child: Text(
                                  word.term,
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            if (swipe > 0)
                              Positioned(
                                top: 60,
                                left: 40,
                                child: Opacity(
                                  opacity: (swipe * 2).clamp(0.0, 1.0),
                                  child: Transform.rotate(
                                    angle: -0.3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 4,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.green.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.gotIt,
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            if (swipe < 0)
                              Positioned(
                                top: 60,
                                right: 40,
                                child: Opacity(
                                  opacity: (-swipe * 2).clamp(0.0, 1.0),
                                  child: Transform.rotate(
                                    angle: 0.3,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.redAccent,
                                          width: 4,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.redAccent.withValues(
                                          alpha: 0.15,
                                        ),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.forgot,
                                        style: const TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 25,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: 'undo',
                    onPressed: () {
                      if (!canUndo) {
                        AppBottomSheet.show(
                          context,
                          message: AppLocalizations.of(context)!.undoNotAllowed,
                          type: BottomSheetType.error,
                        );
                        return;
                      }
                      _controller.undo();
                    },
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.rotate_left,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'left',
                    onPressed: () =>
                        _controller.swipe(CardSwiperDirection.left),
                    backgroundColor: Colors.redAccent,
                    child: const Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                    ),
                  ),
                  FloatingActionButton(
                    heroTag: 'right',
                    onPressed: () =>
                        _controller.swipe(CardSwiperDirection.right),
                    backgroundColor: Colors.green,
                    child: const Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
