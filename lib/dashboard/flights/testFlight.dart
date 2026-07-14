import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/flights/models/airport_info_model.dart';
import 'package:outc/dashboard/flights/models/dropdownlist.dart';
import 'package:outc/dashboard/flights/models/get_cities_by_search_model.dart';
import 'package:outc/dashboard/flights/models/topcities_static.dart';
import 'package:outc/dashboard/flights/providers/searchlist_provider.dart';
import 'package:outc/services/api_services_list.dart';
import 'package:outc/widgets/components/printlocal.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart' as provider;

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({super.key});

  @override
  _FlightSearchPageState createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  CitiesRequestmodel? requestModel;
  final emailController = TextEditingController();
  late List<Datum> airportList;
  late TextEditingController searchController;

  String zipcodeinput = "";
  bool isApiCallProcess = false;
  final List _locations = topCities;
  String? _selectedLocation;

  @override
  void initState() {
    super.initState();

    emailController.addListener(onListen);
    airportList = []; // Initialize the list
    searchController = TextEditingController(text: "del");

    // Fetch data from the backend and update the list
    fetchDataFromBackend(searchController.text.trim().toString()).then((data) {
      setState(() {
        airportList = data;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();

    emailController.removeListener(onListen);
    searchController.dispose();

    super.dispose();
  }

  void onListen() => setState(() {});
  void filterList(String query) {
    // final filteredList = airportList.where((airport) {
    //   return airport.displayName!.toLowerCase().contains(query.toLowerCase());
    // }).toList();

    fetchDataFromBackend(searchController.text.trim().toString()).then((data) {
      setState(() {
        airportList = data;
      });
    });

    // setState(() {
    //   airportList = filteredList;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: RichText(
          text: TextSpan(
              style: const TextStyle(color: Colors.black, fontSize: 32),
              children: [
                TextSpan(
                    text: 'Flight',
                    style: GoogleFonts.overpass(fontWeight: FontWeight.w200)),
                TextSpan(
                    text: 'Search',
                    style: GoogleFonts.overpass(fontWeight: FontWeight.bold)),
              ]),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterList,
                decoration: const InputDecoration(
                  labelText: 'Search Airports',
                  border: OutlineInputBorder(),
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
                      // title: Text(airport.displayName),
                      onTap: () {
                        setState(() {
                          searchController.text =
                              '${airport.city!}, ${airport.country}';
                          airportList.clear();
                        });
                      },
                      subtitle: Text('${airport.city!}, ${airport.country}'),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: searchController,
                onChanged: filterList,
                decoration: const InputDecoration(
                  labelText: 'Search Airports',
                  border: OutlineInputBorder(),
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
                      // title: Text(airport.displayName),
                      onTap: () {
                        setState(() {
                          searchController.text =
                              '${airport.city!}, ${airport.country}';
                          airportList.clear();
                        });
                      },
                      subtitle: Text('${airport.city!}, ${airport.country}'),
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
