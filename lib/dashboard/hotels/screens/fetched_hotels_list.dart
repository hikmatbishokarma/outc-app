// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/hotels/models/hotels_list_model.dart';
import 'package:outc/dashboard/hotels/models/selected_hotel_payload.dart';
import 'package:outc/dashboard/hotels/screens/selectedhotel.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/dashboard/hotels/widgets/progressbar.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class FetchedHotelsList extends StatefulWidget {
  List<Hotel>? originalData;
  bool staOne, staTwo, staThree, staFour, staFive;

  String traceId, guestcount, roomCount, minPrice, maxPrice;
  FetchedHotelsList({
    super.key,
    required this.originalData,
    required this.guestcount,
    required this.roomCount,
    required this.traceId,
    required this.minPrice,
    required this.maxPrice,
    required this.staOne,
    required this.staTwo,
    required this.staThree,
    required this.staFour,
    required this.staFive,
  });

  @override
  State<FetchedHotelsList> createState() => _FetchedHotelsListState();
}

class _FetchedHotelsListState extends State<FetchedHotelsList> {
  TextEditingController searchController = TextEditingController();
  SelectedHotelmodel payloadData = SelectedHotelmodel(
      traceId: "",
      hotelCode: "",
      supplier: "",
      userId: 1,
      roleType: 4,
      membership: 1);
  bool isApiCallProcess = false;
  List<Hotel>? hotelsData = [];
  String filterName = '';
  RangeValues _currentRangeValues = const RangeValues(0, 0);
  double _startValue = 0;
  double _endValue = 0;
  bool starOne = false;
  bool starTwo = false;
  bool starThree = false;
  bool starFour = false;
  bool starFive = false;

