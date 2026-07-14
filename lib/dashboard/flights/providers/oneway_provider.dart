import 'package:flutter/material.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/services/app_constants.dart';

import 'package:http/http.dart' as http;

// FlightsList flightsListFromJson
// class OnewayFlightlistProvider extends ChangeNotifier {

//   Future<void> loadOnewayFlightList(
//       {bool reload = false, String? status, var data}) async {
//     // notifyListeners();
//     if (_getFlightsList == null || reload == true) {
//       _getFlightsList = ApiResponse.loading();
//       var newData = data;
//       // notifyListeners();
//       try {
//         FlightsList data =
//             await _repositoryData.oneWayFlightList(data: newData);
//         _getFlightsList = ApiResponse.completed(data);
//         printL("oneWay flight data recieved");
//       } catch (e) {
//         printL("oneWay flight error $e");
//         _getFlightsList = ApiResponse.error(e.toString());
//         notifyListeners();
//       }
//       notifyListeners();
//     }
//   }

//   clearFlightListDetails() {
//     _getFlightsList = null;
//     notifyListeners();
//   }
// }

class OnewayProvider with ChangeNotifier {
  // Step 2: Implement the POST method
  // final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<FlightsList>? _getFlightsList;
  ApiResponse<FlightsList>? get getFlightsList => _getFlightsList;
  Future<void> postData(var data) async {
    String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airSearch";
    try {
      final response = await http.post(
        Uri.parse(url),
        body: data,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Do something with the response if needed
        print('Data posted successfully');
      } else {
        throw Exception('Failed to post data');
      }
    } catch (error) {
      // Handle errors
      print('Error posting data: $error');
    }
  }
}


//  Future<FlightsList> matchingFlightsList(var data) async {
//     String url = "${AppConstant.baseUrlanjmal}api/v1/flights/airSearch";
//     // var customerID = SharedPrefServices.getprofileID().toString();
//     // var body = data;
//     // body["customer"] = customerID;
//     try {
//       final response = await http.post(
//         Uri.parse(url),
//         body: data,
//         headers: {"Content-Type": "application/json"},
//       );
//       print(url);
//       if (response.statusCode == 200) {
//         return flightsListFromJson(response.body);
//       } else if (response.statusCode == 201) {
//         return flightsListFromJson(response.body);
//       } else if (response.statusCode == 500) {
//         // throw Exception('incorrect data');
//         return flightsListFromJson("exception");
//       } else
//         print(response.statusCode);
//     } catch (e) {
//       print(e.toString());
//     }
//     return flightsListFromJson("exception");

//     // throw Exception('Failed to load Data');
//   }