import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/getdepositsresponse.dart';
import 'package:outc/widgets/components/printlocal.dart';

class DepositReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<GetDepositsResponse>? _getDepositsResponse;
  ApiResponse<GetDepositsResponse>? get getDepositsResponse =>
      _getDepositsResponse;
  Future<void> loadDepositReportsList({
    bool reload = false,
    String? status,
  }) async {
    // notifyListeners();
    if (_getDepositsResponse == null || reload == true) {
      _getDepositsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetDepositsResponse data = await _repositoryData.getDepositReports();
        _getDepositsResponse = ApiResponse.completed(data);
        printL("Deposits data recieved");
      } catch (e) {
        printL("loadProfile error $e");
        _getDepositsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getDepositsResponse = null;
    notifyListeners();
  }
}
