import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:http/http.dart' as http;
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SelectCity extends StatefulWidget {
  String type;
  SelectCity({super.key, required this.type});

  @override
  State<SelectCity> createState() => _SelectCityState();
}

class _SelectCityState extends State<SelectCity> {
  late List<Datum> airportList;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    airportList = []; // Initialize the list
    // searchController = TextEditingController(text: "bom");
    searchController = TextEditingController();

    // Fetch data from the backend and update the list
    fetchDataFromBackend(searchController.text.trim().toString()).then((data) {
      setState(() {
        airportList = data;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  void filterList(String query) {
    fetchDataFromBackend(searchController.text.trim().toString()).then((data) {
      setState(() {
        airportList = data;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Search City",
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
              color: Colors.black,
              fontFamily: 'poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ))),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Colors.black,
            size: 22,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w700,
                ),
                controller: searchController,
                onChanged: filterList,
                decoration: InputDecoration(
                  labelText: 'Origin Airport',
                  labelStyle: TextStyle(
                    // fontSize: 14.0,
                    color: Flights_Colours.strongRed,
                    fontFamily: 'Helvetica Neue',
                    // fontWeight: FontWeight.w700,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Flights_Colours.strongRed),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Flights_Colours.strongRed)),
                ),
              ),
            ),
            Visibility(
              visible: airportList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: airportList.length,
                  itemBuilder: (context, index) {
                    final airport = airportList[index];
                    return ListTile(
                      title: Text('${airport.city!}, ${airport.country}',
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          )),
                      onTap: () {
                        setState(() async {
                          searchController.text =
                              '${airport.city!}, ${airport.country}';

                          if (widget.type == "one") {
                            await SharedPrefServices.setcityFrom(airport.city!);
                            await SharedPrefServices.setairportcodeFrom(
                                airport.airportCode!);
                            await SharedPrefServices.setcountryFrom(
                                airport.country!);
                          } else if (widget.type == "two") {
                            await SharedPrefServices.setcityFromTwo(
                                airport.city!);
                            await SharedPrefServices.setairportcodeFromTwo(
                                airport.airportCode!);
                            await SharedPrefServices.setcountryFromTwo(
                                airport.country!);
                          }

                          // await SharedPrefServices.setcityFrom(airport.city!);
                          // await SharedPrefServices.setairportcodeFrom(
                          //     airport.airportCode!);
                          // await SharedPrefServices.setcountryFrom(
                          //     airport.country!);
                          airportList.clear();

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return const FlightsListPage();
                              },
                            ),
                          );
                        });
                      },
                      subtitle: Text(airport.displayName!,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                            fontFamily: 'Poppins',
                          )),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Datum>> fetchDataFromBackend(String countrycode) async {
    var url = Uri.parse(
        'https://outc.in/api/v1/flights/updatedAirPort/search/$countrycode');
    final response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      return jsonData.map((item) => Datum.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load data from the backend');
    }
  }
}
