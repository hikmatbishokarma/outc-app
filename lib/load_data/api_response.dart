import 'package:flutter/cupertino.dart';
import 'package:outc/widgets/progress_bar.dart';

class ApiResponse<T> {
  Status status;

  T? data;
  late String errorMessage;
  late Widget? loadingWidget = const ProgressBarHUD();

  ApiResponse.loading({this.loadingWidget}) : status = Status.loading;

  ApiResponse.completed(this.data) : status = Status.completed;

  ApiResponse.error(this.errorMessage) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $errorMessage \n Data : $data";
  }
}

enum Status { loading, completed, error }
