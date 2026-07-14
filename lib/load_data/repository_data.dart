import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/dashboard/flights/models/top_cities_model.dart';
import 'package:outc/load_data/api_paths.dart';
import 'package:outc/load_data/http_client.dart';
import 'package:outc/partnerSidemenu/models/carreportsmodel.dart';
import 'package:outc/partnerSidemenu/models/flightreportsmodel.dart';
import 'package:outc/partnerSidemenu/models/getdepositsresponse.dart';
import 'package:outc/partnerSidemenu/models/getstatementsresponse.dart';
import 'package:outc/partnerSidemenu/models/hotelreportsmodel.dart';
import 'package:outc/partnerSidemenu/models/visareportmodel.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class RepositoryData {
  Future<TopCities> getTopCities() async {
    final response = await HttpClient.instance
        .get(APIPathHelper.getValue(APIPath.getTopCities));
    return topCitiesFromJson(response);
  }

  Future<CitiesbySearch> getCitiesBySearch(String? cityCode) async {
    final response = await HttpClient.instance
        .get("${APIPathHelper.getValue(APIPath.getCitiesBySearch)}/$cityCode");
    return citiesbySearchFromJson(response);
  }

  Future<GetHotelReportsResponse> getHotelsReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String reportstatus = SharedPrefServices.gethotelstatus().toString();
    String bookingtypesstatus =
        SharedPrefServices.gethotelbookingtype().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/admin/myBookings?options=5&referenceNo=&bookingStatus=$reportstatus&BookingType=$bookingtypesstatus&fromDate=$fromDate&toDate=$toDate&userId=$custId&travelType=2");
    return getHotelReportsResponseFromJson(response);
  }

  Future<GetFlightReportsResponse> getFlightsReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String reportstatus = SharedPrefServices.gethotelstatus().toString();
    String bookingtypesstatus =
        SharedPrefServices.gethotelbookingtype().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/admin/myBookings?options=5&referenceNo=&bookingStatus=$reportstatus&BookingType=$bookingtypesstatus&fromDate=$fromDate&toDate=$toDate&userId=$custId&travelType=1");
    return getFlightReportsResponseFromJson(response);
  }

  Future<GetVisaReportsResponse> getVisaReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String reportstatus = SharedPrefServices.gethotelstatus().toString();
    String bookingtypesstatus =
        SharedPrefServices.gethotelbookingtype().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/visa/getVisaBookignReportsByFilter?options=4&referenceNo=&bookingStatus=$reportstatus&BookingType=$bookingtypesstatus&fromDate=$fromDate&toDate=$toDate&userId=$custId&travelType=3");
    return getVisaReportsResponseFromJson(response);
  }
  // car reports provider

  Future<GetCarReportsResponse> getCarReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String reportstatus = SharedPrefServices.gethotelstatus().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/carextranet/carBookingReportsByFilter?options=5&referenceNo=&bookingStatus=$reportstatus&fromDate=$fromDate&toDate=$toDate&userId=$custId&travelType=6");
    return getCarReportsResponseFromJson(response);
  }
  // DEPOSITS reports provider

  Future<GetDepositsResponse> getDepositReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String reportstatus = SharedPrefServices.gethotelstatus().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/admin/agentdepositrequest?options=5&Status=$reportstatus&fromDate=$fromDate&toDate=$toDate&UserId=$custId");
    return getDepositsResponseFromJson(response);
  }

  // Statements reports provider

  Future<GetStatementsResponse> getStatementReports() async {
    String custId = SharedPrefServices.getcustomerId().toString();

    String fromDate = SharedPrefServices.getfromdate().toString();
    String toDate = SharedPrefServices.gettodate().toString();

    final response = await HttpClient.instance.get(
        "api/v1/agentbalancelog/getagentbalancelogrecords?options=5&fromDate=$fromDate&toDate=$toDate&UserId=$custId");
    return getStatementsResponseFromJson(response);
  }

  // oneWay Flight List

  Future<FlightsList> oneWayFlightList({var data}) async {
    String url = "api/v1/flights/airSearch";

    final response = await HttpClient.instance.post(url, data);
    return flightsListFromJson(response);
  }
}
