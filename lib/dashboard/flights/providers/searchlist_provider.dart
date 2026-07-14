import 'package:flutter/material.dart';
import 'package:outc/dashboard/flights/models/dropdownlist.dart';
import 'package:outc/dashboard/flights/models/top_cities_model.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/load_data/repository_data.dart';
import 'package:outc/widgets/components/printlocal.dart';

class SplashIntroProvider extends ChangeNotifier {
  final RepositoryData _repositoryData = RepositoryData();

  ApiResponse<TopCities>? _getTopCities;

  ApiResponse<TopCities>? get getCategories => _getTopCities;

  /// load Categories
  Future<void> loadTopCities({bool reload = false}) async {
    if (_getTopCities == null || reload == true) {
      _getTopCities = ApiResponse.loading();
      try {
        TopCities data = await _repositoryData.getTopCities();
        _getTopCities = ApiResponse.completed(data);
      } catch (e, stacktrace) {
        printL("getCategories error $e");
        printL("getCategories stacktrace $stacktrace");
        _getTopCities = ApiResponse.error(e.toString());
        notifyListeners();
      }
      notifyListeners();
    }
  }

  // ApiResponse<GetSubCategories>? _getSubCategories;

  // ApiResponse<GetSubCategories>? get getSubCategories => _getSubCategories;

  // /// load Sub Categories
  // Future<void> loadSubCategories({bool reload = false}) async {
  //   if (_getSubCategories == null || reload == true) {
  //     _getSubCategories = ApiResponse.loading();
  //     try {
  //       GetSubCategories data = await _repositoryData.getSubCategories();
  //       _getSubCategories = ApiResponse.completed(data);
  //     } catch (e, stacktrace) {
  //       printL("getSubCategories error $e");
  //       printL("getSubCategories stacktrace $stacktrace");
  //       _getSubCategories = ApiResponse.error(e.toString());
  //       notifyListeners();
  //     }
  //     notifyListeners();
  //   }
  // }

  // Future<List<Mergedcatlist>> getCatSuggestions(String query) async {
  //   var topCities = _getTopCities?.data?.data ?? [];
  //   // var subCategories = _getSubCategories?.data?.data ?? [];
  //   List<Mergedcatlist> mergedList = [];
  //   if (topCities.isNotEmpty) {
  //     List<dynamic> combinedlist = [];
  //     for (var f in topCities) {

  //        combinedlist.add({
  //             "AirportCode":
  //                 '${f.categoryName ?? ""}-${s.subcategoryName ?? ""}',
  //             "City": f.catCode ?? "",
  //             "Country": s.subcatCode ?? "",
  //             'CountryCode': f.categoryName ?? "",
  //             'AirportDesc': s.subcategoryName ?? "",
  //             "Type": f.id ?? "",
  //             "displayName": s.id ?? "",
  //             "price": s.price ?? "",
  //             "loadStandardQuestion": s.loadStandardQuestion ?? false
  //           });
  //     }
  //     return combinedlist
  //         .map((json) => Mergedcatlist.fromJson(json))
  //         .where((category) {
  //       final nameLower = category.categoryName?.toLowerCase() ?? "";

  //       final queryLower = query.toLowerCase();

  //       return nameLower.contains(queryLower);
  //     }).toList();
  //   } else {
  //     await loadCategories();
  //     await loadSubCategories();
  //   }
  //   return mergedList;
  // }
}
