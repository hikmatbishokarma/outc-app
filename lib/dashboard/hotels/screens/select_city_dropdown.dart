import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:outc/dashboard/flights/screens/search_flights.dart';
import 'package:outc/dashboard/hotels/models/get_cities_model.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SelectHotelCityDropdown extends StatefulWidget {
  ListModelHotels payloadData;
  SelectHotelCityDropdown({super.key, required this.payloadData});

  @override
  State<SelectHotelCityDropdown> createState() =>
      _SelectHotelCityDropdownState();
}

class _SelectHotelCityDropdownState extends State<SelectHotelCityDropdown> {
  late List<Datum> hotel_citiesList;
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();

    hotel_citiesList = []; // Initialize the list
    searchController = TextEditingController(text: "");

    // Fetch data from the backend and update the list
    fetchDataFromBackend(searchController.text.trim().toString()).then((data) {
      setState(() {
        hotel_citiesList = data;
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
        hotel_citiesList = data;
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
                  labelText: 'Enter City Name',
                  labelStyle: TextStyle(
                    // fontSize: 14.0,
                    color: Hotels_Colours.strongRed,
                    fontFamily: 'Helvetica Neue',
                    // fontWeight: FontWeight.w700,
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
            Visibility(
              visible: hotel_citiesList.isNotEmpty,
              child: Expanded(
                child: ListView.builder(
                  itemCount: hotel_citiesList.length,
                  itemBuilder: (context, index) {
                    final cityObj = hotel_citiesList[index];
                    return ListTile(
                      title: Text(cityObj.cityName!,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          )),
                      onTap: () {
                        setState(() async {
                          searchController.text =
                              '${cityObj.cityName!}, ${cityObj.country}';

                          await SharedPrefServices.setcityId(cityObj.cityId!);
                          await SharedPrefServices.setcityName(
                              cityObj.cityName!);
                          await SharedPrefServices.setcountryCode(
                              cityObj.countryCode!);
                          hotel_citiesList.clear();

                          widget.payloadData.countryCode = cityObj.countryCode!;
                          widget.payloadData.hotelCityCode =
                              cityObj.cityId!.toString();
                          widget.payloadData.hotelCityName = cityObj.cityName!;
                          widget.payloadData.isHotelDescriptionRequried = false;
                          widget.payloadData.membership = 0;
                          widget.payloadData.roleType = 0;
                          widget.payloadData.userId = 0;
                          // ListModelHotels listModelHotels = ListModelHotels(
                          //     checkInDate: "",
                          //     checkOutDate: "",
                          //     countryCode: city_obj.countryCode!,
                          //     currency: "",
                          //     hotelCityCode: city_obj.cityId!.toString(),
                          //     hotelCityName: city_obj.cityName!,
                          //     isHotelDescriptionRequried: false,
                          //     membership: 0,
                          //     nationality: "",
                          //     roleType: 0,
                          //     roomGuests: [],
                          //     userId: 0);

                          print("cityId ${SharedPrefServices.getcityId()}");
                          print("cityName ${SharedPrefServices.getcityName()}");
                          print(
                              "countryCode ${SharedPrefServices.getcountryCode()}");
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return HotelSearchPage(
                                  payloadData: widget.payloadData,
                                );
                              },
                            ),
                          );
                        });
                      },
                      subtitle: Text(cityObj.fullName!,
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

  Future<List<Datum>> fetchDataFromBackend(String city) async {
    var url = Uri.parse(
        'http://anjmal.i2space.in/api/v1/hotels-v2/searchhotelcity/$city');
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
