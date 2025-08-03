// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'l10n.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Vocaber';

  @override
  String get getDefinition => 'Obtenir la définition';

  @override
  String get enterWord => 'Entrez un mot';

  @override
  String noDefinitionsFound(Object word) {
    return 'Aucune définition trouvée pour \"$word\".';
  }

  @override
  String reviewedTimes(Object count) {
    return 'Révisé : $count fois';
  }

  @override
  String added(Object date) {
    return 'Ajouté : $date';
  }

  @override
  String lastReviewed(Object date) {
    return 'Dernière révision : $date';
  }

  @override
  String get definitions => 'Définitions :';

  @override
  String reviews(Object count) {
    return 'Révisions : $count';
  }

  @override
  String get learned => 'Appris';

  @override
  String addedOn(Object date) {
    return 'Ajouté le $date';
  }

  @override
  String get myWords => 'Mes mots';

  @override
  String get sortByDate => 'Trier par date';

  @override
  String get sortAlphabetically => 'Trier par ordre alphabétique';

  @override
  String get sortByReviewCount => 'Trier par nombre de révisions';

  @override
  String noWordsYet(Object language) {
    return 'Aucun mot pour la langue \"$language\" !\nAjoutez de nouveaux mots pour les voir ici.';
  }

  @override
  String get noWordsDue => 'Aucun mot à réviser. Revenez plus tard !';

  @override
  String get gotIt => 'COMPRIS';

  @override
  String get forgot => 'OUBLIÉ';

  @override
  String get export => 'Exporter';

  @override
  String get import => 'Importer';

  @override
  String get exportedClipboard => 'Mots exportés dans le presse-papiers';

  @override
  String get clipboardEmpty => 'Le presse-papiers est vide';

  @override
  String get noWordsToImport => 'Aucun mot à importer';

  @override
  String get confirmImportTitle => 'Confirmer l\'importation';

  @override
  String confirmImportContent(Object count, Object language) {
    return 'Vous êtes sur le point d\'importer $count mots du presse-papiers dans la langue \"$language\". Continuer ?';
  }

  @override
  String get importingWordsTitle => 'Importation des mots';

  @override
  String importedProgress(Object total, Object value) {
    return '$value sur $total importés';
  }

  @override
  String importedNewWords(Object count) {
    return '$count nouveaux mots importés';
  }

  @override
  String get undoNotAllowed => 'Annulation impossible dans cette situation';

  @override
  String get dailySwipeCount => 'Nombre de révisions';

  @override
  String get english => 'Anglais';

  @override
  String get french => 'Français';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get defaultUser => 'Anonyme';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String levelXp(Object level, Object xpInCurrentLevel, Object xpPerLevel) {
    return 'Niveau $level • $xpInCurrentLevel / $xpPerLevel XP';
  }

  @override
  String get navDefine => 'Rechercher';

  @override
  String get navReview => 'Réviser';

  @override
  String get navProfile => 'Profil';

  @override
  String get createProfile => 'Créer un profil';

  @override
  String get preferredLanguage => 'Langue préférée';

  @override
  String get uploadImage => 'Télécharger une image';

  @override
  String get useImageLink => 'Utiliser un lien d\'image';

  @override
  String get imageUrl => 'URL de l\'image';

  @override
  String get tutorialDefine =>
      'Consultez la définition des nouveaux mots et ajoutez-les à votre liste de vocabulaire personnelle.';

  @override
  String get tutorialReview =>
      'Révisez les mots avec des flashcards et optimisez votre apprentissage.';

  @override
  String get tutorialProfile =>
      'Personnalisez votre profil, choisissez la langue de votre vocabulaire et consultez vos statistiques.';

  @override
  String get tutorialLocal =>
      'Toutes vos données sont stockées localement. Vous pouvez exporter ou importer vos mots à tout moment.';

  @override
  String get tutorialProfileSetup =>
      'Configurez votre profil pour personnaliser votre expérience.';

  @override
  String get tutorialLocalTitle => 'Local & Privé';

  @override
  String get errorWhileImporting =>
      'Une erreur est survenue lors de l\'importation des mots. Veuillez réessayer plus tard.';

  @override
  String get next => 'Suivant';
}
