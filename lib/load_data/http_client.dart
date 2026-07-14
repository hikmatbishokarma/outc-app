import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:http/http.dart' as http;
import 'package:outc/load_data/exceptions.dart';
import 'package:outc/services/app_constants.dart';
import 'package:outc/widgets/components/printlocal.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class HttpClient {
  static final HttpClient _singleton = HttpClient();

  static HttpClient get instance => _singleton;

  Future<dynamic> post(String path, Map<String, dynamic> body,
      {String? tenantId, bool isLoad = true}) async {
    var baseUrl = AppConstant.baseUrlanjmal + path;

    dynamic responseJson;
    var header = {
      "Content-Type": "application/json",
      'Authorization': SharedPrefServices.getjwtVerifiertoken().toString(),
    };

    try {
      if (!isLoad) BotToast.showLoading();
      printL("url:- $baseUrl");
      printL("header:- $header");
      var data = json.encode(body);
      printL("body:- $data");
      final response =
          await http.post(Uri.parse(baseUrl), headers: header, body: data);
      printL("response.body.toString()");
      printL(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      responseJson = _returnResponse(null);
      throw FetchDataException("No Internet connection ");
    }
    return responseJson;
  }

  Future<dynamic> put(String url, Map<String, dynamic> body) async {
    dynamic responseJson;
    var header = {
      "accept": " application/json",
      "X-CSRF-TOKEN": "",
    };

    try {
      BotToast.showLoading();
      var uri = AppConstant.baseUrl + url;
      final response =
          await http.put(Uri.parse(uri), headers: header, body: body);
      printL("response body");
      printL(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(" No Internet connection ");
    }
    return responseJson;
  }

  Future<dynamic> get(String path, {Map<String, String>? params}) async {
    var baseUrl = AppConstant.baseUrl + path;
    dynamic responseJson;

    // var header = {
    //   // "Content-Type": "application/json",
    //   'Authorization': SharedPrefServices.getjwtVerifiertoken().toString(),
    // };
    printL("baseUrl:- $baseUrl");
    // printL("header:- $header");
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
      );
      //  headers: header);
      printL(response.body.toString());
      printL("response.statusCode.toString()");
      printL(response.statusCode.toString());

      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(" No Internet connection ");
    }
    return responseJson;
  }

  Future<dynamic> delete(String url) async {
    dynamic responseJson;
    printL("token:-");

    var header = {
      "accept": " application/json",
      "X-CSRF-TOKEN": "",
    };

    try {
      BotToast.showLoading();
      var uri = AppConstant.baseUrl + url;
      final response = await http.delete(Uri.parse(uri), headers: header);
      printL("response.body.toString()");
      printL(response.body.toString());
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException(" No Internet connection ");
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response? response) {
    BotToast.cleanAll();
    printL(
        "---------------------------------response.statusCode---------------------------------");
    printL("${response?.statusCode.toString()}");

    switch (response?.statusCode) {
      case 200:
        return response?.body.toString();
      case 400:
        return response?.body.toString();

      case 404:
        return response?.body;

      case 401:
        throw UnauthorisedException(response?.body.toString());
      case 422:
        throw UnauthorisedException(response?.body.toString());
      case 403:
        throw UnauthorisedException(response?.body.toString());
      case 500:
        showToast("some error 500");
        return response?.body.toString();

      default:
        showToast("some error ${response?.statusCode}");
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response?.statusCode}');
    }
  }

  String queryParameters(Map<String, String>? params) {
    if (params != null) {
      final jsonString = Uri(queryParameters: params);
      return '?${jsonString.query}';
    }
    return '';
  }
}
