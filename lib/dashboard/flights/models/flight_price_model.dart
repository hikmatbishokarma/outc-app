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
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'userId': userId,
      'roleType': roleType,
      'membership': membership,
      'traceId': traceId,
      'flightIds': flightIds,
      'selectedFlights': selectedFlights.map((flight) => flight.toJson()).toList(),
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