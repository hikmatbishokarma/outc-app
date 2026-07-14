import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/cars/screens/select_pickUp_location.dart';
import 'package:outc/dashboard/cars/widgets/colors.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/dashboard/flights/screens/from_city_dropdown.dart';
import 'package:outc/dashboard/flights/screens/to_city_dropdown.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SearchCarsPage extends StatefulWidget {
  const SearchCarsPage({super.key});

  @override
  State<SearchCarsPage> createState() => _SearchCarsPageState();
}

class _SearchCarsPageState extends State<SearchCarsPage> {
  String selectedCityName = '';

  String selectpickUp = "Select pick up";

  String? selectedLocation;

  int? selectedTrip;
  List<bool> isSelectedTrip = [false, false];

  int? selectedValue;
  List<bool> isSelected = [false, false, false, false];

  String selectScroller = "local";

  String selecteddate = DateFormat.yMMMEd().format(DateTime.now());
  String selectedTime = DateFormat('hh:mm a').format(DateTime.now());
  DateTime raw_dep_date = DateTime.now();
  DateTime raw_arrival_date = DateTime.now();
  String depDateFormated = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String selectedArraivaldate = DateFormat.yMMMEd().format(DateTime.now());

  final itemKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Cars_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        leading: Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              color: Cars_Colours.strongRed,
              icon: Icon(
                Icons.home,
                size: 28,
                color: Cars_Colours.strongRed,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Dashboard();
                    },
                  ),
                );
              },
            )),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Cars_Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Cars_Colours.strongRed,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        content: Container(
                          color: Colors.transparent,
                          height: 80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "My Wallet Balance",
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "INR ${SharedPrefServices.getwalletblc()}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Cars_Colours.strongRed,
                                  fontFamily: 'Poppins',
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
          IconButton(
            color: Cars_Colours.strongRed,
            icon: const ImageIcon(
              AssetImage(
                "images/notifybell.png",
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                    Text("Search Cars",
                        style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                          color: Colors.black,
                          fontFamily: 'poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ))),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.transparent,
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        key: selectScroller == "local" ? itemKey : null,
                        onPressed: () async {
                          setState(() {
                            selectScroller = "local";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 1.0,
                                  color: selectScroller == "local"
                                      ? Cars_Colours.strongRed
                                      : Colors.white,
                                )),
                            backgroundColor: selectScroller == "local"
                                ? Cars_Colours.strongRed
                                : Colors.white,
                            fixedSize: const Size(105, 35),
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.w700,
                            )),
                        child: Text(
                          'Local',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: selectScroller == "local"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ////

                      ElevatedButton(
                        key: selectScroller == "outstation" ? itemKey : null,
                        onPressed: () async {
                          setState(() {
                            selectScroller = "outstation";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 1.0,
                                  // color: Color(0xffFF6700),
                                  color: selectScroller == "outstation"
                                      ? Cars_Colours.strongRed
                                      : Colors.white,
                                )),
                            backgroundColor: selectScroller == "outstation"
                                ? Cars_Colours.strongRed
                                : Colors.white,
                            fixedSize: const Size(105, 35),
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.w700,
                            )),
                        child: Text(
                          'Out-Station',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: selectScroller == "outstation"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        key: selectScroller == "transfer" ? itemKey : null,
                        onPressed: () async {
                          setState(() {
                            selectScroller = "transfer";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  width: 1.0,
                                  color: selectScroller == "transfer"
                                      ? Cars_Colours.strongRed
                                      : Colors.white,
                                )),
                            backgroundColor: selectScroller == "transfer"
                                ? Cars_Colours.strongRed
                                : Colors.white,
                            fixedSize: const Size(105, 35),
                            textStyle: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontFamily: 'Poppins-regular',
                              fontWeight: FontWeight.w700,
                            )),
                        child: Text(
                          'Transfer',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            color: selectScroller == "transfer"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),

                      //////////
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Card(
                    color: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: selectScroller == 'local'
                          ? local()
                          : selectScroller == 'outstation'
                              ? outstation()
                              : transfer(),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget local() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: buildCard(0, '4hours/day')),
          Expanded(child: buildCard(1, '8hours/day')),
        ],
      ),
      const SizedBox(
        height: 10,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(flex: 0, child: buildCard(2, '12hours/day')),
          Flexible(flex: 0, child: buildCard(3, '24 hours/day')),
        ],
      ),
      const SizedBox(
        height: 25,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.directions_car,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SelectCity(type: "one");
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FROM",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 32),
                          children: [
                            TextSpan(
                              text: "${SharedPrefServices.getcityFrom()} ",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: SharedPrefServices.getairportcodeFrom()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            )
                          ]),
                    ),
                    Text(
                      SharedPrefServices.getcountryFrom().toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildDatePickerfordate();

          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.calendar_today,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FROM DATE",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selecteddate.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildTimePickerForTime();
          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.timer,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "START TIME",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selectedTime.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Cars_Colours.strongRed,
              fixedSize: const Size(330, 48),
              textStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.w700,
              )),
          child: const Text(
            'SEARCH',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget outstation() {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [buildTrip(0, 'ONE-WAY'), buildTrip(1, 'ROUND-TRIP')],
      ),
      const SizedBox(
        height: 25,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.directions_car,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return SelectCity(type: "one");
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "FROM",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 32),
                          children: [
                            TextSpan(
                              text: "${SharedPrefServices.getcityFrom()} ",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: SharedPrefServices.getairportcodeFrom()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            )
                          ]),
                    ),
                    Text(
                      SharedPrefServices.getcountryFrom().toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.directions_car,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return ToSelectCity(type: "one");
                      },
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "TO",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 32),
                          children: [
                            TextSpan(
                              text: "${SharedPrefServices.getcityTo()} ",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextSpan(
                              text: SharedPrefServices.getairportcodeTo()
                                  .toString(),
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                              ),
                            )
                          ]),
                    ),
                    Text(
                      SharedPrefServices.getcountryTo().toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildDatePickerfordate();

          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.calendar_today,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FROM DATE",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selecteddate.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      selectedTrip == 1
          ? const SizedBox(
              height: 15,
            )
          : Container(),
      selectedTrip == 1
          ? InkWell(
              onTap: () {
                buildDatePickerforArraivaldate();
              },
              child: Row(
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.calendar_today,
                    size: 24,
                    color: Cars_Colours.strongRed,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "TO DATE",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Cars_Colours.strongRed,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        selectedArraivaldate.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : Container(),
      selectedTrip == 1
          ? Divider(
              color: Colors.grey.shade400,
              thickness: 1.0,
            )
          : Container(),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildTimePickerForTime();
          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.timer,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "START TIME",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selectedTime.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Cars_Colours.strongRed,
              fixedSize: const Size(330, 48),
              textStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.w700,
              )),
          child: const Text(
            'SEARCH',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget transfer() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const SizedBox(
        height: 10,
      ),
      InkWell(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //       return const SelectHotelCityDropdown();
          //     },
          //   ),
          // );
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.location_city,
              size: 30,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter City Name",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RichText(
                  text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 32),
                      children: [
                        TextSpan(
                          text: SharedPrefServices.getcityName(),
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ]),
                ),
                Text(
                  SharedPrefServices.getcountryCode().toString(),
                  style: const TextStyle(
                    fontSize: 10.0,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.location_on,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final selectedCity = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SelectPickUp();
                      },
                    ),
                  );
                  if (selectedCity != null) {
                    setState(() {
                      selectedCityName = selectedCity;
                    });
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pick Up",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedCityName,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.location_on,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final selectedCity = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SelectPickUp();
                      },
                    ),
                  );
                  if (selectedCity != null) {
                    setState(() {
                      selectedCityName = selectedCity;
                    });
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Pick Up Location",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedCityName,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.location_on,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final selectedCity = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SelectPickUp();
                      },
                    ),
                  );
                  if (selectedCity != null) {
                    setState(() {
                      selectedCityName = selectedCity;
                    });
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drop Off",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedCityName,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 10,
          ),
          Icon(
            Icons.location_on,
            size: 30,
            color: Cars_Colours.strongRed,
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  final selectedCity = await Navigator.of(context).push<String>(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return const SelectPickUp();
                      },
                    ),
                  );
                  if (selectedCity != null) {
                    setState(() {
                      selectedCityName = selectedCity;
                    });
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Drop Location",
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Cars_Colours.strongRed,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      selectedCityName,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildDatePickerfordate();

          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.calendar_today,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FROM DATE",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selecteddate.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      InkWell(
        onTap: () {
          buildTimePickerForTime();
          print("triggered");
        },
        child: Row(
          children: [
            const SizedBox(
              width: 10,
            ),
            Icon(
              Icons.timer,
              size: 24,
              color: Cars_Colours.strongRed,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "START TIME",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Cars_Colours.strongRed,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
                Text(
                  selectedTime.toString(),
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      Divider(
        color: Colors.grey.shade400,
        thickness: 1.0,
      ),
      const SizedBox(
        height: 15,
      ),
      SizedBox(
        height: 48,
        child: ElevatedButton(
          onPressed: () async {},
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Cars_Colours.strongRed,
              fixedSize: const Size(330, 48),
              textStyle: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontFamily: 'Poppins-regular',
                fontWeight: FontWeight.w700,
              )),
          child: const Text(
            'SEARCH',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.white,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ]);
  }

  Widget buildCard(int index, String text) {
    return Card(
      elevation: 0,
      color: isSelected[index] ? Colors.blue : Cars_Colours.strongRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 35,
        child: InkWell(
          onTap: () {
            selectedValue = index;
            isSelected = [false, false, false, false];
            isSelected[index] = true;
          },
          child: Row(
            children: [
              Radio(
                value: index,
                activeColor: isSelected[index] ? Colors.black : Colors.blue,
                groupValue: selectedValue,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedValue = newValue;
                    isSelected = [false, false, false, false];
                    isSelected[index] = true;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected[index] ? Colors.black : Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTrip(int index, String text) {
    return Card(
      elevation: 0,
      color: isSelectedTrip[index] ? Colors.blue : Cars_Colours.strongRed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        height: 35,
        child: InkWell(
          onTap: () {
            selectedTrip = index;
            isSelectedTrip = [false, false];
            isSelectedTrip[index] = true;
          },
          child: Row(
            children: [
              Radio(
                value: index,
                activeColor: isSelectedTrip[index] ? Colors.black : Colors.blue,
                groupValue: selectedTrip,
                onChanged: (int? newValue) {
                  setState(() {
                    selectedTrip = newValue;
                    isSelectedTrip = [false, false];
                    isSelectedTrip[index] = true;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: Text(text,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color:
                          isSelectedTrip[index] ? Colors.black : Colors.white,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDatePickerfordate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        selecteddate = selectedArraivaldate = formattedDate;
        depDateFormated = DateFormat('yyyy-MM-dd').format(pickedDate);

        raw_dep_date = raw_arrival_date = pickedDate;
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  buildTimePickerForTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      String formattedTime = _formatTime(pickedTime);

      setState(() {
        selectedTime = formattedTime;
      });
    } else {
      print("Time is not selected");
    }
  }

  String _formatTime(TimeOfDay time) {
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    return '$hour:${minute < 10 ? '0$minute' : '$minute'} $period';
  }

  buildDatePickerforArraivaldate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: raw_dep_date, //get today's date
        firstDate: raw_dep_date,
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        selectedArraivaldate = formattedDate;
        raw_arrival_date = pickedDate;
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }
}
