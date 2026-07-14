enum APIPath { getTopCities, getCitiesBySearch }

class APIPathHelper {
  static String getValue(APIPath path) {
    switch (path) {
      case APIPath.getTopCities:
        return "api/v1/admin/getAllServicesTopCities";
      case APIPath.getCitiesBySearch:
        return "api/v1/flights/updatedAirPort/search";

      default:
        return "";
    }
  }
}
