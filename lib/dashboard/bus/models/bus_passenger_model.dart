/// Passenger-details UI state for one selected seat (spec 0009). Plain
/// mutable data, deliberately not parsed from/serialized to JSON — there's
/// no booking endpoint to send this to yet, so it only needs to live in the
/// checkout screen's own provider for the session.
class BusPassengerDetails {
  BusPassengerDetails({this.title = 'Mr', this.name = '', this.age = '', this.gender});

  String title;
  String name;
  String age;
  String? gender;
}
