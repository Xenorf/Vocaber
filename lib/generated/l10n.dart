import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Vocaber'**
  String get appTitle;

  /// No description provided for @getDefinition.
  ///
  /// In en, this message translates to:
  /// **'Get Definition'**
  String get getDefinition;

  /// No description provided for @enterWord.
  ///
  /// In en, this message translates to:
  /// **'Enter a word'**
  String get enterWord;

  /// No description provided for @noDefinitionsFound.
  ///
  /// In en, this message translates to:
  /// **'No definitions found for \"{word}\".'**
  String noDefinitionsFound(Object word);

  /// No description provided for @reviewedTimes.
  ///
  /// In en, this message translates to:
  /// **'Reviewed: {count} time(s)'**
  String reviewedTimes(Object count);

  /// No description provided for @added.
  ///
  /// In en, this message translates to:
  /// **'Added: {date}'**
  String added(Object date);

  /// No description provided for @lastReviewed.
  ///
  /// In en, this message translates to:
  /// **'Last reviewed: {date}'**
  String lastReviewed(Object date);

  /// No description provided for @definitions.
  ///
  /// In en, this message translates to:
  /// **'Definitions:'**
  String get definitions;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews: {count}'**
  String reviews(Object count);

  /// No description provided for @learned.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get learned;

  /// No description provided for @addedOn.
  ///
  /// In en, this message translates to:
  /// **'Added on {date}'**
  String addedOn(Object date);

  /// No description provided for @myWords.
  ///
  /// In en, this message translates to:
  /// **'My Words'**
  String get myWords;

  /// No description provided for @sortByDate.
  ///
  /// In en, this message translates to:
  /// **'Sort by Date'**
  String get sortByDate;

  /// No description provided for @sortAlphabetically.
  ///
  /// In en, this message translates to:
  /// **'Sort Alphabetically'**
  String get sortAlphabetically;

  /// No description provided for @sortByReviewCount.
  ///
  /// In en, this message translates to:
  /// **'Sort by Review Count'**
  String get sortByReviewCount;

  /// No description provided for @noWordsYet.
  ///
  /// In en, this message translates to:
  /// **'No words yet for language \"{language}\"!\nStart adding new words to see them here.'**
  String noWordsYet(Object language);

  /// No description provided for @noWordsDue.
  ///
  /// In en, this message translates to:
  /// **'No words are due for review. Come back later!'**
  String get noWordsDue;

  /// No description provided for @gotIt.
  ///
  /// In en, this message translates to:
  /// **'GOT IT'**
  String get gotIt;

  /// No description provided for @forgot.
  ///
  /// In en, this message translates to:
  /// **'FORGOT'**
  String get forgot;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @exportedClipboard.
  ///
  /// In en, this message translates to:
  /// **'Words exported to clipboard'**
  String get exportedClipboard;

  /// No description provided for @clipboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get clipboardEmpty;

  /// No description provided for @noWordsToImport.
  ///
  /// In en, this message translates to:
  /// **'No words to import'**
  String get noWordsToImport;

  /// No description provided for @confirmImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Import'**
  String get confirmImportTitle;

  /// No description provided for @confirmImportContent.
  ///
  /// In en, this message translates to:
  /// **'You are about to import {count} words from the clipboard into {language}. Continue?'**
  String confirmImportContent(Object count, Object language);

  /// No description provided for @importingWordsTitle.
  ///
  /// In en, this message translates to:
  /// **'Importing Words'**
  String get importingWordsTitle;

  /// No description provided for @importedProgress.
  ///
  /// In en, this message translates to:
  /// **'Imported {value} of {total}'**
  String importedProgress(Object total, Object value);

  /// No description provided for @importedNewWords.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} new words'**
  String importedNewWords(Object count);

  /// No description provided for @undoNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You can\'t undo in this situation'**
  String get undoNotAllowed;

  /// No description provided for @dailySwipeCount.
  ///
  /// In en, this message translates to:
  /// **'Daily Swipe Count'**
  String get dailySwipeCount;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get defaultUser;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @levelXp.
  ///
  /// In en, this message translates to:
  /// **'Lvl {level} • {xpInCurrentLevel} / {xpPerLevel} XP'**
  String levelXp(Object level, Object xpInCurrentLevel, Object xpPerLevel);

  /// No description provided for @navDefine.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get navDefine;

  /// No description provided for @navReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get navReview;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @createProfile.
  ///
  /// In en, this message translates to:
  /// **'Create Profile'**
  String get createProfile;

  /// No description provided for @preferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Vocabulary Language'**
  String get preferredLanguage;

  /// No description provided for @uploadImage.
  ///
  /// In en, this message translates to:
  /// **'Upload Image'**
  String get uploadImage;

  /// No description provided for @useImageLink.
  ///
  /// In en, this message translates to:
  /// **'Use Image Link'**
  String get useImageLink;

  /// No description provided for @imageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get imageUrl;

  /// No description provided for @tutorialDefine.
  ///
  /// In en, this message translates to:
  /// **'Look up definitions for new words and add them to your personal vocabulary list.'**
  String get tutorialDefine;

  /// No description provided for @tutorialReview.
  ///
  /// In en, this message translates to:
  /// **'Review words using flashcards and science-based training.'**
  String get tutorialReview;

  /// No description provided for @tutorialProfile.
  ///
  /// In en, this message translates to:
  /// **'Customize your profile, set your vocabulary language, and view your stats.'**
  String get tutorialProfile;

  /// No description provided for @tutorialLocal.
  ///
  /// In en, this message translates to:
  /// **'All your data is stored locally to ensure privacy. You can export or import your words anytime.'**
  String get tutorialLocal;

  /// No description provided for @tutorialProfileSetup.
  ///
  /// In en, this message translates to:
  /// **'Set up your profile to personalize your experience.'**
  String get tutorialProfileSetup;

  /// No description provided for @tutorialLocalTitle.
  ///
  /// In en, this message translates to:
  /// **'Local & Private'**
  String get tutorialLocalTitle;

  /// No description provided for @errorWhileImporting.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong while importing. Please try again later.'**
  String get errorWhileImporting;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
