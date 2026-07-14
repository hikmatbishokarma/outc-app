import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/carreportsmodel.dart';
import 'package:outc/widgets/components/printlocal.dart';

class CarReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<GetCarReportsResponse>? _getCarReportsResponse;
  ApiResponse<GetCarReportsResponse>? get getCarReportsResponse =>
      _getCarReportsResponse;
  Future<void> loadCarReportsList({
    bool reload = false,
    String? status,
  }) async {
    // notifyListeners();
    if (_getCarReportsResponse == null || reload == true) {
      _getCarReportsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetCarReportsResponse data = await _repositoryData.getCarReports();
        _getCarReportsResponse = ApiResponse.completed(data);
        printL("Car data recieved");
      } catch (e) {
        printL("loadProfile error $e");
        _getCarReportsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getCarReportsResponse = null;
    notifyListeners();
  }
}
