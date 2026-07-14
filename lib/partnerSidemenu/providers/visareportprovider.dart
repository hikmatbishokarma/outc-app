import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/visareportmodel.dart';
import 'package:outc/widgets/components/printlocal.dart';

class VisaReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<GetVisaReportsResponse>? _getVisaReportsResponse;
  ApiResponse<GetVisaReportsResponse>? get getVisaReportsResponse =>
      _getVisaReportsResponse;
  Future<void> loadVisaReportsList({
    bool reload = false,
    String? status,
  }) async {
    // notifyListeners();
    if (_getVisaReportsResponse == null || reload == true) {
      _getVisaReportsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetVisaReportsResponse data = await _repositoryData.getVisaReports();
        _getVisaReportsResponse = ApiResponse.completed(data);
        printL("visa data recieved");
      } catch (e) {
        printL("loadProfile error $e");
        _getVisaReportsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getVisaReportsResponse = null;
    notifyListeners();
  }
}
