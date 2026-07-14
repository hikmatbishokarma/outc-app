import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/flightreportsmodel.dart';
import 'package:outc/widgets/components/printlocal.dart';

class FlightReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<GetFlightReportsResponse>? _getFlightReportsResponse;
  ApiResponse<GetFlightReportsResponse>? get getFlightReportsResponse =>
      _getFlightReportsResponse;
  Future<void> loadFlightReportsList({
    bool reload = false,
    String? status,
  }) async {
    // _getHotelReportsResponse = null;
    // notifyListeners();
    if (_getFlightReportsResponse == null || reload == true) {
      _getFlightReportsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetFlightReportsResponse data =
            await _repositoryData.getFlightsReports();
        _getFlightReportsResponse = ApiResponse.completed(data);
        printL("customerID data udaytejaaaaa");
        // reload = false;
        // notifyListeners();
      } catch (e) {
        printL("loadProfile error $e");
        _getFlightReportsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getFlightReportsResponse = null;
    notifyListeners();
  }
}
