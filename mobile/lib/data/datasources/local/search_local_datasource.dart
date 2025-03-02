

abstract class SearchLocalDatasource {
  Future<void> saveRecentSearches(List<String> searches);
  List<String> getRecentSearches();
  Future<void> clearRecentSearches();
  Future<void> removeRecentSearch(String search);
}