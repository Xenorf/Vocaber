import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'definition_provider.dart';

// Uses the free dictionaryapi.dev JSON API as a reliable fallback.
class OedDefinitionProvider extends DefinitionProvider {
  OedDefinitionProvider(super.word);

  @override
  Future<List<String>> getDefinitions() async {
    final query = Uri.encodeComponent(word.toLowerCase());
    final url = 'https://api.dictionaryapi.dev/api/v2/entries/en/$query';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      debugPrint('dictionaryapi.dev returned ${response.statusCode} for $word');
      return [];
    }

    final List<dynamic> jsonBody = json.decode(response.body);
    if (jsonBody.isEmpty) return [];

    final definitions = <String>[];

    for (final entry in jsonBody) {
      final meanings = entry['meanings'] as List<dynamic>?;
      if (meanings == null) continue;

      for (final meaning in meanings) {
        final partOfSpeech = meaning['partOfSpeech'] as String? ?? '';
        final defs = meaning['definitions'] as List<dynamic>?;
        if (defs == null) continue;

        for (final def in defs) {
          final definitionText = def['definition'] as String? ?? '';
          final example = def['example'] as String?;

          var combined = definitionText;
          if (example != null && example.trim().isNotEmpty) {
            combined = '$combined — "${example.trim()}"';
          }

          if (partOfSpeech.isNotEmpty) {
            combined = '${partOfSpeech.trim()}: $combined';
          }

          var cleanText = combined
              .replaceAll(RegExp(r'[\n\r\t]'), ' ')
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();

          if (cleanText.isNotEmpty) definitions.add(cleanText);
        }
      }
    }

    final numbered = definitions
        .asMap()
        .entries
        .map((e) => '${e.key + 1}. ${e.value}')
        .toList();

    return numbered;
  }
}
