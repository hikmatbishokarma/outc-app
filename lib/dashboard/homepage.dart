import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/bus/screens/BusDashboard.dart';
import 'package:outc/dashboard/cars/screens/search_cars.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/customText.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/screens/select_room_guests.dart';
import 'package:outc/dashboard/visa/screens/search_country.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/components.dart';
import 'package:outc/widgets/components/dialogtabsview.dart';
import 'package:outc/widgets/components/home_card.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: GestureDetector(
          //     onTap: () {
          //       showToast("Offers Coming Soon");
          //     },
          //     child: buildNote('Hello, Udayteja Ch',
          //         "Click here to grab the special offers."),
          //   ),
          // ),

          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    SharedPrefServices.setcityFrom("");
                    SharedPrefServices.setcountryFrom("");
                    SharedPrefServices.setairportcodeFrom("");
                    SharedPrefServices.setcityTo("");
                    SharedPrefServices.setcountryTo("");
                    SharedPrefServices.setairportcodeTo("");
                    SharedPrefServices.setselecedscroller("oneWay");

                    SharedPrefServices.setcityFromTwo("");
                    SharedPrefServices.setcountryFromTwo("");
                    SharedPrefServices.setairportcodeFromTwo("");
                    SharedPrefServices.setcityToTwo("");
                    SharedPrefServices.setcountryToTwo("");
                    SharedPrefServices.setairportcodeToTwo("");
                    // SharedPrefServices.setcityFrom("MUMBAI");
                    // SharedPrefServices.setcountryFrom("India");
                    // SharedPrefServices.setairportcodeFrom("BOM");
                    // SharedPrefServices.setcityTo("Dubai");
                    // SharedPrefServices.setcountryTo("United Arab Emirates");
                    // SharedPrefServices.setairportcodeTo("DXB");
                    // SharedPrefServices.setselecedscroller("oneWay");

                    // SharedPrefServices.setcityFromTwo("Dubai");
                    // SharedPrefServices.setcountryFromTwo(
                    //     "United Arab Emirates");
                    // SharedPrefServices.setairportcodeFromTwo("DXB");
                    // SharedPrefServices.setcityToTwo("NEW DELHI");
                    // SharedPrefServices.setcountryToTwo("India");
                    // SharedPrefServices.setairportcodeToTwo("DEL");

                    SharedPrefServices.setarrivalDate(
                        DateFormat.yMMMEd().format(DateTime.now()));
                    SharedPrefServices.setdepartureDate(
                        DateFormat.yMMMEd().format(DateTime.now()));
                    SharedPrefServices.setadultCount(1);
                    SharedPrefServices.settotalCount(1);
                    SharedPrefServices.setchildCount(0);
                    SharedPrefServices.setinfantCount(0);

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const FlightsListPage();
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colours.borderGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 90,
                      width: 75,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.flight_takeoff,
                                  size: 34,
                                  color: Colours.orangeOutC,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "Flights",
                              textcolor: Colours.orangeOutC,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    List<listModel> finalList = [];

                    finalList.add(
                        listModel(noOfAdults: 1, noOfChilds: 0, childAge: []));
                    SharedPrefServices.setroomCount(1);
                    SharedPrefServices.setguestCount(1);
                    SharedPrefServices.setcityName("");
                    SharedPrefServices.setcountryCode("");
                    ListModelHotels listModelHotels = ListModelHotels(
                        checkInDate: "",
                        checkOutDate: "",
                        countryCode: "",
                        currency: "",
                        hotelCityCode: "",
                        hotelCityName: "",
                        isHotelDescriptionRequried: false,
                        membership: 0,
                        nationality: "",
                        roleType: 0,
                        roomGuests: finalList,
                        userId: int.parse(
                            SharedPrefServices.getcustomerId().toString()));
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return HotelSearchPage(
                            payloadData: listModelHotels,
                          );
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colours.borderGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 90,
                      width: 75,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.location_city,
                                  size: 34,
                                  color: Colours.orangeOutC,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "Hotels",
                              textcolor: Colours.orangeOutC,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const Bus_Dashboard();
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colours.borderGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 90,
                      width: 75,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.bus_alert_outlined,
                                  size: 34,
                                  color: Colours.orangeOutC,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "Bus",
                              textcolor: Colours.orangeOutC,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const SearchCountry();
                        },
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colours.borderGrey,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Container(
                      height: 90,
                      width: 75,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            SizedBox(
                                height: 40,
                                width: 40,
                                child: Icon(
                                  Icons.book,
                                  size: 34,
                                  color: Colours.orangeOutC,
                                )),
                            const SizedBox(
                              height: 5,
                            ),
                            CustomText(
                              text: "Visa",
                              textcolor: Colours.orangeOutC,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildNote('BEST PRICE GUARENTEED',
                "Trying our level best to fetch lower price than others, try us once!!."),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: buildNote('24*7 SUPPORT',
                "We are always here for you. Reach us 24 hours a day, 7 days a week"),
          ),
        ],
      ),
    );
  }
}
