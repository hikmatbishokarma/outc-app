import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/hotelreportsmodel.dart';
import 'package:outc/widgets/components/printlocal.dart';

class ReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();
  TextEditingController searchController = TextEditingController();

  ApiResponse<GetHotelReportsResponse>? _getHotelReportsResponse;
  ApiResponse<GetHotelReportsResponse>? get getHotelReportsResponse =>
      _getHotelReportsResponse;
  Future<void> loadHotelReportsList({
    bool reload = false,
    String? status,
  }) async {
    // _getHotelReportsResponse = null;
    // notifyListeners();
    if (_getHotelReportsResponse == null || reload == true) {
      _getHotelReportsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetHotelReportsResponse data = await _repositoryData.getHotelsReports();
        _getHotelReportsResponse = ApiResponse.completed(data);
        printL("customerID data udaytejaaaaa");
        // reload = false;
        // notifyListeners();
      } catch (e) {
        printL("loadProfile error $e");
        _getHotelReportsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getHotelReportsResponse = null;
    notifyListeners();
  }
}
