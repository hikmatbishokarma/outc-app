import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:outc/dashboard/flights/models/flight_domestic_roundtrip_model.dart';
import 'package:outc/dashboard/flights/models/flight_price_model.dart';
import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/dashboard/flights/models/flightbalaji.dart';
import 'package:outc/dashboard/flights/models/flightranjith.dart';
import 'package:outc/dashboard/flights/models/flights_price_response.dart';
import 'package:outc/dashboard/flights/models/one_way_book_response.dart';
import 'package:outc/dashboard/hotels/models/hotels_list_model.dart';
import 'package:outc/dashboard/hotels/models/selected_hotel_response_model.dart';
import 'package:outc/loginflow/model/flight_oneway_book_response_model.dart';
import 'package:outc/loginflow/model/login_request_model.dart';
import 'package:outc/loginflow/model/login_response_model.dart';
import 'package:outc/loginflow/model/partner_response_model.dart';
import 'package:outc/partnerSidemenu/models/password_update_model.dart';
import 'package:outc/partnerSidemenu/models/updatepasswordmodel.dart';
import 'package:outc/services/app_constants.dart';

import '../dashboard/flights/models/flights_list_model.dart';
import '../dashboard/flights/models/get_cities_by_search_model.dart';

class APIService {
  // String BaseUrl = http://54.82.168.211:8000/;

// this is for jwttoken "Content-Type": "application/json"
  // Map<String, String> jwtheaders = {
  //   'Authorization': SharedPrefServices.getjwtVerifiertoken().toString(),
  // };

  // Map<String, String> jwtforputheaders = {
  //   "Content-Type": "application/json",
  //   'Authorization': SharedPrefServices.getjwtVerifiertoken().toString(),
  // };

  Map<String, String> justcontentheaders = {
    "Content-Type": "application/json",
    "accept": 'application/json'
  };

  Map<String, String> airBlockheaders = {
    "Content-Type": "application/json",
  };

  // Customer Login
  Future<Loginauth> loginauth(Loginrequestauth requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/admin/mobileLogin";
    print(url);
    // int role = 2;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestModel.toJson(),
      );

      print("response.body requestModel ${requestModel.toJson()}");
      print("response.body signin ${response.body}");
      print("response.body statusCode ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return loginauthFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return loginauthFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return loginauthFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return loginauthFromJson(response.body);
      } else
        return loginauthFromJson(response.body);
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    print(requestModel);
    inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  // Partner Login
  Future<PartnerResponsemodel> partnerLoginauth(
      Loginrequestauth requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/admin/mobileLogin";
    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestModel.toJson(),
      );

      print("response.body requestModel ${requestModel.toJson()}");
      print("response.body signin ${response.body}");
      print("response.body statusCode ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return partnerResponsemodelFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return partnerResponsemodelFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return partnerResponsemodelFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return partnerResponsemodelFromJson(response.body);
      } else {
        return partnerResponsemodelFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    print(requestModel);
    inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  Future<CitiesbySearch> getCitiesbySearch(String zip) async {
    String url =
        "${AppConstant.baseUrl}api/v1/flights/updatedAirPort/search/$zip";
    // print("url for zipcode $url");
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("now i get 200 in api servicesSdsdsd");
      return CitiesbySearch.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return citiesbySearchFromJson("exception");
    }

    {
      // print("url for zipcode $url");

      throw Exception('Failed to load post');
    }
  }

  Future<FlightsList> matchingFlightsList(var data) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airSearch";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      print("triggered service");
      print(response.statusCode);
      inspect(response.body);

      if (response.statusCode == 200) {
        return flightsListFromJson(response.body);
      } else if (response.statusCode == 201) {
        return flightsListFromJson(response.body);
      } else if (response.statusCode == 500) {
        // throw Exception('incorrect data');
        return flightsListFromJson("exception");
      } else
        print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    return flightsListFromJson("exception");

