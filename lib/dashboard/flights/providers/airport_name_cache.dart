import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/services/api_services_list.dart';

/// The flight-search response (`FlightDetail`) doesn't carry city/airport
/// names — only IATA codes (confirmed live: `originCity`/`originName`/
/// `destinationCity`/`destiantionName` all came back empty for a real
/// search, only `origin`/`destination` codes and segment times were
/// populated). This resolves a code to its full city + airport name by
/// reusing the same `getCitiesbySearch` endpoint the airport-picker screen
/// (spec 0004) already calls — not a new endpoint, just applying an
/// existing one to a new spot — with an in-memory cache so the same code
/// (e.g. every "BLR" across a whole results list) is only looked up once
/// per app session.
class AirportNameCache {
  AirportNameCache._();

  static final Map<String, Datum?> _cache = {};
  static final APIService _service = APIService();

  /// Returns null if the code has no match or the lookup fails — callers
  /// fall back to showing the bare code, same as before this existed.
  static Future<Datum?> resolve(String? code) async {
    final normalized = code?.trim().toUpperCase();
    if (normalized == null || normalized.isEmpty) return null;
    if (_cache.containsKey(normalized)) return _cache[normalized];

    try {
      final response = await _service.getCitiesbySearch(normalized);
      final matches = response.data ?? const [];
      final exact = matches.where((d) => d.airportCode?.toUpperCase() == normalized);
      final result = exact.isNotEmpty ? exact.first : (matches.isNotEmpty ? matches.first : null);
      _cache[normalized] = result;
      return result;
    } catch (e) {
      _cache[normalized] = null;
      return null;
    }
  }
}
