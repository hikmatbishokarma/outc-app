import 'package:flutter/material.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/partnerSidemenu/models/getstatementsresponse.dart';
import 'package:outc/widgets/components/printlocal.dart';

class StatementReportsProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<GetStatementsResponse>? _getStatementsResponse;
  ApiResponse<GetStatementsResponse>? get getStatementsResponse =>
      _getStatementsResponse;
  Future<void> loadStatementReportsList({
    bool reload = false,
    String? status,
  }) async {
    // notifyListeners();
    if (_getStatementsResponse == null || reload == true) {
      _getStatementsResponse = ApiResponse.loading();

      // notifyListeners();
      try {
        GetStatementsResponse data =
            await _repositoryData.getStatementReports();
        _getStatementsResponse = ApiResponse.completed(data);
        printL("Statements data recieved");
      } catch (e) {
        printL("loadProfile error $e");
        _getStatementsResponse = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  clearReportsDetails() {
    _getStatementsResponse = null;
    notifyListeners();
  }
}