    // throw Exception('Failed to load Data');
  }

  Future<FlightRoundtripModel> matchingFlightRoundtripList(var data) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airSearch";
    // var customerID = SharedPrefServices.getprofileID().toString();
    // var body = data;
    // body["customer"] = customerID;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      if (response.statusCode == 200) {
        return flightRoundtripModelFromJson(response.body);
      } else if (response.statusCode == 201) {
        return flightRoundtripModelFromJson(response.body);
      } else if (response.statusCode == 500) {
        // throw Exception('incorrect data');
        return flightRoundtripModelFromJson("exception");
      } else
        print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    return flightRoundtripModelFromJson("exception");

    // throw Exception('Failed to load Data');
  }

  // domestic roundtrip flight
  Future<FlightDomesticRoundtripModel> matchingDomesticFlightRoundtripList(
      var data) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airSearch";
    // var customerID = SharedPrefServices.getprofileID().toString();
    // var body = data;
    // body["customer"] = customerID;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      if (response.statusCode == 200) {
        return flightDomesticRoundtripModelFromJson(response.body);
      } else if (response.statusCode == 201) {
        return flightDomesticRoundtripModelFromJson(response.body);
      } else if (response.statusCode == 500) {
        // throw Exception('incorrect data');
        return flightDomesticRoundtripModelFromJson("exception");
      } else
        print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    return flightDomesticRoundtripModelFromJson("exception");

    // throw Exception('Failed to load Data');
  }
  // Flight Block Post

  // Future<FlightsblockResponse> flightBlock(
  //     String traceId,
  //     int userId,
  //     int roleType,
  //     int membership,
  //     List<Passenger> passengers,
  //     List<String> additionalServices, // Updated data type to List<String>

  //     String creditCardInfo,
  //     int insuranceRequired,
  //     String promoCode,
  //     String currency,
  //     int convienenceId,
  //     int pgType,
  //     var totalPrice,
  //     bool isCouponReedem

  //     // FlightFormModel flightFormModel,
  //     ) async {
  //   String url = "http://anjmal.i2space.in/api/v1/flights/airBlock";
  //   print(url);
  //   // print("response.body FlightBlockrequestModel ${flightFormModel.toJson()}");

  //   Map jsonBody = {
  //     'traceId': traceId.toString(),
  //     'userId': userId.toInt(),
  //     'roleType': roleType.toInt(),
  //     'membership': membership.toInt(),
  //     'passengers': passengers.map((passenger) => passenger.toJson()).toList(),
  //     'additional_services': additionalServices.toList(),
  //     'creditCardInfo': creditCardInfo.toString(),
  //     'insuranceRequired': insuranceRequired.toInt(),
  //     'promoCode': promoCode.toString(),
  //     'currency': currency.toString(),
  //     'convienenceId': convienenceId.toInt(),
  //     'pgType': pgType.toInt(),
  //     'totalPrice': totalPrice,
  //     'isCouponReedem': isCouponReedem,
  //   };
  //   try {
  //     final response = await http.post(Uri.parse(url),
  //         body: jsonEncode(jsonBody), headers: airBlockheaders);

  //     print("response.body FlightBlockrequestPOST ${response.body}");
  //     print("response.body statusCode ${response.statusCode}");

  //     if (response.statusCode == 200 ||
  //         response.statusCode == 201 ||
  //         response.statusCode == 203 ||
  //         response.statusCode == 400 ||
  //         response.statusCode == 401) {
  //       return flightsblockResponseFromJson(response.body);
  //     }
  //   } catch (e) {
  //     print(e.toString());
  //   }

  //   throw Exception('Failed to load Data');
  // }