  @override
  void initState() {
    super.initState();
    updateData();
    _currentRangeValues = RangeValues(
        double.parse(widget.minPrice), double.parse(widget.maxPrice));
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  bool filterIcon = false;

  @override
  Widget build(BuildContext context) {
    return Hotels_ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    _startValue = double.parse(widget.minPrice);
    _endValue = double.parse(widget.maxPrice);

    RangeLabels labels = RangeLabels(
        _currentRangeValues.start.round().toString(),
        _currentRangeValues.end.round().toString());
    return Scaffold(
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
        child: Column(
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
                    "Hotels List",
                    style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 16.0,
                        color: Hotels_Colours.strongRed,
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.filter_alt,
                        color: Hotels_Colours.strongRed,
                        // color: Colors.transparent,
                        size: 20,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        filterIcon = true;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w700,
                ),
                onChanged: filterHotelbyName,
                decoration: InputDecoration(
                  labelText: 'Search by Hotel Name',
                  labelStyle: TextStyle(
                    color: Hotels_Colours.strongRed,
                    fontFamily: 'Helvetica Neue',
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Hotels_Colours.strongRed,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Hotels_Colours.strongRed,
                    ),
                    onPressed: () {
                      setState(() {
                        filterHotelbyName("");
                        searchController.clear();
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Hotels_Colours.strongRed),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Hotels_Colours.strongRed)),
                ),
              ),
            ),
            hotelsData!.isEmpty
                ? Container()
                : Expanded(
                    child: ListView.builder(
                        itemCount: hotelsData!.length,
                        itemBuilder: (context, index) {
                          double amountedited =
                              hotelsData![index].hotelNetPrice! *
                                  double.parse(
                                      SharedPrefServices.getcurrencyAmount()
                                          .toString());
                          return Container(
                            margin: const EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Hotels_Colours.strongRed,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, top: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      hotelsData![index].images!.isEmpty
                                          ? SizedBox(
                                              height: 100,
                                              width: 100,
                                              child: Image.asset(
                                                  "images/noimage.png"),
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
                                                items: hotelsData![index]
                                                    .images!
                                                    .map((url) {
                                                  return Builder(
                                                    builder:
                                                        (BuildContext context) {
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 5.0),
                                                        decoration:
                                                            const BoxDecoration(
                                                          color: Colors.grey,
                                                        ),
                                                        child:
                                                            url.contains("http")
                                                                ? Image.network(
                                                                    url,
                                                                    fit: BoxFit
                                                                        .cover,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              child: Text(
                                                hotelsData![index]
                                                    .hotelName
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontFamily: 'Poppins',
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            RatingBarIndicator(
                                              rating: double.parse(
                                                  hotelsData![index]
                                                      .starRating
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
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.location_city,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${hotelsData![index].addresses![0].address} ${hotelsData![index].addresses![0].cityName} ${hotelsData![index].addresses![0].postalCode}",
                                                    style: TextStyle(
                                                      fontSize: 12.0,
                                                      color: Hotels_Colours
                                                          .veryDarkGrey,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Poppins',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // widget.hotelsData![index]
                                            //         .hotelFacility!.isNotEmpty
                                            //     ? GestureDetector(
                                            //         onTap: () {
                                            //           showDialog(
                                            //             context: context,
                                            //             builder: (context) {
                                            //               return AlertDialog(
                                            //                 shape: const RoundedRectangleBorder(
                                            //                     borderRadius: BorderRadius
                                            //                         .all(Radius
                                            //                             .circular(
                                            //                                 8))),
                                            //                 title: const Text(
                                            //                   'All Aminities',
                                            //                   style: TextStyle(
                                            //                     fontSize: 14.0,
                                            //                     color: Colors
                                            //                         .black,
                                            //                     fontFamily:
                                            //                         'Poppins',
                                            //                   ),
                                            //                 ),
                                            //                 content: SizedBox(
                                            //                   width: double
                                            //                       .maxFinite,
                                            //                   child: ListView
                                            //                       .builder(
                                            //                     shrinkWrap:
                                            //                         true,
                                            //                     itemCount: widget
                                            //                         .hotelsData![
                                            //                             index]
                                            //                         .hotelFacility!
                                            //                         .length,
                                            //                     itemBuilder:
                                            //                         (BuildContext
                                            //                                 context,
                                            //                             int indexes) {
                                            //                       return ListTile(
                                            //                         leading:
                                            //                             const Icon(
                                            //                           Icons
                                            //                               .check,
                                            //                           color: Colors
                                            //                               .black,
                                            //                         ),
                                            //                         title: Text(
                                            //                           widget
                                            //                               .hotelsData![
                                            //                                   index]
                                            //                               .hotelFacility![
                                            //                                   indexes]
                                            //                               .name,
                                            //                           style:
                                            //                               const TextStyle(
                                            //                             fontSize:
                                            //                                 14.0,
                                            //                             color: Colors
                                            //                                 .black,
                                            //                             fontFamily:
                                            //                                 'Poppins',
                                            //                           ),
                                            //                         ),
                                            //                       );
                                            //                     },
                                            //                   ),
                                            //                 ),
                                            //                 actions: [
                                            //                   TextButton(
                                            //                     onPressed: () {
                                            //                       Navigator.pop(
                                            //                           context);
                                            //                     },
                                            //                     child: Text(
                                            //                         'Close'),
                                            //                   ),
                                            //                 ],
                                            //               );
                                            //             },
                                            //           );
                                            //         },
                                            //         child: const Text(
                                            //           "Show All Aminities",
                                            //           style: TextStyle(
                                            //             fontSize: 14.0,
                                            //             color: Colors.red,
                                            //             fontWeight:
                                            //                 FontWeight.bold,
                                            //             fontFamily: 'Poppins',
                                            //           ),
                                            //         ),
                                            //       )
                                            //     : const SizedBox()
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 5, top: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              SharedPrefServices
                                                      .getcurrencycode()
                                                  .toString(),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Hotels_Colours.strongRed,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'poppins',
                                              )),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(amountedited.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 14.0,
                                                color: Hotels_Colours.strongRed,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'poppins',
                                              )),
                                        ],
                                      ),
                                      // Text(
                                      //   "INR ${widget.hotelsData![index].hotelNetPrice}",
                                      //   style: TextStyle(
                                      //     fontSize: 14.0,
                                      //     color: Hotels_Colours.strongRed,
                                      //     fontWeight: FontWeight.bold,
                                      //     fontFamily: 'Poppins',
                                      //   ),
                                      // ),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              isApiCallProcess = true;
                                            });
                                            print("button triggered");
                                            String hotelCode =
                                                hotelsData![index]
                                                    .hotelCode
                                                    .toString();
                                            String supplier = hotelsData![index]
                                                .supplier
                                                .toString();
                                            APIService apiService =
                                                APIService();

                                            apiService
                                                .selectedHotel(widget.traceId,
                                                    hotelCode, supplier)
                                                .then((value) async {
                                              if (value
                                                  .data!.errors!.isNotEmpty) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                const invalidsnackbar =
                                                    SnackBar(
                                                  content: Text(
                                                      'No room available at this moment. Please try again later'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        invalidsnackbar);
                                              } else if (value.status
                                                  .toString()
                                                  .isNotEmpty) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                              }

                                              if (value.status == 200) {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder:
                                                        (BuildContext context) {
                                                      return SelectedHotelPage(
                                                        traceId: widget.traceId,
                                                        hotelCode: hotelCode,
                                                        supplier: supplier,
                                                        selectedHotelData:
                                                            value.data,
                                                      );
                                                    },
                                                  ),
                                                );
                                              } else {
                                                setState(() {
                                                  isApiCallProcess = false;
                                                });
                                                const invalidsnackbar =
                                                    SnackBar(
                                                  content: Text(
                                                      'No room available at this moment. Please try again later'),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                        invalidsnackbar);
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Hotels_Colours.strongRed,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              )),
                                          child: Text("Choose",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 14,
                                              )))
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
            filterIcon
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 15, left: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border:
                                  Border.all(color: Hotels_Colours.strongRed)),
                          child: Container(
                            margin: const EdgeInsets.only(right: 15, left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Filters",
                                      style: GoogleFonts.poppins(
                                          color: Hotels_Colours.strongRed,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          starOne = starTwo = starThree =
                                              starFour = starFive = false;
                                          _currentRangeValues = RangeValues(
                                              double.parse(widget.minPrice),
                                              double.parse(widget.maxPrice));
                                        });
                                      },
                                      child: Text(
                                        "Clear all",
                                        style: GoogleFonts.poppins(
                                            color:
                                                Hotels_Colours.dardModerateBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(
                                  height: 15,
                                ),

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceEvenly,
                                //   children: refundables
                                //       .map((refund) => FilterChip(
                                //           selected: selectedrefundablesFilters
                                //               .contains(refund),
                                //           checkmarkColor: Hotels_Colours.strongRed,
                                //           label: Text(refund.toString(),
                                //               style: GoogleFonts.poppins(
                                //                   color: Hotels_Colours.strongRed,
                                //                   fontSize: 14,
                                //                   fontWeight: FontWeight.w500)),
                                //           onSelected: (selected) {
                                //             setState(() {
                                //               if (selected) {
                                //                 selectedrefundablesFilters
                                //                     .add(refund);
                                //               } else {
                                //                 selectedrefundablesFilters
                                //                     .remove(refund);
                                //               }
                                //             });
                                //             print(selectedStopFilters);
                                //             inspect(selectedStopFilters);
                                //           }))
                                //       .toList(),
                                // ),
                                Divider(
                                  thickness: 1.0,
                                  color: Hotels_Colours.veryDarkGrey,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Price Range",
                                      style: GoogleFonts.poppins(
                                          color: Hotels_Colours.strongRed,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _currentRangeValues = RangeValues(
                                              double.parse(widget.minPrice),
                                              double.parse(widget.maxPrice));
                                        });
                                      },
                                      child: Text(
                                        "Clear",
                                        style: GoogleFonts.poppins(
                                            color: Hotels_Colours.veryDarkGrey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${_currentRangeValues.start.toStringAsFixed(2)} INR',
                                      style: TextStyle(
                                          color: Hotels_Colours.strongRed,
                                          fontSize: 14),
                                    ),
                                    Text(
                                      '${_currentRangeValues.end.toStringAsFixed(2)} INR',
                                      style: TextStyle(
                                          color: Hotels_Colours.strongRed,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                SliderTheme(
                                  data: SliderThemeData(
                                      rangeThumbShape:
                                          const RoundRangeSliderThumbShape(
                                              enabledThumbRadius: 7),
                                      overlayShape:
                                          const RoundSliderOverlayShape(
                                        overlayRadius: 5.0,
                                      ),
                                      trackHeight: 2,
                                      inactiveTrackColor:
                                          Hotels_Colours.veryDarkGrey),
                                  child: RangeSlider(
                                    activeColor: Hotels_Colours.strongRed,
                                    values: _currentRangeValues,
                                    divisions: 10,
                                    labels: labels,
                                    min: _startValue,
                                    max: _endValue,
                                    onChanged: (RangeValues values) {
                                      setState(() {
                                        _currentRangeValues = values;
                                      });
                                    },
                                  ),
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: Hotels_Colours.veryDarkGrey,
                                ),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Ratings",
                                      style: GoogleFonts.poppins(
                                          color: Hotels_Colours.strongRed,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          starOne = starTwo = starThree =
                                              starFour = starFive = false;
                                        });
                                      },
                                      child: Text(
                                        "Clear",
                                        style: GoogleFonts.poppins(
                                            color: Hotels_Colours.veryDarkGrey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                                widget.staOne
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            starOne = !starOne;
                                            // arrivalthree
                                            //     ? arrivalthree = false
                                            //     : arrivalthree = true;
                                          });
                                        },
                                        child: Card(
                                          color: starOne
                                              ? Colors.blue
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Star",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.staTwo
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            starTwo = !starTwo;
                                            // arrivalthree
                                            //     ? arrivalthree = false
                                            //     : arrivalthree = true;
                                          });
                                        },
                                        child: Card(
                                          color: starTwo
                                              ? Colors.blue
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Stars",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.staThree
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            starThree = !starThree;
                                            // arrivalthree
                                            //     ? arrivalthree = false
                                            //     : arrivalthree = true;
                                          });
                                        },
                                        child: Card(
                                          color: starThree
                                              ? Colors.blue
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Stars",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.staFour
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            starFour = !starFour;
                                            // arrivalthree
                                            //     ? arrivalthree = false
                                            //     : arrivalthree = true;
                                          });
                                        },
                                        child: Card(
                                          color: starFour
                                              ? Colors.blue
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Stars",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                widget.staFive
                                    ? InkWell(
                                        onTap: () {
                                          setState(() {
                                            starFive = !starFive;
                                            // arrivalthree
                                            //     ? arrivalthree = false
                                            //     : arrivalthree = true;
                                          });
                                        },
                                        child: Card(
                                          color: starFive
                                              ? Colors.blue
                                              : Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const Icon(
                                                  Icons.star,
                                                  color: Colors.orange,
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Stars",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Colors.grey.shade400,
                          thickness: 1.2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: 40,
                            width: 100,
                            child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    updateFilterData();
                                    filterIcon = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Hotels_Colours.strongRed,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    )),
                                child: Text("Close",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500))),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  updateFilterData() {
    // hotelsData!.clear();
    setState(() {
      searchController.clear();
      hotelsData = widget.originalData!.where((hotel) {
        return (hotel.hotelNetPrice! >= _currentRangeValues.start &&
            hotel.hotelNetPrice! <= _currentRangeValues.end);
      }).toList();
      if (starOne) {
        hotelsData = widget.originalData!.where((hotel) {
          return (hotel.starRating! == 1 &&
              hotel.hotelNetPrice! >= _currentRangeValues.start &&
              hotel.hotelNetPrice! <= _currentRangeValues.end);
        }).toList();
      }
      if (starTwo) {
        hotelsData = widget.originalData!.where((hotel) {
          return (hotel.starRating! == 2 &&
              hotel.hotelNetPrice! >= _currentRangeValues.start &&
              hotel.hotelNetPrice! <= _currentRangeValues.end);
        }).toList();
      }
      if (starThree) {
        hotelsData = widget.originalData!.where((hotel) {
          return (hotel.starRating! == 3 &&
              hotel.hotelNetPrice! >= _currentRangeValues.start &&
              hotel.hotelNetPrice! <= _currentRangeValues.end);
        }).toList();
      }
      if (starFour) {
        hotelsData = widget.originalData!.where((hotel) {
          return (hotel.starRating! == 4 &&
              hotel.hotelNetPrice! >= _currentRangeValues.start &&
              hotel.hotelNetPrice! <= _currentRangeValues.end);
        }).toList();
      }
      if (starFive) {
        hotelsData = widget.originalData!.where((hotel) {
          return (hotel.starRating! == 5 &&
              hotel.hotelNetPrice! >= _currentRangeValues.start &&
              hotel.hotelNetPrice! <= _currentRangeValues.end);
        }).toList();
      }
    });
    removeDuplicatesfromList();

    print("data updated into hotelsData");
    print(_currentRangeValues.start);
    print(_currentRangeValues.end);
    print(hotelsData);
    inspect(hotelsData);
  }

  removeDuplicatesfromList() {
    setState(() {
      hotelsData!.toSet().toList();
    });
  }

  updateData() {
    setState(() {
      hotelsData = widget.originalData;
    });
  }

  // Function to filter hotels by name
  void filterHotelbyName(String name) {
    setState(() {
      filterName = name;
      // Use the 'where' method to
      // filter products by price
      hotelsData = widget.originalData!
          .where((product) => product.hotelName!
              .toLowerCase()
              .contains(filterName.toLowerCase()))
          .toList();
    });
  }
}
