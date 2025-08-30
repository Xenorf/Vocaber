import 'package:hive/hive.dart';
import 'package:vocaber/models/word.dart';

void importDefaultWords(String language) {
  final box = Hive.box<Word>('words');
  if (box.isEmpty) {
    final words = defaultWords[language] ?? defaultWords['en']!;
    for (final word in words) {
      box.put(word.term.toLowerCase(), word);
    }
  }
}

final Map<String, List<Word>> defaultWords = {
  'fr': [
    Word(
      term: 'Imprécation',
      definitions: [
        "Littéraire. Malédiction proférée contre quelqu'un ; parole ou souhait appelant le malheur sur quelqu'un. Synonymes : anathème - exécration - malédiction",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Idiosyncrasie',
      definitions: [
        "1. Manière d'être particulière à chaque individu qui l'amène à avoir tel type de réaction, de comportement qui lui est propre.",
        "2. Synonyme ancien de anaphylaxie ou de allergie. Synonymes : anaphylaxie - allergie",
        "3. Disposition particulière de l'organisme à réagir de façon inhabituelle à un médicament ou à une substance.",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Aphorisme',
      definitions: [
        "1. Phrase, sentence qui résume en quelques mots une vérité fondamentale. (Exemple : Rien n'est beau que le vrai.) Synonymes : apophtegme - formule - maxime - précepte - sentence",
        "2. Énoncé succinct d'une vérité banale. (Exemple : Pas de nouvelles, bonnes nouvelles.) Synonymes : adage - dicton - maxime - proverbe",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Oraison',
      definitions: [
        "1. Prière liturgique de la messe et de l'office des heures.",
        "2. Prière mentale sous forme de méditation, dans laquelle le cœur a plus de part que l'esprit.",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Ignare',
      definitions: [
        "Qui est scandaleusement ignorant ; sans culture ni instruction. Synonymes : ignorant - incapable - incompétent - inculte - nul. Contraires : cultivé - instruit - savant",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Brimer',
      definitions: [
        "1. Faire subir à un nouveau dans les écoles et les casernes des épreuves, des vexations, pour éprouver son caractère. Synonyme : bizuter (argot scolaire)",
        "2. Soumettre quelqu'un à une série de difficultés inutiles, le plus souvent en abusant de son autorité. Synonymes : persécuter - tarabuster (familier)",
        "3. Contraindre quelqu'un, faire obstacle à sa liberté : Il se sent frustré et brimé.",
      ],
      language: 'fr',
    ),
    Word(
      term: 'Prosaïque',
      definitions: [
        "1. Qui est dépourvu de noblesse, de distinction, d'élégance : Un être prosaïque. Une existence prosaïque. Synonymes : banal - commun - insipide - morne - ordinaire - plat - quelconque - terne. Contraires : coloré - original - pittoresque - vivant",
        "2. Se dit d'une remarque bassement matérielle, réaliste : Excusez ce détail prosaïque, mais j'ai mal à l'estomac. Synonymes : matériel - vulgaire. Contraires : distingué - élégant",
      ],
      language: 'fr',
    ),
  ],
  'en': [
    Word(
      term: 'Ephemeral',
      definitions: [
        "1. lasting a very short time; short-lived; transitory: the ephemeral joys of youth.",
      ],
      language: 'en',
    ),
    Word(
      term: 'Serendipity',
      definitions: [
        "1. an ability for making desirable discoveries by accident.",
        "2. good fortune; luck.",
      ],
      language: 'en',
    ),
    Word(
      term: 'Sonorous',
      definitions: [
        "1. echoing with a deep sound; resonant: a sonorous cavern.",
        "2. loud and deep-toned: a sonorous voice.",
        "3. high-flown; very grand or fancy in speaking or in sound: a sonorous speech.",
      ],
      language: 'en',
    ),
  ],
};
