import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/bus/screens/bus_search_screen.dart';
import 'package:outc/dashboard/cars/screens/search_cars.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/customText.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/screens/select_room_guests.dart';
import 'package:outc/dashboard/visa/screens/search_country.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/glass_surface.dart';
import 'package:outc/widgets/components/components.dart';
import 'package:outc/widgets/components/dialogtabsview.dart';
import 'package:outc/widgets/components/home_card.dart';
import 'package:outc/widgets/components/toast.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:outc/core/module_registry.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomeTile {
  final AppModule module;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HomeTile({
    required this.module,
    required this.icon,
    required this.label,
    required this.onTap,
  });
}

class _HomePageState extends State<HomePage> {
  List<_HomeTile> _tiles(BuildContext context) => [
        _HomeTile(
          module: AppModule.flights,
          icon: Icons.flight_takeoff,
          label: "Flights",
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
        ),
        _HomeTile(
          module: AppModule.hotels,
          icon: Icons.location_city,
          label: "Hotels",
          onTap: () {
            List<listModel> finalList = [];

            finalList
                .add(listModel(noOfAdults: 1, noOfChilds: 0, childAge: []));
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
                userId:
                    int.parse(SharedPrefServices.getcustomerId().toString()));
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
        ),
        _HomeTile(
          module: AppModule.bus,
          icon: Icons.bus_alert_outlined,
          label: "Bus",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const BusSearchScreen();
                },
              ),
            );
          },
        ),
        _HomeTile(
          module: AppModule.visa,
          icon: Icons.book,
          label: "Visa",
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return const SearchCountry();
                },
              ),
            );
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10, top: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [colorScheme.primary, colorScheme.secondary],
              ),
            ),
            child: GlassSurface(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _tiles(context)
                    .where((tile) => ModuleRegistry.isEnabled(tile.module))
                    .map((tile) => InkWell(
                          onTap: tile.onTap,
                          borderRadius: BorderRadius.circular(AppRadius.md),
                          child: Container(
                            height: 90,
                            width: 75,
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Icon(
                                      tile.icon,
                                      size: 34,
                                      color: Colors.white,
                                    )),
                                const SizedBox(
                                  height: 5,
                                ),
                                CustomText(
                                  text: tile.label,
                                  textcolor: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ),
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
