import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/hotels/models/hotels_search_payload.dart';
import 'package:outc/dashboard/hotels/screens/search_hotel.dart';
import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/dashboard/visa/screens/country_list.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SelectCountry extends StatefulWidget {
  ListModelHotels payloadData;
  SelectCountry({super.key, required this.payloadData});

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  late List<Country> filteredCountryList;
  late TextEditingController searchController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    filteredCountryList = countryList;
    searchController = TextEditingController();
  }

  void filterList(String query) {
    setState(() {
      filteredCountryList = countryList
          .where((country) => country.name
              .toString()
              .toLowerCase()
              .contains(query.toString().toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text("Search Country",
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
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
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
                    labelText: 'Search For A Country',
                    labelStyle: TextStyle(
                        color: Hotels_Colours.strongRed,
                        fontFamily: 'Helvetica Neue',
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Hotels_Colours.strongRed),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Hotels_Colours.strongRed)),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredCountryList.length,
                  itemBuilder: (context, index) {
                    final country = filteredCountryList[index];
                    return ListTile(
                      onTap: () async {
                        searchController.text = country.name;
                        SharedPrefServices.setnationality(
                            "${country.name} ${country.code}");
                        widget.payloadData.nationality = country.code;
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return HotelSearchPage(
                                payloadData: widget.payloadData,
                              );
                            },
                          ),
                        );
                      },
                      title: Text(
                        country.name,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      // subtitle: Text(
                      //   'Dial Code: ${country.dialCode}',
                      //   style: const TextStyle(
                      //     fontSize: 12.0,
                      //     color: Colors.grey,
                      //     fontFamily: 'Poppins',
                      //   ),
                      // ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
