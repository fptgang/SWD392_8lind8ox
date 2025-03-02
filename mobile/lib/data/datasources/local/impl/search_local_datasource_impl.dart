import 'dart:convert';
import 'package:injectable/injectable.dart';
import '../../shared_preferences/shared_pref_manager.dart';
import '../search_local_datasource.dart';

@Singleton(as: SearchLocalDatasource)
class SearchLocalDatasourceImpl implements SearchLocalDatasource {
  final SharedPrefManager _prefManager;
  static const String _keyRecentSearches = 'recent_searches_blindbox';

  SearchLocalDatasourceImpl(this._prefManager);

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    final jsonString = json.encode(searches);
    await _prefManager.setString(_keyRecentSearches, jsonString);
  }

  @override
  List<String> getRecentSearches() {
    final jsonString = _prefManager.getString(_keyRecentSearches);
    if (jsonString == null) return [];

    try {
      final List<dynamic> decoded = json.decode(jsonString);
      return decoded.cast<String>();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    await _prefManager.remove(_keyRecentSearches);
  }

  @override
  Future<void> removeRecentSearch(String search) async {
    final currentSearches = getRecentSearches();
    currentSearches.remove(search);
    await saveRecentSearches(currentSearches);
  }
}