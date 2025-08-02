import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'scraper.dart';

class LarousseScraper extends Scraper {
  LarousseScraper(super.word);

  @override
  Future<List<String>> getDefinitions() async {
    final url =
        'https://www.larousse.fr/dictionnaires/francais/${word.toLowerCase()}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      return [];
    }

    final document = parser.parse(response.body);
    final definitionDiv = document.getElementById('definition');

    if (definitionDiv == null) {
      return [];
    }

    final definitionElements = definitionDiv.getElementsByClassName(
      'DivisionDefinition',
    );

    final definitions = <String>[];

    for (final element in definitionElements) {
      element
          .getElementsByClassName('RubriqueDefinition')
          .forEach((e) => e.remove());

      final cleanText = element.text
          .replaceAll(RegExp(r'[\n\r\t]'), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      if (cleanText.isNotEmpty) {
        definitions.add(cleanText);
      }
    }

    return definitions;
  }
}
