import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()

class FLightPriceRequestModel {
  int userId;
  int roleType;
  int membership;
  String traceId;
  List<String> flightIds;
  List<SelectedFlight> selectedFlights;
  String airTravelType;
  String mappingType;
  String itineraryViewType;
  GstDetails gstDetails;

  /// The full originally-selected flight (the exact object the search
  /// results/fare-sheet rendered from — see `FlightDetail.toJson()` in
  /// `flights_list_model.dart`), matching the website's request payload's
  /// `selected` field. Confirmed missing here by capturing a real working
  /// website request and diffing it against what this model sent — the
  /// backend's `airPrice` endpoint has been crashing with "Cannot read
  /// properties of undefined (reading '0')" on every single call this
  /// session, fresh or stale, which matches indexing into a `selected`
  /// array that was never actually in the request body at all.
  /// Nullable/omitted-when-null because only the one-way flow
  /// (`flight_fares_sheet.dart`) threads this through today — round-trip
  /// and multi-city select from a differently-shaped result model that
  /// hasn't been verified against this same contract yet.
  List<Map<String, dynamic>>? selected;

  /// The original search criteria (route, date, passenger mix) echoed back
  /// — also confirmed required by diffing a real *successful* website
  /// request against ours: adding `selected` alone stopped the crash but
  /// still came back with an empty `flightDetails`; adding this is what
  /// actually got a priced result back. Same nullable/one-way-only caveat
  /// as `selected`.
  Map<String, dynamic>? airSearch;

  FLightPriceRequestModel({
    required this.userId,
    required this.roleType,
    required this.membership,
    required this.traceId,
    required this.flightIds,
    required this.selectedFlights,
    required this.airTravelType,
    required this.mappingType,
    required this.itineraryViewType,
    required this.gstDetails,
    this.selected,
    this.airSearch,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'userId': userId,
      'roleType': roleType,
      'membership': membership,
      'traceId': traceId,
      'flightIds': flightIds,
      'selectedFlights': selectedFlights.map((flight) => flight.toJson()).toList(),
      if (airSearch != null) 'airSearch': airSearch,
      if (selected != null) 'selected': selected,
      'airTravelType': airTravelType,
      'mappingType': mappingType,
      'itineraryViewType': itineraryViewType,
      'gstDetails': gstDetails.toJson(),
    };
  }
}

class SelectedFlight {
  String fareId;
  String flightId;
  String coupanType;
  String fareType;
  String subCabinClass;

  SelectedFlight({
    required this.fareId,
    required this.flightId,
    required this.coupanType,
    required this.fareType,
    required this.subCabinClass,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'fareId': fareId,
      'flightId': flightId,
      'coupanType': coupanType,
      'fareType': fareType,
      'subCabinClass': subCabinClass,
    };
  }
}

class GstDetails {
  String gstAddressLine1;
  String gstAddressLine2;
  String gstCity;
  String gstState;
  String gstpinCode;
  String gstEmailId;
  String gstNumber;
  String gstPhoneNo;
  String gstCompanyName;

  GstDetails({
    required this.gstAddressLine1,
    required this.gstAddressLine2,
    required this.gstCity,
    required this.gstState,
    required this.gstpinCode,
    required this.gstEmailId,
    required this.gstNumber,
    required this.gstPhoneNo,
    required this.gstCompanyName,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'gstAddressLine1': gstAddressLine1,
      'gstAddressLine2': gstAddressLine2,
      'gstCity': gstCity,
      'gstState': gstState,
      'gstpinCode': gstpinCode,
      'gstEmailId': gstEmailId,
      'gstNumber': gstNumber,
      'gstPhoneNo': gstPhoneNo,
      'gstCompanyName': gstCompanyName,
    };
  }
}

// flight price model again push // 


















// {
//     "userId": 1,
//     "roleType": 4,
//     "membership": 1,
//     "traceId": "sdd",
//     "flightIds": [
//         "sdsdd"
//     ],
//     "selectedFlights": [
//         {
//             "fareId": "sxsxs",
//             "flightId": "dsdsds",
//             "coupanType": "Publish",
//             "fareType": "SAVER",
//             "subCabinClass": "R"
//         }
//     ],
//     "airTravelType": "oneWay",
//     "mappingType": "COMBINED",
//     "itineraryViewType": "1",
//     "gstDetails": {
//         "gstAddressLine1": "",
//         "gstAddressLine2": "",
//         "gstCity": "",
//         "gstState": "",
//         "gstpinCode": "",
//         "gstEmailId": "",
//         "gstNumber": "",
//         "gstPhoneNo": "",
//         "gstCompanyName": ""
//     }
// }