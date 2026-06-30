import 'dart:async';
import 'dart:io';

import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

import 'definition_provider.dart';

class LarousseDefinitionProvider extends DefinitionProvider {
  LarousseDefinitionProvider(super.word);

  @override
  Future<List<String>> getDefinitions() async {
    final url = 'https://www.larousse.fr/dictionnaires/francais/${word.toLowerCase()}';
    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        return ['$definitionErrorPrefix|HTTP|${response.statusCode}'];
      }

      final document = parser.parse(response.body);
      final definitionDiv = document.getElementById('definition');

      if (definitionDiv == null) {
        return ['$definitionErrorPrefix|PARSING|no_definition_div'];
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

      if (definitions.isEmpty) return ['$definitionErrorPrefix|PARSING|no_definitions_found'];

      return definitions;
    } on TimeoutException catch (_) {
      return ['$definitionErrorPrefix|TIMEOUT|'];
    } on SocketException catch (e) {
      return ['$definitionErrorPrefix|NETWORK|${e.message}'];
    } catch (e) {
      return ['$definitionErrorPrefix|UNKNOWN|${e.toString()}'];
    }
  }
}
