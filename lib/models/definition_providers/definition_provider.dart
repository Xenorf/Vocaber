import 'dart:core';

/// Prefix used by definition providers to signal an error result that the UI
/// should localize and display appropriately. Format:
/// ___DEF_ERROR___|TYPE|DATA
/// TYPE can be: HTTP, NETWORK, TIMEOUT, PARSING, UNKNOWN
const String definitionErrorPrefix = '___DEF_ERROR___';

abstract class DefinitionProvider {
  String word;
  DefinitionProvider(this.word);
  Future<List<String>> getDefinitions();
}
