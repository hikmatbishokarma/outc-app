class Mergedcatlist {
  final String? AirportCode;
  final String? City;
  final String? Country;
  final String? CountryCode;
  final String? AirportDesc;
  final String? Type;
  final String? displayName;

  const Mergedcatlist({
    this.AirportCode,
    this.City,
    this.Country,
    this.CountryCode,
    this.AirportDesc,
    this.Type,
    this.displayName,
  });

  factory Mergedcatlist.fromJson(Map<String, dynamic> json) => Mergedcatlist(
        AirportCode: json['AirportCode'] ?? "",
        City: json['City'],
        Country: json['Country'],
        CountryCode: json['CountryCode'],
        AirportDesc: json['AirportDesc'],
        Type: json['Type'] ?? "",
        displayName: json['displayName'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'AirportCode': AirportCode,
        'City': City,
        'Country': Country,
        'CountryCode': CountryCode,
        'AirportDesc': AirportDesc,
        'Type': Type,
        'displayName': displayName,
      };
}
