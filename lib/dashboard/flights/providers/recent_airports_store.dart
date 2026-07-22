import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';

/// Local-only "recent airport searches" convenience list, persisted via
/// SharedPreferences (the same mechanism already used app-wide for local
/// state). Not part of any backend API — purely a presentation-layer nicety
/// for the airport search screen (specs/0004).
class RecentAirportsStore {
  static const _key = 'recentAirportSearches';
  static const _maxEntries = 5;

  static Future<List<Datum>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? const [];
    return raw
        .map((entry) => Datum.fromJson(jsonDecode(entry) as Map<String, dynamic>))
        .toList();
  }

  static Future<void> addRecent(Datum airport) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getRecent();
    current.removeWhere((d) => d.airportCode == airport.airportCode);
    current.insert(0, airport);
    final trimmed = current.take(_maxEntries).toList();
    await prefs.setStringList(
      _key,
      trimmed.map((d) => jsonEncode(d.toJson())).toList(),
    );
  }
}
