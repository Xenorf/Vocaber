abstract class DefinitionProvider {
  String word;
  DefinitionProvider(this.word);
  Future<List<String>> getDefinitions();
}
