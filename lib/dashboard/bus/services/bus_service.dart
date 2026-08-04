import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:outc/dashboard/bus/models/bus_booking_models.dart';
import 'package:outc/dashboard/bus/models/bus_city_model.dart';
import 'package:outc/dashboard/bus/models/bus_search_models.dart';
import 'package:outc/dashboard/bus/models/bus_seat_model.dart';
import 'package:outc/dashboard/bus/models/bus_ticket_details_model.dart';
import 'package:outc/services/app_constants.dart';
import 'package:outc/widgets/sharedprefservices.dart';

/// The only place in the bus module that talks to the network
/// (`docs/architecture.md` §1/§2). Every endpoint — search through
/// block/book — uses the single `AppConstant.baseUrl`, matching how the
/// flights module does it. A previous version split search onto a separate
/// `busBaseUrl` host; that broke block with "log not found" because the
/// search session/log was created on a host the block call never talked to.
class BusService {
  Future<List<BusCity>> searchCities(String query) async {
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/searchBusCities/$query');
    final response = await http.get(url);
    if (response.statusCode != 200) return [];
    final parsed = BusCitySearchResponse.fromJson(json.decode(response.body));
    return parsed.data;
  }

  Future<BusSearchResponse> searchBuses(BusSearchRequest request) async {
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/availability');
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
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/tripAvailability');
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
    print('blockTicket request ${json.encode(request.toJson())}');
    print('blockTicket response ${response.statusCode} ${response.body}');
    // Confirmed against a live capture: a successful block can come back as
    // either 200 or 201 (the endpoint's own creation-style response code).
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Could not block the ticket (HTTP ${response.statusCode})');
    }
    return BusBlockResponse.fromJson(json.decode(response.body));
  }

  Future<BusBookResponse> bookTicket(String refNo) async {
    // Confirmed by the backend team (2026-08-03): this is a GET, not a POST.
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/bookTicket?refNo=$refNo');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
    );
    print('bookTicket response ${response.statusCode} ${response.body}');
    if (response.statusCode != 200) {
      throw Exception('Could not confirm the booking (HTTP ${response.statusCode})');
    }
    return BusBookResponse.fromJson(json.decode(response.body));
  }

  /// Fetches the full e-ticket for a confirmed booking — used to render/
  /// download/share the ticket after `bookTicket()`, and (later) to re-open
  /// a past booking from a bookings list. Keyed by the same `refNo` as
  /// `bookTicket` (`BusBookData.referenceNo`).
  Future<BusTicketDetailsResponse> getTicketDetails(String refNo) async {
    final url = Uri.parse('${AppConstant.baseUrl}api/v1/buses/ticketDetails?refNo=$refNo');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${SharedPrefServices.getjwtVerifiertoken()}',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Could not load the ticket (HTTP ${response.statusCode})');
    }
    return BusTicketDetailsResponse.fromJson(json.decode(response.body));
  }
}
