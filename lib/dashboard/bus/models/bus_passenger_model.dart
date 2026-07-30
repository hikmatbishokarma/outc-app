/// Passenger-details UI state for one selected seat (spec 0009). Plain
/// mutable data, deliberately not parsed from/serialized to JSON — there's
/// no booking endpoint to send this to yet, so it only needs to live in the
/// checkout screen's own provider for the session.
class BusPassengerDetails {
  BusPassengerDetails({this.name = '', this.age = '', this.gender});

  String name;
  String age;
  String? gender;

  /// Not collected directly in the UI — derived from gender so the value
  /// sent to the API is always consistent (Male -> Mr, Female -> Mrs).
  String get title => gender == 'Female' ? 'Mrs' : 'Mr';
}
