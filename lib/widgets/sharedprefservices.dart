import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefServices {
  static SharedPreferences? prefs;

  static void clearUserFromSharedPrefs() async {
    prefs = await SharedPreferences.getInstance();

    prefs!.setString('phonenumber', "");
    prefs!.setString('firstname', "");
    prefs!.setString('lastname', "");
    prefs!.setString('islogged', "false");
    prefs!.setString('profileimage', '');
    prefs!.setString('email', '');
    prefs!.setString('customerId', '');
    prefs!.setString('customerPwd', '');
    prefs!.setString('avatarfname', '');
    prefs!.setString('jwtVerifiertoken', '');
    prefs!.setString('cityFrom', '');
    prefs!.setString('airportcodeFrom', '');
    prefs!.setString('countryFrom', '');
    prefs!.setString('cityTo', '');
    prefs!.setString('airportcodeTo', '');
    prefs!.setString('countryTo', '');
    prefs!.setString('cityFromTwo', '');
    prefs!.setString('airportcodeFromTwo', '');
    prefs!.setString('countryFromTwo', '');
    prefs!.setString('cityToTwo', '');
    prefs!.setString('airportcodeToTwo', '');
    prefs!.setString('countryToTwo', '');
    prefs!.setString('cityId', '');
    prefs!.setString('cityName', '');
    prefs!.setString('countryCode', '');
    prefs!.setString('roomCount', '');
    prefs!.setString('guestCount', '');
    prefs!.setString('walletId', '');
    prefs!.setString('walletblc', '');
    prefs!.setString('roleType', '');
    prefs!.setString('selecedscroller', '');
    prefs!.setString('departureDate', '');
    prefs!.setString('arrivalDate', '');
    prefs!.setString('currencycode', '');
    prefs!.setString('currencyAmount', '');
    prefs!.setString('nationality', '');
    // prefs!.setString('currencyAmount', '');
    //  String? reportstatus,
    // String? bookingtypesstatus,
    // String? fromDate,
    // String? toDate
  }

  static const _keyphonenumber = 'phonenumber';
  static const _keyfirstname = 'firstname';
  static const _keylastname = 'lastname';
  static const _keyprofileimage = 'profileimage';
  static const _keyislogged = 'islogged';
  static const _keyemail = 'email';
  static const _keycustomerId = 'customerId';
  static const _keycustomerPwd = 'customerPwd';
  static const _keyavatarfname = 'avatarfname';
  static const _keyjwtVerifiertoken = 'jwtVerifiertoken';
  static const _keycityFrom = 'cityFrom';
  static const _keyairportcodeFrom = 'airportcodeFrom';
  static const _keycountryFrom = 'countryFrom';
  static const _keyairportcodeTo = 'airportcodeTo';
  static const _keycountryTo = 'countryTo';
  static const _keycityTo = 'cityTo';
  static const _keycityFromTwo = 'cityFromTwo';
  static const _keyairportcodeFromTwo = 'airportcodeFromTwo';
  static const _keycountryFromTwo = 'countryFromTwo';
  static const _keyairportcodeToTwo = 'airportcodeToTwo';
  static const _keycountryToTwo = 'countryToTwo';
  static const _keycityToTwo = 'cityToTwo';
  static const _keycityId = 'cityId';
  static const _keyadultCount = 'adultCount';
  static const _keychildCount = 'childCount';
  static const _keyinfantCount = 'infantCount';
  static const _keytotalCount = 'totalCount';
  static const _keycityName = 'cityName';
  static const _keycountryCode = 'countryCode';
  static const _keyroomCount = 'roomCount';
  static const _keyguestCount = 'guestCount';
  static const _keywalletId = 'walletId';
  static const _keywalletblc = 'walletblc';
  static const _keyroleType = 'roleType';
  static const _keyhotelstatus = 'hotelstatus';
  static const _keyhotelbookingtype = 'hotelbookingtype';
  static const _keyfromdate = 'fromdate';
  static const _keytodate = 'todate';
  static const _keyselecedscroller = 'selecedscroller';
  static const _keydepartureDate = 'departureDate';
  static const _keyarrivalDate = 'arrivalDate';
  static const _keycurrencycode = 'currencycode';
  static const _keycurrencyAmount = 'currencyAmount';
  static const _keynationality = 'nationality';
  static const _keydomesticSingleAmount = 'domesticsingleAmount';

  static Future init() async => prefs = await SharedPreferences.getInstance();

  static Future setphonenumber(String phonenumber) async =>
      await prefs!.setString(_keyphonenumber, phonenumber);

  static Future setfirstname(String firstname) async =>
      await prefs!.setString(_keyfirstname, firstname);

  static Future setlastname(String lastname) async =>
      await prefs!.setString(_keylastname, lastname);

  static Future setprofileimage(String profileimage) async =>
      await prefs!.setString(_keyprofileimage, profileimage);
  static Future setemail(String email) async =>
      await prefs!.setString(_keyemail, email);
  static Future setcustomerId(String customerId) async =>
      await prefs!.setString(_keycustomerId, customerId);
  static Future setislogged(String islogged) async =>
      await prefs!.setString(_keyislogged, islogged);
  static Future setcustomerPwd(String customerPwd) async =>
      await prefs!.setString(_keycustomerPwd, customerPwd);
  static Future setavatarfname(String avatarfname) async =>
      await prefs!.setString(_keyavatarfname, avatarfname);
  static Future setjwtVerifiertoken(String jwtVerifiertoken) async =>
      await prefs!.setString(_keyjwtVerifiertoken, jwtVerifiertoken);
  static Future setcityFrom(String cityFrom) async =>
      await prefs!.setString(_keycityFrom, cityFrom);
  static Future setairportcodeFrom(String airportcodeFrom) async =>
      await prefs!.setString(_keyairportcodeFrom, airportcodeFrom);
  static Future setcountryFrom(String countryFrom) async =>
      await prefs!.setString(_keycountryFrom, countryFrom);
  static Future setairportcodeTo(String airportcodeTo) async =>
      await prefs!.setString(_keyairportcodeTo, airportcodeTo);
  static Future setcountryTo(String countryTo) async =>
      await prefs!.setString(_keycountryTo, countryTo);
  static Future setcityTo(String cityTo) async =>
      await prefs!.setString(_keycityTo, cityTo);
  static Future setcityFromTwo(String cityFromTwo) async =>
      await prefs!.setString(_keycityFromTwo, cityFromTwo);
  static Future setairportcodeFromTwo(String airportcodeFromTwo) async =>
      await prefs!.setString(_keyairportcodeFromTwo, airportcodeFromTwo);
  static Future setcountryFromTwo(String countryFromTwo) async =>
      await prefs!.setString(_keycountryFromTwo, countryFromTwo);
  static Future setairportcodeToTwo(String airportcodeToTwo) async =>
      await prefs!.setString(_keyairportcodeToTwo, airportcodeToTwo);
  static Future setcountryToTwo(String countryToTwo) async =>
      await prefs!.setString(_keycountryToTwo, countryToTwo);
  static Future setcityToTwo(String cityToTwo) async =>
      await prefs!.setString(_keycityToTwo, cityToTwo);

  static Future setcityName(String cityName) async =>
      await prefs!.setString(_keycityName, cityName);
  static Future setroleType(String roleType) async =>
      await prefs!.setString(_keyroleType, roleType);

  static Future setwalletblc(String walletblc) async =>
      await prefs!.setString(_keywalletblc, walletblc);
  static Future setwalletId(String walletId) async =>
      await prefs!.setString(_keywalletId, walletId);
  static Future setcountryCode(String countryCode) async =>
      await prefs!.setString(_keycountryCode, countryCode);
  static Future setcityId(int cityId) async =>
      await prefs!.setInt(_keycityId, cityId);
  static Future setadultCount(int adultCount) async =>
      await prefs!.setInt(_keyadultCount, adultCount);
  static Future setchildCount(int childCount) async =>
      await prefs!.setInt(_keychildCount, childCount);
  static Future setinfantCount(int infantCount) async =>
      await prefs!.setInt(_keyinfantCount, infantCount);
  static Future settotalCount(int totalCount) async =>
      await prefs!.setInt(_keytotalCount, totalCount);
  static Future setroomCount(int roomCount) async =>
      await prefs!.setInt(_keyroomCount, roomCount);
  static Future setguestCount(int guestCount) async =>
      await prefs!.setInt(_keyguestCount, guestCount);

  static Future sethotelstatus(String hotelstatus) async =>
      await prefs!.setString(_keyhotelstatus, hotelstatus);
  static Future sethotelbookingtype(String hotelbookingtype) async =>
      await prefs!.setString(_keyhotelbookingtype, hotelbookingtype);
  static Future setfromdate(String fromdate) async =>
      await prefs!.setString(_keyfromdate, fromdate);
  static Future settodate(String todate) async =>
      await prefs!.setString(_keytodate, todate);
  static Future setselecedscroller(String selecedscroller) async =>
      await prefs!.setString(_keyselecedscroller, selecedscroller);
  static Future setdepartureDate(String departureDate) async =>
      await prefs!.setString(_keydepartureDate, departureDate);
  static Future setarrivalDate(String arrivalDate) async =>
      await prefs!.setString(_keyarrivalDate, arrivalDate);
  static Future setcurrencycode(String currencycode) async =>
      await prefs!.setString(_keycurrencycode, currencycode);
  static Future setcurrencyAmount(String currencyAmount) async =>
      await prefs!.setString(_keycurrencyAmount, currencyAmount);
  static Future setnationality(String nationality) async =>
      await prefs!.setString(_keynationality, nationality);

  static Future setdomesticAmount(String domesticsingleAmount) async =>
      await prefs!.setString(_keydomesticSingleAmount, domesticsingleAmount);

// getters

  static String? getphonenumber() => prefs!.getString(_keyphonenumber);

  static String? getfirstname() => prefs!.getString(_keyfirstname);

  static String? getlastname() => prefs!.getString(_keylastname);
  static String? getprofileimage() => prefs!.getString(_keyprofileimage);
  static String? getemail() => prefs!.getString(_keyemail);
  static String? getcustomerId() => prefs!.getString(_keycustomerId);
  static String? getislogged() => prefs!.getString(_keyislogged);
  static String? getcustomerPwd() => prefs!.getString(_keycustomerPwd);
  static String? getavatarfname() => prefs!.getString(_keyavatarfname);
  static String? getcityFrom() => prefs!.getString(_keycityFrom);
  static String? getcityFromTwo() => prefs!.getString(_keycityFromTwo);
  static String? getairportcodeFrom() => prefs!.getString(_keyairportcodeFrom);
  static String? getairportcodeFromTwo() =>
      prefs!.getString(_keyairportcodeFromTwo);
  static String? getairportcodeTo() => prefs!.getString(_keyairportcodeTo);
  static String? getairportcodeToTwo() =>
      prefs!.getString(_keyairportcodeToTwo);
  static String? getcityTo() => prefs!.getString(_keycityTo);
  static String? getcityToTwo() => prefs!.getString(_keycityToTwo);
  static String? getcountryFrom() => prefs!.getString(_keycountryFrom);
  static String? getcountryFromTwo() => prefs!.getString(_keycountryFromTwo);
  static String? getcountryTo() => prefs!.getString(_keycountryTo);
  static String? getcountryToTwo() => prefs!.getString(_keycountryToTwo);
  static String? getjwtVerifiertoken() =>
      prefs!.getString(_keyjwtVerifiertoken);
  static String? getcityName() => prefs!.getString(_keycityName);
  static String? getcountryCode() => prefs!.getString(_keycountryCode);
  static String? getwalletblc() => prefs!.getString(_keywalletblc);
  static String? getwalletId() => prefs!.getString(_keywalletId);
  static String? getroleType() => prefs!.getString(_keyroleType);
  static int? getcityId() => prefs!.getInt(_keycityId);
  static int? getadultCount() => prefs!.getInt(_keyadultCount);
  static int? getchildCount() => prefs!.getInt(_keychildCount);
  static int? getinfantCount() => prefs!.getInt(_keyinfantCount);
  static int? gettotalCount() => prefs!.getInt(_keytotalCount);
  static int? getroomCount() => prefs!.getInt(_keyroomCount);
  static int? getguestCount() => prefs!.getInt(_keyguestCount);

  static String? gethotelstatus() => prefs!.getString(_keyhotelstatus);
  static String? gethotelbookingtype() =>
      prefs!.getString(_keyhotelbookingtype);
  static String? getfromdate() => prefs!.getString(_keyfromdate);
  static String? gettodate() => prefs!.getString(_keytodate);
  static String? getselecedscroller() => prefs!.getString(_keyselecedscroller);
  static String? getdepartureDate() => prefs!.getString(_keydepartureDate);
  static String? getarrivalDate() => prefs!.getString(_keyarrivalDate);
  static String? getcurrencycode() => prefs!.getString(_keycurrencycode);
  static String? getcurrencyAmount() => prefs!.getString(_keycurrencyAmount);
  static String? getnationality() => prefs!.getString(_keynationality);
  static String? getdomesticAmount() =>
      prefs!.getString(_keydomesticSingleAmount);
}
