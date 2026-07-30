import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:outc/dashboard/bus/models/bus_booking_models.dart';
import 'package:outc/dashboard/bus/models/bus_city_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/services/app_constants.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// The only place in the bus module that talks to the network
/// (`docs/architecture.md` §1/§2). Search/seat-availability live on
/// `AppConstant.busBaseUrl` (`outc.in`); block/book live on
/// `AppConstant.baseUrl` (`b2c.outc.in`), the host every other module's
/// booking endpoints use — confirmed against a live capture of both calls.
class BusService {
  Future<List<BusCity>> searchCities(String query) async {
    final url = Uri.parse('${AppConstant.busBaseUrl}api/v1/buses/searchBusCities/$query');
    final response = await http.get(url);
    if (response.statusCode != 200) return [];
    final parsed = BusCitySearchResponse.fromJson(json.decode(response.body));
    return parsed.data;
  }

  Future<BusSearchResponse> searchBuses(BusSearchRequest request) async {
    final url = Uri.parse('${AppConstant.busBaseUrl}api/v1/buses/availability/price');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
      body: json.encode(request.toJson()),
    );
    return BusSearchResponse.fromJson(json.decode(response.body));
  }

  Future<BusSeatAvailabilityResponse> getTripAvailability({
    required String searchId,
    required String tripId,
  }) async {
    final url = Uri.parse('${AppConstant.busBaseUrl}api/v1/buses/tripAvailability');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
      body: json.encode({
        'searchId': searchId,
        'tripId': tripId,
        'userId': 1,
        'roleType': 4,
        'membership': 1,
      }),
    );
    return BusSeatAvailabilityResponse.fromJson(json.decode(response.body));
  }

  /// `blockTicket`/`bookTicket` live on `AppConstant.baseUrl` (`b2c.outc.in`)
  /// — the host every other module's booking endpoints use — unlike
  /// `searchBuses`/`getTripAvailability` above, which are on the bus-specific
  /// `busBaseUrl` (`outc.in`).
  Future<BusBlockResponse> blockTicket(BusBlockRequest request) async {
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/blockTicket');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
      body: json.encode(request.toJson()),
    );
    // Confirmed against a live capture: a successful block can come back as
    // either 200 or 201 (the endpoint's own creation-style response code).
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not block the ticket (HTTP ${response.statusCode})');
    }
    return BusBlockResponse.fromJson(json.decode(response.body));
  }

  Future<BusBookResponse> bookTicket(String refNo) async {
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/bookTicket?refNo=$refNo');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Could not confirm the booking (HTTP ${response.statusCode})');
    }
    return BusBookResponse.fromJson(json.decode(response.body));
  }
}
