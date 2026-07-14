import 'dart:convert';
import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/dashboard.dart';

import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/fetched_hotels_list.dart';
import 'package:outc/dashboard/hotels/screens/select_city_dropdown.dart';
import 'package:outc/dashboard/hotels/screens/select_country.dart';
import 'package:outc/dashboard/hotels/screens/select_room_guests.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/dashboard/hotels/widgets/progressbar.dart';
import 'package:outc/services/api_services_list.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class HotelSearchPage extends StatefulWidget {
  ListModelHotels payloadData;

  HotelSearchPage({super.key, required this.payloadData});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  bool isApiCallProcess = false;

  final itemKey = GlobalKey();
  DateTime raw_dep_date = DateTime.now();
  DateTime raw_arrival_date = DateTime.now();
  String selecteddate = DateFormat.yMMMEd().format(DateTime.now());
  String depDateFormated = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String checkInformatted = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String checkOutformatted = DateFormat('yyyy-MM-dd')
      .format(DateTime.now().add(const Duration(days: 1)));
  String selectedArraivaldate =
      DateFormat.yMMMEd().format(DateTime.now().add(const Duration(days: 1)));

  int numberOfRooms = int.parse(SharedPrefServices.getroomCount().toString());
  List<int?> adultsPerRoom = [
    int.parse(SharedPrefServices.getroomCount().toString())
  ];
  List<int?> childrenPerRoom = [0];
  List<List<int?>> childrenAgesPerRoom = [[]];
  // List<listModeltemp> finalList = [];

  bool starOne = false;
  bool starTwo = false;
  bool starThree = false;
  bool starFour = false;
  bool starFive = false;

  String whyAjmal1 =
      "Our competitive rates and exclusive offers are what gives us a top notch over our competitors. We promise 'Unbeatable' services both in pricing and quality. Here is the one stop destination for your Dream Destination. AnjMal provide you the best travel packages at the lowest possible pricing that gives the best value for your each penny. We are your Travel Companion and works for you so that can get the best travel experience and live some memorable moments.";

  String whyAjmal2 =
      "We give you the pros and cons for all the different travel products and allow you to decide what works best for you and your family. We combine first-hand knowledge with exceptional special offers, and we take care of every detail to create a holiday as unique as you are. You will no more need to worry about coordinating flight bookings, hotel reservations, visa stamps or tours as all your needs are taken care of under one roof.";

  String whyAjmal3 =
      "AnjMal can satisfy all your travel needs. Here, You can book flight tickets, hotels, bus tickets, activities and holiday packages at a cost-effective price. So, why go anywhere else? Visit us for a memorable travel experience in your budget.";

  @override
  Widget build(BuildContext context) {
    return Hotels_ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Hotels_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        leading: Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              color: Hotels_Colours.strongRed,
              icon: Icon(
                Icons.home,
                size: 28,
                color: Hotels_Colours.strongRed,
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
              color: Hotels_Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Hotels_Colours.strongRed,
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
                                  color: Hotels_Colours.strongRed,
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
            color: Hotels_Colours.strongRed,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.blue),
                  child: Container(
                      margin: const EdgeInsets.only(right: 10, left: 10),
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios_new_outlined,
                                  color: Hotels_Colours.veryDarkGrey,
                                  size: 20,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  // Navigator.pushAndRemoveUntil(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         const HomePage(),
                                  //   ),
                                  //   (route) => false,
                                  // );
                                },
                              ),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 8.0,
                                      right: 8.0,
                                      top: 5.0,
                                      bottom: 5.0),
                                  child: Text(
                                    "Find Next Best place to Stay",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.more_vert,
                                color: Colors.transparent,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Card(
                            color: Colors.white,
                            shadowColor: Colors.blue.shade50,
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white),
                                child: Column(children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.hotel,
                                        size: 30,
                                        color: Hotels_Colours.strongRed,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return SelectHotelCityDropdown(
                                                        payloadData:
                                                            widget.payloadData);
                                                  },
                                                ),
                                              );
                                            },
                                            //
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Enter City Name",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Hotels_Colours
                                                        .strongRed,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 32),
                                                      children: [
                                                        TextSpan(
                                                          text: SharedPrefServices
                                                                      .getcityName()!
                                                                  .isEmpty
                                                              ? "Select City"
                                                              : SharedPrefServices
                                                                  .getcityName(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'Poppins',
                                                          ),
                                                        ),
                                                      ]),
                                                ),
                                                Text(
                                                  SharedPrefServices
                                                          .getcountryCode()
                                                      .toString(),
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  InkWell(
                                    onTap: () {
                                      SharedPrefServices.setroomCount(
                                          widget.payloadData.roomGuests.length);
                                      List<listModel> editableFinallist = widget
                                          .payloadData
                                          .roomGuests as List<listModel>;
                                      print(
                                          widget.payloadData.roomGuests.length);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (BuildContext context) {
                                            return SelectRoomGuests(
                                              editableFinallist:
                                                  editableFinallist,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.person,
                                          size: 24,
                                          color: Hotels_Colours.strongRed,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Room: ${SharedPrefServices.getroomCount()}, Guests: ${SharedPrefServices.getguestCount()}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Hotels_Colours.strongRed,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // here check in start
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildDatePickerfordate();

                                      print("triggered");
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          size: 24,
                                          color: Hotels_Colours.strongRed,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Check In",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Hotels_Colours.strongRed,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      buildDatePickerforArraivaldate();
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.calendar_today,
                                          size: 24,
                                          color: Hotels_Colours.strongRed,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Check Out",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Hotels_Colours.strongRed,
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
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Icon(
                                        Icons.flag,
                                        size: 30,
                                        color: Hotels_Colours.strongRed,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) {
                                                    return SelectCountry(
                                                        payloadData:
                                                            widget.payloadData);
                                                  },
                                                ),
                                              );
                                            },
                                            //
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Enter Nationality",
                                                  style: TextStyle(
                                                    fontSize: 12.0,
                                                    color: Hotels_Colours
                                                        .strongRed,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  SharedPrefServices
                                                          .getnationality()
                                                      .toString(),
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    color: Colors.grey.shade400,
                                    thickness: 1.0,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 48,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (widget.payloadData.roomGuests
                                                .isEmpty) {
                                              widget.payloadData.roomGuests
                                                  .add({
                                                'noOfAdults': 1,
                                                'noOfChilds': 0,
                                                'childAge': [],
                                              });
                                            }
                                            widget.payloadData.checkInDate =
                                                checkInformatted.toString();
                                            widget.payloadData.checkOutDate =
                                                checkOutformatted.toString();

                                            widget.payloadData.nationality
                                                    .isEmpty
                                                ? widget.payloadData
                                                    .nationality = "IN"
                                                : widget
                                                    .payloadData.nationality;
                                            widget.payloadData.currency = "INR";
                                            widget.payloadData.userId =
                                                int.parse(SharedPrefServices
                                                        .getcustomerId()
                                                    .toString());
                                            widget.payloadData.roleType = 4;
                                            widget.payloadData.membership = 1;
                                            widget.payloadData
                                                    .isHotelDescriptionRequried =
                                                true;

                                            widget.payloadData.countryCode =
                                                SharedPrefServices
                                                        .getcountryCode()
                                                    .toString();
                                            widget.payloadData.hotelCityCode =
                                                SharedPrefServices.getcityId()
                                                    .toString();
                                            widget.payloadData.hotelCityName =
                                                SharedPrefServices.getcityName()
                                                    .toString();

                                            print(widget.payloadData);
                                            inspect(widget.payloadData);
                                            setState(() {
                                              isApiCallProcess = true;
                                            });
                                            getHotelsListmethod(
                                                widget.payloadData);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              backgroundColor:
                                                  Hotels_Colours.strongRed,
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
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ]))),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Request for Group  Enquiry",
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ]))),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  children: [
                    Card(
                        color: Colors.white,
                        shadowColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.grey.shade400)),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.privacy_tip_sharp,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "BEST PRICE GUARANTED",
                                          style: GoogleFonts.poppins(
                                              color: Hotels_Colours
                                                  .dardModerateBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                            width: 300,
                                            child: Text(
                                              "Trying Our level best to fetch lower price than others, try us once!!",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]))),
                    const SizedBox(
                      height: 5,
                    ),
                    Card(
                        color: Colors.white,
                        shadowColor: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                            side: BorderSide(color: Colors.grey.shade400)),
                        child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white),
                            child: Column(children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.av_timer,
                                      size: 30,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "24*7 SUPPORT",
                                          style: GoogleFonts.poppins(
                                              color: Hotels_Colours
                                                  .dardModerateBlue,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                            width: 300,
                                            child: Text(
                                              "We're always here for you - reach us 24 hours a day ,7 days a week",
                                              style: GoogleFonts.poppins(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )),
                                      ],
                                    )),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ]))),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://i.insider.com/5d38ca7d36e03c5dfa2ed4e3?width=750&format=jpeg&auto=webp",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          "https://www.indus.travel/aviator/qstvsndfvb/uploads/2018/07/most-visited-places-India-by-foreign-tourists.jpg",
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Travel for less with our great deals",
                      style: GoogleFonts.poppins(
                          color: Hotels_Colours.strongRed,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CarouselSlider(
                      items: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://www.indus.travel/aviator/qstvsndfvb/uploads/2018/07/most-visited-places-India-by-foreign-tourists.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/155439315/photo/passenger-airplane-flying-above-clouds-during-sunset.jpg?s=612x612&w=0&k=20&c=LJWadbs3B-jSGJBVy9s0f8gZMHi2NvWFXa3VJ2lFcL0="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/685798804/vector/airline-ticket-or-boarding-pass-for-traveling-by-plane-isolated-on-white-vector-illustration.jpg?s=612x612&w=0&k=20&c=FTCc9XrAowwcyabXLV9gixzUXRgYU3zJFWnIWfe8W_Y="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            image: const DecorationImage(
                              image: NetworkImage(
                                  "https://media.istockphoto.com/id/1294721277/vector/two-young-adult-friends-check-into-fight-online-using-smartphones.jpg?s=612x612&w=0&k=20&c=FiSpm1e6R2KfbTCsVbvTW08ZUY5SqpJ-O-usrwJysy8="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        viewportFraction: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        "Why AnjMal ?",
                        style: GoogleFonts.poppins(
                            color: Hotels_Colours.strongRed,
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Divider(
                        color: Colors.grey.shade600,
                        indent: 150,
                        endIndent: 160,
                        thickness: 2.0,
                        height: 1.5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Column(
                  children: [
                    Text(
                      whyAjmal1,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      whyAjmal2,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      whyAjmal3,
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
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
        selecteddate = formattedDate;
        selectedArraivaldate =
            DateFormat.yMMMEd().format(pickedDate.add(const Duration(days: 1)));
        depDateFormated = DateFormat('yyyy-MM-dd').format(pickedDate);
        checkInformatted = DateFormat('yyyy-MM-dd').format(pickedDate);
        checkOutformatted = DateFormat('yyyy-MM-dd')
            .format(pickedDate.add(const Duration(days: 1)));

        raw_dep_date = raw_arrival_date = pickedDate;
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  buildDatePickerforArraivaldate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate:
            raw_dep_date.add(const Duration(days: 1)), //get today's date
        firstDate: raw_dep_date.add(const Duration(days: 1)),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        selectedArraivaldate = formattedDate;
        raw_arrival_date = pickedDate;
        checkOutformatted = DateFormat('yyyy-MM-dd').format(pickedDate);
        //set foratted date to TextField value.
      });
    } else {
      print("Date is not selected");
    }
  }

  Future getHotelsListmethod(var data) async {
    print(json.encode(data.toJson()));
    var sendingdata = json.encode(data.toJson());

    try {
      APIService apiService = APIService();
      apiService.matchingHotelsList(sendingdata).then((value) async {
        inspect(value.status);
        print("StatusCode ${value.status} ");
        if (value.data!.hotels!.isEmpty) {
          setState(() {
            isApiCallProcess = false;
          });
          const invalidsnackbar = SnackBar(
            content: Text('No Hotels available. try again'),
          );
          ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
        }
        if (value.status == 200) {
          setState(() {
            isApiCallProcess = false;
          });

          // showToast('Data found successfully.');

          if (value.data!.hotels!.isEmpty) {
            setState(() {
              isApiCallProcess = false;
            });
            const invalidsnackbar = SnackBar(
              content: Text('No Hotels available. try again'),
            );
            ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
          } else if (value.data!.hotels!.isNotEmpty) {
            setState(() {
              isApiCallProcess = false;
            });

            for (var rating in value.data!.filters!.rating!) {
              if (rating.label!.contains("1 Star")) {
                setState(() {
                  starOne = true;
                });
              }
            }
            for (var rating in value.data!.filters!.rating!) {
              if (rating.label!.contains("2 Star")) {
                setState(() {
                  starTwo = true;
                });
              }
            }
            for (var rating in value.data!.filters!.rating!) {
              if (rating.label!.contains("3 Star")) {
                setState(() {
                  starThree = true;
                });
              }
            }
            for (var rating in value.data!.filters!.rating!) {
              if (rating.label!.contains("4 Star")) {
                setState(() {
                  starFour = true;
                });
              }
            }
            for (var rating in value.data!.filters!.rating!) {
              if (rating.label!.contains("5 Star")) {
                setState(() {
                  starFive = true;
                });
              }
            }

            print("ratingList");
            print("$starOne $starTwo $starThree $starFour $starFive");

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return FetchedHotelsList(
                    originalData: value.data!.hotels,
                    guestcount: SharedPrefServices.getguestCount().toString(),
                    roomCount: SharedPrefServices.getroomCount().toString(),
                    traceId: value.data!.traceId.toString(),
                    minPrice: value.data!.filters!.price!.minPrice!
                        .toStringAsFixed(2),
                    maxPrice: value.data!.filters!.price!.maxPrice!
                        .toStringAsFixed(2),
                    staOne: starOne,
                    staTwo: starTwo,
                    staThree: starThree,
                    staFour: starFour,
                    staFive: starFive,
                  );
                },
              ),
            );
          }
        } else if (value.status == 500) {
          setState(() {
            isApiCallProcess = false;
          });
        } else if (value.status == 404) {
          setState(() {
            isApiCallProcess = false;
          });
          const invalidsnackbar = SnackBar(
            content: Text('No Hotels available. try again'),
          );
          ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
        } else {
          setState(() {
            isApiCallProcess = false;
          });
          // const invalidsnackbar = SnackBar(
          //   content: Text('Data not Found. try again'),
          // );
          // ScaffoldMessenger.of(context).showSnackBar(invalidsnackbar);
        }
      });
    } catch (e) {
      setState(() {
        isApiCallProcess = false;
      });
      print(e);

      rethrow;
    }
  }
}

class listModeltemp {
  int noOfAdults;
  int noOfChilds;
  List childAge;
  // Updated data type to List<String>

  listModeltemp({
    required this.noOfAdults,
    required this.noOfChilds,
    required this.childAge,
  });

  Map<dynamic, dynamic> toJson() {
    return {
      'noOfAdults': noOfAdults.toInt(),
      'noOfChilds': noOfChilds.toInt(),
      'childAge': childAge.toList(),
    };
  }
}
