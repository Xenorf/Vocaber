// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Vocaber';

  @override
  String get getDefinition => 'Get Definition';

  @override
  String get enterWord => 'Enter a word';

  @override
  String noDefinitionsFound(Object word) {
    return 'No definitions found for \"$word\".';
  }

  @override
  String reviewedTimes(Object count) {
    return 'Reviewed: $count time(s)';
  }

  @override
  String added(Object date) {
    return 'Added: $date';
  }

  @override
  String lastReviewed(Object date) {
    return 'Last reviewed: $date';
  }

  @override
  String get definitions => 'Definitions:';

  @override
  String reviews(Object count) {
    return 'Reviews: $count';
  }

  @override
  String get learned => 'Learned';

  @override
  String addedOn(Object date) {
    return 'Added on $date';
  }

  @override
  String get myWords => 'My Words';

  @override
  String get sortByDate => 'Sort by Date';

  @override
  String get sortAlphabetically => 'Sort Alphabetically';

  @override
  String get sortByReviewCount => 'Sort by Review Count';

  @override
  String noWordsYet(Object language) {
    return 'No words yet for language \"$language\"!\nStart adding new words to see them here.';
  }

  @override
  String get noWordsDue => 'No words are due for review. Come back later!';

  @override
  String get gotIt => 'GOT IT';

  @override
  String get forgot => 'FORGOT';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get exportedClipboard => 'Words exported to clipboard';

  @override
  String get clipboardEmpty => 'Clipboard is empty';

  @override
  String get noWordsToImport => 'No words imported';

  @override
  String get confirmImportTitle => 'Confirm Import';

  @override
  String confirmImportContent(Object count, Object language) {
    return 'You are about to import $count words from the clipboard into $language. Continue?';
  }

  @override
  String get importingWordsTitle => 'Importing Words';

  @override
  String importedProgress(Object total, Object value) {
    return 'Imported $value of $total';
  }

  @override
  String importedNewWords(Object count) {
    return 'Imported $count new words';
  }

  @override
  String get undoNotAllowed => 'You can\'t undo in this situation';

  @override
  String get dailySwipeCount => 'Daily Swipe Count';

  @override
  String get english => 'English';

  @override
  String get french => 'French';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get username => 'Username';

  @override
  String get defaultUser => 'Anonymous';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get finish => 'Finish';

  @override
  String levelXp(Object level, Object xpInCurrentLevel, Object xpPerLevel) {
    return 'Lvl $level • $xpInCurrentLevel / $xpPerLevel XP';
  }

  @override
  String get navDefine => 'Search';

  @override
  String get navReview => 'Review';

  @override
  String get navProfile => 'Profile';

  @override
  String get createProfile => 'Create Profile';

  @override
  String get preferredLanguage => 'Vocabulary Language';

  @override
  String get uploadImage => 'Upload Image';

  @override
  String get useImageLink => 'Use Image Link';

  @override
  String get imageUrl => 'Image URL';

  @override
  String get tutorialDefine =>
      'Look up definitions for new words and add them to your personal vocabulary list.';

  @override
  String get tutorialReview =>
      'Review words using flashcards and science-based training.';

  @override
  String get tutorialProfile =>
      'Customize your profile, set your vocabulary language, and view your stats.';

  @override
  String get tutorialLocal =>
      'All your data is stored locally to ensure privacy. You can export or import your words anytime.';

  @override
  String get tutorialProfileSetup =>
      'Set up your profile to personalize your experience.';

  @override
  String get tutorialLocalTitle => 'Local & Private';

  @override
  String get errorWhileImporting =>
      'Something went wrong while importing. Please try again later.';

  @override
  String get next => 'Next';
}
