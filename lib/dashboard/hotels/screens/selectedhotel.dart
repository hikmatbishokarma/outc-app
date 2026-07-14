import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/hotels/models/selected_hotel_response_model.dart';
import 'package:outc/dashboard/hotels/screens/book_hotel_form_page.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/dashboard/hotels/widgets/progressbar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SelectedHotelPage extends StatefulWidget {
  String hotelCode, supplier, traceId;
  final Data? selectedHotelData;
  SelectedHotelPage(
      {super.key,
      required this.hotelCode,
      required this.supplier,
      required this.traceId,
      required this.selectedHotelData});

  @override
  State<SelectedHotelPage> createState() => _SelectedHotelPageState();
}

class _SelectedHotelPageState extends State<SelectedHotelPage> {
  bool isApiCallProcess = false;

  double lgth =
      190 * double.parse(SharedPrefServices.getroomCount().toString());

  @override
  void initState() {
    super.initState();
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
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return SafeArea(
        child: Scaffold(
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(10),
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
                      "Hotel Details",
                      // ${filteredList.length}",
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
                height: 10,
              ),
              // Text(
              //   'Gallery',
              //   style: GoogleFonts.poppins(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //       color: Colors.black),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.selectedHotelData!.hotelName.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              // const SizedBox(
              //   height: 10,
              // ),

              widget.selectedHotelData!.images!.isEmpty
                  ? SizedBox(
                      height: 150,
                      child: Image.asset(
                        'images/noimage.png',
                      ),
                    )
                  : SizedBox(
                      height: 150,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          height: 200.0, // Adjust the height of the carousel
                          enableInfiniteScroll: true, // Enable infinite scroll
                          autoPlay: true, // Auto-play the carousel
                          autoPlayInterval: const Duration(
                              seconds: 3), // Set auto-play interval
                          autoPlayAnimationDuration: const Duration(
                              milliseconds: 800), // Set animation duration
                          autoPlayCurve:
                              Curves.fastOutSlowIn, // Set animation curve
                          enlargeCenterPage: true, // Enlarge the center item
                        ),
                        items: widget.selectedHotelData!.images!.map((url) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: const BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        }).toList(),
                      )),
              const SizedBox(
                height: 10,
              ),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.0)),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Star Rating',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          RatingBarIndicator(
                            rating: double.parse(widget
                                .selectedHotelData!.starRating
                                .toString()),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Color(0xffFF6700),
                            ),
                            itemCount: 5,
                            itemSize: 20.0,
                            direction: Axis.horizontal,
                            unratedColor: Colors.grey,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address :',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              "${widget.selectedHotelData!.addresses![0].address} ${widget.selectedHotelData!.addresses![0].cityName} ${widget.selectedHotelData!.addresses![0].countryCode} ${widget.selectedHotelData!.addresses![0].postalCode}",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Searched Criteria',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Check In :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat('MM-dd-yyyy').format(DateTime.parse(widget
                        .selectedHotelData!.request!.checkInDate
                        .toString())),
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Check Out :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    DateFormat('MM-dd-yyyy').format(DateTime.parse(widget
                        .selectedHotelData!.request!.checkOutDate
                        .toString())),
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Guest(s) :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    SharedPrefServices.getguestCount().toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey.shade300,
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.0)),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Why Book with us ?',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Best Rates Gauranteed',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Get best rates from all regions ',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'No booking fees . ',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Available Rooms',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              widget.selectedHotelData!.combineRoom!.isEmpty
                  ? Container()
                  : Container(
                      color: Colors.white,

                      // height:
                      //     widget.selectedHotelData!.combineRoom!.length * lgth,
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              widget.selectedHotelData!.combineRoom!.length,
                          itemBuilder: (context, index) {
                            double amountedited = widget
                                    .selectedHotelData!
                                    .combineRoom![index]
                                    .priceDetails!
                                    .totalPrice! *
                                double.parse(
                                    SharedPrefServices.getcurrencyAmount()
                                        .toString());
                            return Card(
                                color: Colors.white,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                child: SizedBox(
                                  // height: widget
                                  //         .selectedHotelData!
                                  //         .combineRoom![index]
                                  //         .combineRooms!
                                  //         .length *
                                  //     185,
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: widget
                                              .selectedHotelData!
                                              .combineRoom![index]
                                              .combineRooms!
                                              .length,
                                          itemBuilder: (context, ind) {
                                            return Container(
                                              // height: widget
                                              //         .selectedHotelData!
                                              //         .combineRoom![index]
                                              //         .combineRooms!
                                              //         .length *
                                              //     70,
                                              width: double.infinity,
                                              color: Colors.white,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10, left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    // SizedBox(
                                                    //   height: 30,
                                                    //   child: ElevatedButton(
                                                    //       onPressed: () {},
                                                    //       style: ElevatedButton
                                                    //           .styleFrom(
                                                    //               backgroundColor:
                                                    //                   Colors
                                                    //                       .blue),
                                                    //       child: Text(
                                                    //         'Room ${widget.selectedHotelData!.combineRoom![index].combineRooms![ind].roomId}',
                                                    //         style: const TextStyle(
                                                    //             color: Colors
                                                    //                 .white,
                                                    //             fontSize: 14,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w500),
                                                    //       )),
                                                    // ),
                                                    // const SizedBox(
                                                    //   height: 10,
                                                    // ),
                                                    RichText(
                                                      maxLines: 2,
                                                      text: TextSpan(
                                                        text: 'Boarding : ',
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          fontFamily: 'poppins',
                                                          color: Hotels_Colours
                                                              .strongRed,
                                                          fontWeight:
                                                              FontWeight.w700,

                                                          // color: Colors.grey[800],
                                                        ),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                            text: widget
                                                                .selectedHotelData!
                                                                .combineRoom![
                                                                    index]
                                                                .combineRooms![
                                                                    ind]
                                                                .roomName
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'poppins',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    Text(
                                                      'Charges will apply on Cancelling',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Hotels_Colours
                                                            .strongRed,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    // Row(
                                                    //   children: [
                                                    //     RichText(
                                                    //       text: TextSpan(
                                                    //         text:
                                                    //             'Inclusions : ',
                                                    //         style: TextStyle(
                                                    //           fontSize: 12.0,
                                                    //           fontFamily:
                                                    //               'poppins',
                                                    //           color: Hotels_Colours
                                                    //               .strongRed,
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .w700,
                                                    //           // color: Colors.grey[800],
                                                    //         ),
                                                    //         children: const <TextSpan>[
                                                    //           TextSpan(
                                                    //             text:
                                                    //                 "need to fix",
                                                    //             style:
                                                    //                 TextStyle(
                                                    //               fontSize:
                                                    //                   12.0,
                                                    //               fontFamily:
                                                    //                   'poppins',
                                                    //               fontWeight:
                                                    //                   FontWeight
                                                    //                       .w700,
                                                    //               color: Colors
                                                    //                   .black,
                                                    //             ),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     ),
                                                    //     const SizedBox(
                                                    //       width: 5,
                                                    //     ),
                                                    //   ],
                                                    // ),
                                                    const SizedBox(height: 10),
                                                    const Divider(
                                                      thickness: 2,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(height: 10),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              widget
                                                          .selectedHotelData!
                                                          .combineRoom![index]
                                                          .refundable ==
                                                      false
                                                  ? Text(
                                                      "Non - Refundable",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: widget
                                                                    .selectedHotelData!
                                                                    .combineRoom![
                                                                        index]
                                                                    .refundable ==
                                                                false
                                                            ? Hotels_Colours
                                                                .strongRed
                                                            : Colors.green,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    )
                                                  : Text(
                                                      "Refundable",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        color: Colors.green,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                              Row(
                                                children: [
                                                  Text(
                                                      SharedPrefServices
                                                              .getcurrencycode()
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.green,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'poppins',
                                                      )),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                      amountedited
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontFamily: 'poppins',
                                                      )),
                                                ],
                                              ),
                                            ]),
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        width: double.infinity,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return BookHotelFormPage(
                                                  roomIndex: index,
                                                  adultCount: int.parse(
                                                      SharedPrefServices
                                                              .getguestCount()
                                                          .toString()),
                                                  selectedHotelData:
                                                      widget.selectedHotelData,
                                                );
                                              }));
                                              print("Index $index");
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Hotels_Colours.buttonColor,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5))),
                                            child: const Text(
                                              'Choose Room',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                ));
                          }),
                    ),
              const SizedBox(
                height: 15,
              ),
              widget.selectedHotelData!.hotelFacility!.isNotEmpty
                  ? Text(
                      'Hotel Facilities',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.selectedHotelData!.hotelFacility!.length,
                itemBuilder: (BuildContext context, int indexes) {
                  return ListTile(
                    leading: const Icon(
                      Icons.check,
                      color: Colors.black,
                    ),
                    title: Text(
                      widget.selectedHotelData!.hotelFacility![indexes],
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
