abstract class Scraper {
  String word;
  Scraper(this.word);
  Future<List<String>> getDefinitions();
}
