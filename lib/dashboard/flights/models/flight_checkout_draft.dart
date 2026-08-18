/// Which passenger-count bucket a [FlightPassengerDraft] belongs to. Mirrors
/// the `paxType` wire values ("ADT"/"CHD"/"INF") the booking request already
/// uses, but as a type-safe enum for UI code to switch on.
enum FlightPaxType { adult, child, infant }

extension FlightPaxTypeWire on FlightPaxType {
  /// The `paxType` value the booking API expects.
  String get wireValue => switch (this) {
        FlightPaxType.adult => 'ADT',
        FlightPaxType.child => 'CHD',
        FlightPaxType.infant => 'INF',
      };

  /// Title options offered for this pax type, same set
  /// `book_flight_formpage.dart` has always used (adults get Mr/Mrs/Ms;
  /// children/infants get Mstr/Ms).
  List<String> get titleOptions => switch (this) {
        FlightPaxType.adult => const ['MR', 'MRS', 'MS'],
        FlightPaxType.child => const ['MSTR', 'MS'],
        FlightPaxType.infant => const ['MSTR', 'MS'],
      };
}

/// One passenger's in-progress form data, held by [FlightCheckoutProvider]
/// and written into by the passenger-form cards — replaces the previous
/// approach of 5 separate `TextEditingController` lists per pax type (15
/// lists total) with one list of drafts tagged by [paxType].
class FlightPassengerDraft {
  FlightPassengerDraft({required this.paxType})
      : title = paxType.titleOptions.first;

  final FlightPaxType paxType;
  String title;
  String firstName = '';
  String lastName = '';

  /// Stored as typed/picked in `dd-MM-yyyy` form, same as today — converted
  /// to `yyyy-MM-dd` only when building the booking request.
  String dob = '';
  String nationality = '';

  bool get hasRequiredFields =>
      firstName.trim().isNotEmpty &&
      lastName.trim().isNotEmpty &&
      dob.trim().isNotEmpty &&
      nationality.trim().isNotEmpty;
}
