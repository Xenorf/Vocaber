import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'definition_provider.dart';

class WordReferenceDefinitionProvider extends DefinitionProvider {
  WordReferenceDefinitionProvider(super.word);

  @override
  Future<List<String>> getDefinitions() async {
    final url =
        'https://www.wordreference.com/definition/${word.toLowerCase()}';
    final http.Response response;
    try {
      response = await http
          .get(Uri.parse(url), headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
                'AppleWebKit/537.36 (KHTML, like Gecko) '
                'Chrome/120.0.0.0 Safari/537.36',
            'Cookie': 'nginx_wr_human=1',
          })
          .timeout(const Duration(seconds: 5));
    } on TimeoutException {
      throw const NetworkException();
    } on SocketException {
      throw const NetworkException();
    }

    if (response.statusCode != 200) {
      debugPrint('Failed to load page: ${response.statusCode}');
      return [];
    }

    final document = parser.parse(response.body);

    final definitionElements = document.querySelectorAll('li').where((element) {
      final id = element.id;
      return id.startsWith('advanced_');
    }).toList();

    final definitions = <String>[];

    for (final element in definitionElements) {
      var cleanText = element.text
          .replaceAll(RegExp(r'[\n\r\t]'), ' ')
          // Add space before opening bracket or parenthesis if not already present
          .replaceAllMapped(RegExp(r'(?<! )([\(\[])'), (m) => ' ${m[1]}')
          // Add space after closing bracket or parenthesis if not already present
          .replaceAllMapped(RegExp(r'([\)\]])(?! )'), (m) => '${m[1]} ')
          // Remove space before colon or semicolon
          .replaceAllMapped(RegExp(r' (\:|;)'), (m) => m[1]!)
          // Add space after colon or semicolon if not already present
          .replaceAllMapped(RegExp(r'([:;])(?! )'), (m) => '${m[1]} ')
          // Shrink multiple spaces to one
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      if (cleanText.isNotEmpty) {
        definitions.add(cleanText);
      }
    }
    final numberedDefinitions = definitions
        .asMap()
        .entries
        .map((entry) => '${entry.key + 1}. ${entry.value}')
        .toList();

    return numberedDefinitions;
  }
}