// Hotels List
  Future<HotelsList> matchingHotelsList(var data) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/hotels-v2/hotelsearch";

    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {"Content-Type": "application/json"},
      );
      print(url);
      print(response.body);
      if (response.statusCode == 200 ||
          response.statusCode == 201 ||
          response.statusCode == 203 ||
          response.statusCode == 400 ||
          response.statusCode == 404 ||
          response.statusCode == 500 ||
          response.statusCode == 401) {
        return hotelsListFromJson(response.body);
      }
      // if (response.statusCode == 200 || response.statusCode == 201) {
      //   return hotelsListFromJson(response.body);
      // } else
      // l
      //   print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    return hotelsListFromJson("exception");

    // throw Exception('Failed to load Data');
  }

  Future<SelectedHotelView> selectedHotel(
      String traceId, String hotelCode, String supplier) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/hotels-v2/hotelrooms";
    Map<String, String> viewHotelheaders = {
      "Content-Type": "application/json",
    };
    Map jsonBody = {
      "traceId": traceId,
      "hotelCode": hotelCode,
      "userId": 1,
      "roleType": 4,
      "membership": 1,
      "supplier": supplier
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(jsonBody),
        headers: viewHotelheaders,
      );
      print(url);
      print(jsonBody);
      inspect(jsonBody);
      print(response.statusCode);

      print(response.body);

      if (response.statusCode == 200) {
        return selectedHotelViewFromJson(response.body);
      } else if (response.statusCode == 201) {
        return selectedHotelViewFromJson(response.body);
      } else if (response.statusCode == 500) {
        // throw Exception('incorrect data');
        return selectedHotelViewFromJson("exception");
      } else if (response.statusCode == 404) {
        return selectedHotelViewFromJson(response.body);
      } else
        print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    return selectedHotelViewFromJson("exception");

    // throw Exception('Failed to load Data');
  }

  // Update Partner Password
  Future<UpdatePartnerPasswordResponse> updatePartnerPassword(
      Passwordupdaterequestmodel requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/admin/changePassword";
    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        body: requestModel.toJson(),
      );

      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return updatePartnerPasswordResponseFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return updatePartnerPasswordResponseFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return updatePartnerPasswordResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return updatePartnerPasswordResponseFromJson(response.body);
      } else {
        return updatePartnerPasswordResponseFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    print(requestModel);
    inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  // flight Price one way before block
  Future<PriceBookResponse> flightOnewayPrice(
      FLightPriceRequestModel requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airPrice";
    print(url);
    var payloadData = json.encode(requestModel.toJson());
    try {
      final response = await http.post(
        Uri.parse(url),
        body: payloadData,
        headers: {"Content-Type": "application/json"},
      );

      print(
          "response.body flightPrice oneway & roundtrip ${requestModel.toJson()}");
      print("response.body flightPrice  oneway & roundtrip ${response.body}");
      print(
          "response.body statusCode  oneway & roundtrip ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return priceBookResponseFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return priceBookResponseFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return priceBookResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return priceBookResponseFromJson(response.body);
      } else {
        return priceBookResponseFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    print(requestModel);
    inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  //flight one way block
  Future<FlightOnewayBlock> flightOnewayBlock(
      FlightFormRequestModel requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airBlock";
    print(url);
    var payloadData = json.encode(requestModel.toJson());
    try {
      final response = await http.post(
        Uri.parse(url),
        body: payloadData,
        headers: {"Content-Type": "application/json"},
      );

      print("response.body requestModel ${requestModel.toJson()}");
      print("response.body signin ${response.body}");
      print("response.body statusCode ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else {
        return flightOnewayBlockFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    // print(requestModel);
    // inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  //flight round trip block
  Future<FlightOnewayBlock> flightRoundTripBlock(
      FlightFormRequestModelRoundTrip requestModel) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airBlock";
    print(url);
    var payloadData = json.encode(requestModel.toJson());
    try {
      final response = await http.post(
        Uri.parse(url),
        body: payloadData,
        headers: {"Content-Type": "application/json"},
      );

      print("response.body requestModel ${requestModel.toJson()}");
      print("response.body signin ${response.body}");
      print("response.body statusCode ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return flightOnewayBlockFromJson(response.body);
      } else {
        return flightOnewayBlockFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    // print(requestModel);
    // inspect(requestModel);

    throw Exception('Failed to load Data');
  }

  // flight one way Book
  Future<FlightOnewayBookResponse> flightOnewayBook(String refNumber) async {
    String url =
        "${AppConstant.baseUrlanjmal}api/v1/flights/airBook/$refNumber";
    print(url);

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
      );

      print("response.body flight book ${response.body}");
      print("response.body statusCode ${response.statusCode}");
      // inspect(requestModel.toJson());
      if (response.statusCode == 200) {
        return flightOnewayBookResponseFromJson(response.body);
      } else if (response.statusCode == 203) {
        // throw Exception('incorrect data');
        return flightOnewayBookResponseFromJson(response.body);
      } else if (response.statusCode == 201) {
        // throw Exception('incorrect data');
        return flightOnewayBookResponseFromJson(response.body);
      } else if (response.statusCode == 401) {
        // throw Exception('incorrect data');
        return flightOnewayBookResponseFromJson(response.body);
      } else {
        return flightOnewayBookResponseFromJson(response.body);
      }
      // print(response.statusCode);
    } catch (e) {
      print(e.toString());
    }
    // return userloginfailureresponseFromJson(response.body);

    throw Exception('Failed to load Data');
  }
}
