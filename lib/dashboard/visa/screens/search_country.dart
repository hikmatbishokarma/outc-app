import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:outc/dashboard/dashboard.dart';

import 'package:outc/dashboard/visa/models/get_visas_model.dart';
import 'package:outc/dashboard/visa/screens/country_list.dart';
import 'package:outc/dashboard/visa/screens/visa_getLists.dart';
import 'package:outc/dashboard/visa/screens/visa_guidelinespage.dart';
import 'package:outc/dashboard/visa/widgets/colors.dart';
import 'package:outc/dashboard/visa/widgets/progress_bar.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class SearchCountry extends StatefulWidget {
  const SearchCountry({super.key});

  @override
  State<SearchCountry> createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Visa_Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        leading: Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              color: Visa_Colours.strongRed,
              icon: Icon(
                Icons.home,
                size: 28,
                color: Visa_Colours.strongRed,
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
              color: Visa_Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Visa_Colours.strongRed,
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
                                  color: Visa_Colours.strongRed,
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
            color: Visa_Colours.strongRed,
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
        child: Stack(children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 15),
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
                    Text("Search Visa",
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
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const VisaGuidelinesPage();
                        },
                      ),
                    );
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Visa Guidelines',
                      style: GoogleFonts.poppins(
                        color: Visa_Colours.strongRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    'We make visas easy for you ',
                    style: GoogleFonts.poppins(
                      color: Visa_Colours.dardModerateBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
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
                          color: Visa_Colours.strongRed,
                          fontFamily: 'Helvetica Neue',
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Visa_Colours.strongRed),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Visa_Colours.strongRed)),
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
                          setState(() {
                            isLoading = true;
                          });
                          searchController.text = country.name;

                          List<Datum> visaData =
                              await fetchDataFromBackend(country.name);
                          setState(() {
                            isLoading = false;
                          });

                          if (visaData.isNotEmpty) {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) {
                                  return VisaLists(visaData: visaData);
                                },
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'No Visas Available for ${country.name}'),
                              ),
                            );
                          }
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
          if (isLoading)
            const Center(
              child: Visa_ProgressBarHUD(),
            ),
        ]),
      ),
    );
  }

  Future<List<Datum>> fetchDataFromBackend(String countryname) async {
    var url = Uri.parse(
        'http://anjmal.i2space.in/api/v1/visa/visaSearch/$countryname');

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
