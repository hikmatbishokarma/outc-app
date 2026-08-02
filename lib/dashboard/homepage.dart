import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/bus/screens/bus_search_screen.dart';
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/customText.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/screens/select_room_guests.dart';
import 'package:outc/dashboard/visa/screens/search_country.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/core/widgets/marketing_section.dart';
import 'package:outc/widgets/sharedprefservices.dart';
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
    return Scaffold(
      backgroundColor: AppColors.panelBackground,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md, vertical: AppSpacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _tiles(context)
                    .where((tile) => ModuleRegistry.isEnabled(tile.module))
                    .map((tile) => _ServiceCard(tile: tile))
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            const MarketingSection(),
          ],
        ),
      ),
    );
  }
}

/// One service's tile on Home — a separate flat white card per service
/// (icon in a tinted circle + label) instead of all services sharing one
/// dark gradient/glass box, matching the clean, minimal-chrome look used
/// elsewhere in the app now (`AppTopBar`).
class _ServiceCard extends StatelessWidget {
  const _ServiceCard({required this.tile});

  final _HomeTile tile;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return InkWell(
      onTap: tile.onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        width: 76,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(tile.icon, size: 24, color: primary),
            ),
            const SizedBox(height: 6),
            CustomText(
              text: tile.label,
              textcolor: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
