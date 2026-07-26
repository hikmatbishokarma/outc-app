class BusCity {
  final String cityId;
  final String name;
  final String cityName;
  final String fullName;
  final String countryCode;
  final String country;
  final String state;
  final String type;

  BusCity({
    required this.cityId,
    required this.name,
    required this.cityName,
    required this.fullName,
    required this.countryCode,
    required this.country,
    required this.state,
    required this.type,
  });

  factory BusCity.fromJson(Map<String, dynamic> json) => BusCity(
        cityId: json['cityId']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        cityName: json['cityName']?.toString() ?? '',
        fullName: json['fullName']?.toString() ?? '',
        countryCode: json['countryCode']?.toString() ?? '',
        country: json['country']?.toString() ?? '',
        state: json['state']?.toString() ?? '',
        type: json['type']?.toString() ?? '',
      );

  Map<String, dynamic> toJson() => {
        'cityId': cityId,
        'name': name,
        'cityName': cityName,
        'fullName': fullName,
        'countryCode': countryCode,
        'country': country,
        'state': state,
        'type': type,
      };
}

class BusCitySearchResponse {
  final int? status;
  final String? message;
  final List<BusCity> data;

  BusCitySearchResponse({this.status, this.message, this.data = const []});

  factory BusCitySearchResponse.fromJson(Map<String, dynamic> json) => BusCitySearchResponse(
        status: json['status'] is int ? json['status'] as int : int.tryParse(json['status']?.toString() ?? ''),
        message: json['message']?.toString(),
        data: json['data'] == null
            ? []
            : List<BusCity>.from((json['data'] as List).map((x) => BusCity.fromJson(x))),
      );
}
