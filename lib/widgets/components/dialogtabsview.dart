import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flight_roundtrip_model.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/components.dart';
import 'package:outc/dashboard/flights/models/flight_domestic_roundtrip_model.dart'
    as domestic_response;

import '../../dashboard/flights/models/flights_list_model.dart';

class TabviewDialog extends StatefulWidget {
  List<FlightDetail>? flightsdata;
  int index;

  TabviewDialog({super.key, required this.flightsdata, required this.index});

  @override
  State<TabviewDialog> createState() => _TabviewDialogState();
}

class _TabviewDialogState extends State<TabviewDialog> {
  @override
  Widget build(BuildContext context) {
    String stops = widget.flightsdata![widget.index].flightSegments!.length == 1
        ? "Direct"
        : "${widget.flightsdata![widget.index].flightSegments!.length - 1} stops";
    return Dialog(
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Sector",
                      style: textStyleHeading(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Fare Rules",
                      style: textStyleHeading(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200, // Height of the TabBarView
                child: TabBarView(
                  children: [
                    // Content for Tab 1
                    Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      // ${widget.flightsdata![index].origin} - ${widget.flightsdata![index].destination}
                                      widget.flightsdata![widget.index].origin
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .flightsdata![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .flightsdata![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Divider(
                                    color: Colours.veryDarkGrey,
                                    thickness: 1.0,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.flightsdata![widget.index]
                                          .destination
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .flightsdata![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .flightsdata![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Trip Duration :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "${widget.flightsdata![widget.index].flightSegments![0].duration} | " +
                                      stops,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Class :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Economy",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Coupon Type :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Publish",
                                  style: TextStyle(
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
                    ),
                    // Content for Tab 2
                    Container(
                      child: const Center(
                        child: Text('No data found'),
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
}

// multi and round flight

class MultiTabView extends StatefulWidget {
  List<DataFlightDetail>? dataFlightDetails;
  int index;

  MultiTabView(
      {super.key, required this.dataFlightDetails, required this.index});

  @override
  State<MultiTabView> createState() => _MultiTabViewState();
}

class _MultiTabViewState extends State<MultiTabView> {
  @override
  Widget build(BuildContext context) {
    String stops = widget.dataFlightDetails![widget.index].flightDetails![1]
                .flightSegments!.length ==
            1
        ? "Direct"
        : "${widget.dataFlightDetails![widget.index].flightDetails![1].flightSegments!.length - 1} stops";
    return Dialog(
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Sector",
                      style: textStyleHeading(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Fare Rules",
                      style: textStyleHeading(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200, // Height of the TabBarView
                child: TabBarView(
                  children: [
                    // Content for Tab 1
                    Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      // ${widget.flightsdata![index].origin} - ${widget.flightsdata![index].destination}

                                      widget.dataFlightDetails![widget.index]
                                          .flightDetails![1].origin
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightDetails![1]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightDetails![1]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Divider(
                                    color: Colours.veryDarkGrey,
                                    thickness: 1.0,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.dataFlightDetails![widget.index]
                                          .flightDetails![1].destination
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightDetails![1]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightDetails![1]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Trip Duration :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "${widget.dataFlightDetails![widget.index].flightDetails![1].flightSegments![0].duration} | " +
                                      stops,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Class :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Economy",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Coupon Type :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Publish",
                                  style: TextStyle(
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
                    ),
                    // Content for Tab 2
                    Container(
                      child: const Center(
                        child: Text('No data found'),
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
}
// Domestic rould trip

class MultiDomesticTabView extends StatefulWidget {
  List<domestic_response.FlightDetail>? dataFlightDetails;
  int index;

  MultiDomesticTabView(
      {super.key, required this.dataFlightDetails, required this.index});

  @override
  State<MultiDomesticTabView> createState() => _MultiDomesticTabViewState();
}

class _MultiDomesticTabViewState extends State<MultiDomesticTabView> {
  @override
  Widget build(BuildContext context) {
    String stops = widget
                .dataFlightDetails![widget.index].flightSegments!.length ==
            1
        ? "Direct"
        : "${widget.dataFlightDetails![widget.index].flightSegments!.length - 1} stops";
    return Dialog(
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Sector",
                      style: textStyleHeading(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Fare Rules",
                      style: textStyleHeading(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200, // Height of the TabBarView
                child: TabBarView(
                  children: [
                    // Content for Tab 1
                    Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      // ${widget.flightsdata![index].origin} - ${widget.flightsdata![index].destination}

                                      widget.dataFlightDetails![widget.index]
                                          .origin
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Divider(
                                    color: Colours.veryDarkGrey,
                                    thickness: 1.0,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.dataFlightDetails![widget.index]
                                          .destination
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .dataFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Trip Duration :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "${widget.dataFlightDetails![widget.index].flightSegments![0].duration} | " +
                                      stops,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Class :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Economy",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Coupon Type :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Publish",
                                  style: TextStyle(
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
                    ),
                    // Content for Tab 2
                    Container(
                      child: const Center(
                        child: Text('No data found'),
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
}

// return flight
class ReturnFlight extends StatefulWidget {
  List<domestic_response.FlightDetail>? returnFlightDetails;
  int index;

  ReturnFlight(
      {super.key, required this.returnFlightDetails, required this.index});

  @override
  State<ReturnFlight> createState() => _ReturnFlightState();
}

class _ReturnFlightState extends State<ReturnFlight> {
  @override
  Widget build(BuildContext context) {
    String stops = widget
                .returnFlightDetails![widget.index].flightSegments!.length ==
            1
        ? "Direct"
        : "${widget.returnFlightDetails![widget.index].flightSegments!.length - 1} stops";
    return Dialog(
      child: DefaultTabController(
        length: 2, // Number of tabs
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TabBar(
                tabs: [
                  Tab(
                    child: Text(
                      "Sector",
                      style: textStyleHeading(),
                    ),
                  ),
                  Tab(
                    child: Text(
                      "Fare Rules",
                      style: textStyleHeading(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 200, // Height of the TabBarView
                child: TabBarView(
                  children: [
                    // Content for Tab 1
                    Container(
                      color: Colors.grey[100],
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      // ${widget.flightsdata![index].origin} - ${widget.flightsdata![index].destination}

                                      widget.returnFlightDetails![widget.index]
                                          .origin
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .returnFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .returnFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .departureDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 30,
                                  child: Divider(
                                    color: Colours.veryDarkGrey,
                                    thickness: 1.0,
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      widget.returnFlightDetails![widget.index]
                                          .destination
                                          .toString(),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('hh:mm').format(widget
                                          .returnFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    Text(
                                      DateFormat('MM-dd-yyyy').format(widget
                                          .returnFlightDetails![widget.index]
                                          .flightSegments![0]
                                          .arrivalDateTime!),
                                      style: const TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Trip Duration :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  // ignore: prefer_interpolation_to_compose_strings
                                  "${widget.returnFlightDetails![widget.index].flightSegments![0].duration} | " +
                                      stops,
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Class :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Economy",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Coupon Type :",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.grey[500],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Publish",
                                  style: TextStyle(
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
                    ),
                    // Content for Tab 2
                    Container(
                      child: const Center(
                        child: Text('No data found'),
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
}
