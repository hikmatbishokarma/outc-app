import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_picker/country_picker.dart';

import 'package:flutter/material.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/hotels/models/selected_hotel_response_model.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/dashboard/hotels/widgets/progressbar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class BookHotelFormPage extends StatefulWidget {
  int adultCount;
  int roomIndex;

  final Data? selectedHotelData;
  BookHotelFormPage({
    super.key,
    required this.adultCount,
    required this.selectedHotelData,
    required this.roomIndex,
  });

  @override
  State<BookHotelFormPage> createState() => _BookHotelFormPageState();
}

class _BookHotelFormPageState extends State<BookHotelFormPage> {
  bool isApiCallProcess = false;
  bool firstValue = false;
  Country selectedCountry = Country(
      phoneCode: "91",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "India",
      example: "India",
      displayName: "India",
      displayNameNoCountryCode: "IN",
      e164Key: "");
  String selectedValue = 'Mr';
  var adult = ['Mr', 'Mrs', 'Ms'];
  // initiate controllers
  var titleAdultControllers = [];
  var firstnameAdultControllers = [];
  var lastNameAdultControllers = [];
  var ageAdultControllers = [];
  var panAdultControllers = [];

  @override
  void initState() {
    super.initState();

    createtitleAdultControllers();
    createfirstnameAdultControllers();
    createlastNameAdultControllers();
    createageAdultControllers();
    createpanAdultControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Hotels_ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    // String taxFee = (widget.selectedHotelData!.rooms![widget.roomIndex]
    //             .ratePlans![0].price!.tax! +
    //         widget.selectedHotelData!.rooms![widget.roomIndex].ratePlans![0]
    //             .price!.otherCharges!)
    //     .toStringAsExponential(2);

    // String grandTotal = (widget.selectedHotelData!.rooms![widget.roomIndex]
    //             .ratePlans![0].price!.total! +
    //         200)
    //     .toStringAsExponential(2);

    // String roomPrice = widget
    //     .selectedHotelData!.rooms![widget.roomIndex].ratePlans![0].price!.base!
    //     .toStringAsExponential(2);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
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
        automaticallyImplyLeading: false,
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
          child: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios_new_outlined,
                          color: Hotels_Colours.veryDarkGrey,
                          // color: Colors.transparent,
                          size: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context, false);
                      },
                    ),
                    Text(
                      "Fill the Form",
                      style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 16.0,
                          color: Hotels_Colours.strongRed,
                          fontWeight: FontWeight.w700),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_alt,
                        color: Colors.transparent,
                        // color: Colors.transparent,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
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
                  child: Container(
                      margin: const EdgeInsets.only(
                          right: 15, left: 15, top: 25, bottom: 25),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xff35459c))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 10, top: 10, right: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                widget.selectedHotelData!.images!.isEmpty
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child:
                                            Image.asset("images/noimage.png"),
                                      )
                                    : SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: CarouselSlider(
                                          options: CarouselOptions(
                                            height:
                                                100.0, // Adjust the height of the carousel
                                            enableInfiniteScroll:
                                                true, // Enable infinite scroll
                                            autoPlay:
                                                true, // Auto-play the carousel
                                            autoPlayInterval: const Duration(
                                                seconds:
                                                    3), // Set auto-play interval
                                            autoPlayAnimationDuration:
                                                const Duration(
                                                    milliseconds:
                                                        800), // Set animation duration
                                            autoPlayCurve: Curves
                                                .fastOutSlowIn, // Set animation curve
                                            enlargeCenterPage:
                                                true, // Enlarge the center item
                                          ),
                                          items: widget
                                              .selectedHotelData!.images!
                                              .map((url) {
                                            return Builder(
                                              builder: (BuildContext context) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5.0),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors.grey,
                                                  ),
                                                  child: url.contains("http")
                                                      ? Image.network(
                                                          url,
                                                          fit: BoxFit.cover,
                                                        )
                                                      : Image.asset(
                                                          'images/noimage.png',
                                                        ),
                                                );
                                              },
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          widget.selectedHotelData!.hotelName
                                              .toString(),
                                          style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      RatingBarIndicator(
                                        rating: double.parse(widget
                                            .selectedHotelData!.starRating
                                            .toString()),
                                        itemBuilder: (context, index) =>
                                            const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        itemCount: 5,
                                        itemSize: 20.0,
                                        direction: Axis.horizontal,
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget
                                .selectedHotelData!
                                .combineRoom![widget.roomIndex]
                                .combineRooms![0]
                                .roomName
                                .toString(),
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Hotels_Colours.strongRed,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xff35459c))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Check-In',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MM-dd-yyyy').format(
                                              DateTime.parse(widget
                                                  .selectedHotelData!
                                                  .request!
                                                  .checkInDate
                                                  .toString())),
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
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(0xff35459c))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Check-Out',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Text(
                                          DateFormat('MM-dd-yyyy').format(
                                              DateTime.parse(widget
                                                  .selectedHotelData!
                                                  .request!
                                                  .checkOutDate
                                                  .toString())),
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
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5, top: 5),
                            child: RichText(
                              text: TextSpan(
                                text: 'Cancellation Policy : ',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontFamily: 'poppins',
                                  color: Hotels_Colours.strongRed,
                                  fontWeight: FontWeight.w700,
                                  // color: Colors.grey[800],
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: widget
                                        .selectedHotelData!
                                        .combineRoom![widget.roomIndex]
                                        .combineRooms![0]
                                        .cancellationPolicy![0]
                                        .policies![0],
                                    style: const TextStyle(
                                      fontSize: 12.0,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              // Positioned(
              //     top: 10,
              //     left: 14,
              //     child: Card(
              //         elevation: 5,
              //         shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(10)),
              //         child: Container(
              //           width: 250,
              //           height: 25,
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(5),
              //               gradient: const LinearGradient(
              //                 colors: [Color(0xffbd0c21), Color(0xff35459c)],
              //                 begin: Alignment.topLeft,
              //                 end: Alignment.bottomRight,
              //               )),
              //           child: Center(
              //               child: Text("Uday hotel",
              //                   // widget.selectedHotelData!.hotelName!,
              //                   style: GoogleFonts.poppins(
              //                       color: Colors.white,
              //                       fontSize: 16,
              //                       fontWeight: FontWeight.w500))),
              //         ))),
              const SizedBox(
                height: 15,
              ),
              Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Container(
                            margin: const EdgeInsets.only(
                                right: 10, left: 10, top: 20, bottom: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                    Border.all(color: const Color(0xff35459c))),
                            child: Container(
                              margin: const EdgeInsets.only(
                                  right: 10, left: 10, top: 10),
                              child: Column(children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("Phone number",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TextFormField(
                                        keyboardType: TextInputType.number,
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 12, 10, 5),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          hintText: 'Enter Mobile Number',
                                          hintStyle: GoogleFonts.poppins(
                                              color:
                                                  Hotels_Colours.veryDarkGrey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                          prefixIcon: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                12, 10, 10, 5),
                                            child: InkWell(
                                              onTap: () {
                                                showCountryPicker(
                                                    context: context,
                                                    countryListTheme:
                                                        const CountryListThemeData(
                                                            bottomSheetHeight:
                                                                600),
                                                    onSelect: (value) {
                                                      setState(() {
                                                        selectedCountry = value;
                                                      });
                                                    });
                                              },
                                              child: Text(
                                                  "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("Email",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffC2C2C2))),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ))),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("Address",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffC2C2C2))),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ))),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    const Text(
                                      "*",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text("Country",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600)),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    height: 40,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xffC2C2C2))),
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 3),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                              border: InputBorder.none),
                                        ))),
                                const SizedBox(
                                  height: 20,
                                ),
                              ]),
                            ))),
                    Positioned(
                        top: 5,
                        right: 15,
                        left: 15,
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                              width: double.infinity,
                              height: 25,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xffbd0c21),
                                      Color(0xff35459c)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 1),
                                child: Text("Contact Details",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500)),
                              ),
                            )))
                  ])),
              const SizedBox(
                height: 15,
              ),
              buildAdultContainers(),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 15, right: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Fare Details",
                                style: GoogleFonts.poppins(
                                    color: Colors.grey.shade800,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                              Divider(
                                thickness: 1.0,
                                color: Colors.grey.shade400,
                              )
                            ],
                          )),
                      const SizedBox(
                        height: 5,
                      ),
                      Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(
                              right: 15, left: 15, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: const Color(0xff35459c))),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Room Price:",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        "${widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.currency} ${widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.roomPrice}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Taxes & Fee's:",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        "${widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.currency} ${(widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.totalTax!.toStringAsFixed(2))}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Convenience Fee:",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                    Text("INR 200.00",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Grand Total:",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500)),
                                    Text(
                                        "${widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.currency} ${(widget.selectedHotelData!.combineRoom![widget.roomIndex].priceDetails!.totalPrice! + 200).toStringAsFixed(2)}",
                                        style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 20,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffbd0c21),
                                          Color(0xff35459c)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 1, right: 5),
                                    child: Text("Base Fare",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                )))
                      ]),
                      const SizedBox(
                        height: 15,
                      ),
                      Stack(children: [
                        Container(
                          margin: const EdgeInsets.only(
                              right: 15, left: 15, top: 15, bottom: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: const Color(0xff35459c))),
                          child: Container(
                            margin: const EdgeInsets.only(right: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Text("Apply Promo",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(
                                  height: 5,
                                ),
                                Row(children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: InputDecoration(
                                          hintText: "Enter Your Promo code",
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade500,
                                              fontSize: 15),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 10, 10, 10),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                              borderSide: const BorderSide(
                                                  color: Color(0xffC2C2C2))),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.pink.shade300,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2))),
                                      child: Text("APPLY",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)))
                                ]),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 20,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                  height: 25,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xffbd0c21),
                                          Color(0xff35459c)
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5, top: 1, right: 5),
                                    child: Text("Apply Promo",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                )))
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
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
                      child: Container(
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Checkbox(
                                    side:
                                        BorderSide(color: Colors.grey.shade400),
                                    activeColor: Colors.blue,
                                    value: firstValue,
                                    onChanged: (value) {
                                      setState(() {
                                        firstValue = value!;
                                      });
                                    },
                                    visualDensity:
                                        const VisualDensity(horizontal: -3)),
                                Expanded(
                                    child: Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                              text: 'I Agree To All The',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text: ' Terms & Conditions ',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text: 'and ',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.red,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                          TextSpan(
                                              text: ' Privacy Policy. ',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.blue,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500)),
                                        ]))))
                              ]),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    onPressed: () async {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.shade800,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        )),
                                    child: Text("Continue",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          )))),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      )),
    );
  }

  Widget buildAdultContainers() {
    List<Widget> adultContainers = [];
    for (int i = 0; i < widget.adultCount; i++) {
      adultContainers.add(
        Column(
          children: [
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
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5, top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Guest ${i + 1}",
                          style: GoogleFonts.poppins(
                              color: Colors.orangeAccent.shade400,
                              fontSize: 14,
                              fontWeight: FontWeight.w600)),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Title",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 40,
                              width: double.infinity,
                              child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2)),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                      size: 35,
                                    ),
                                    value: selectedValue,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedValue = newValue!;
                                        titleAdultControllers[i] = newValue;
                                      });
                                    },
                                    items: adult.map((String items) {
                                      return DropdownMenuItem<String>(
                                          value: items,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              items,
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                          ));
                                    }).toList(),
                                  ))),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("First Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 3),
                                    child: TextFormField(
                                      controller: firstnameAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Last Name",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 3),
                                    child: TextFormField(
                                      controller: lastNameAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Age",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 3),
                                    child: TextFormField(
                                      controller: ageAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "*",
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text("Pan Card",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xffC2C2C2))),
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 3),
                                    child: TextFormField(
                                      controller: panAdultControllers[i],
                                      decoration: const InputDecoration(
                                          border: InputBorder.none),
                                    ))),
                            const SizedBox(
                              height: 10,
                            ),
                          ])),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      );
    }
    return Column(children: adultContainers);
  }

  // all the below methods are used to create dynamic controllers
  createtitleAdultControllers() {
    titleAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      titleAdultControllers.add(TextEditingController());
    }
  }

  createfirstnameAdultControllers() {
    firstnameAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      firstnameAdultControllers.add(TextEditingController());
    }
  }

  createlastNameAdultControllers() {
    lastNameAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      lastNameAdultControllers.add(TextEditingController());
    }
  }

  createageAdultControllers() {
    ageAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      ageAdultControllers.add(TextEditingController());
    }
  }

  createpanAdultControllers() {
    panAdultControllers = [];
    for (var i = 0; i < widget.adultCount; i++) {
      panAdultControllers.add(TextEditingController());
    }
  }
}
