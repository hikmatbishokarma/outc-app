import 'dart:io';
import 'package:country_picker/country_picker.dart' as CountryPicker;
import 'package:dotted_border/dotted_border.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/visa/models/get_visas_model.dart';
import 'package:outc/dashboard/visa/screens/country_list.dart';
import 'package:outc/dashboard/visa/widgets/colors.dart';
import 'package:outc/loginflow/privacypolicypage.dart';
import 'package:outc/loginflow/termsandconditionspage.dart';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart' as flutter;
import 'package:outc/widgets/sharedprefservices.dart';

class VisaFormPage extends StatefulWidget {
  final Datum visaData;
  const VisaFormPage({super.key, required this.visaData});

  @override
  State<VisaFormPage> createState() => _VisaFormPageState();
}

class _VisaFormPageState extends State<VisaFormPage> {
  bool isDropdownExpanded = false;

  TextEditingController searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  late List<Country> filteredCountryList = [];

  bool valuecheck = false;
  File? mediaidProof;
  File? mediaPassport;
  File? mediaPhoto;
  final ImagePicker pickeridProof = ImagePicker();
  final ImagePicker pickerPassport = ImagePicker();
  final ImagePicker pickerPhoto = ImagePicker();

  @override
  void initState() {
    super.initState();
    filteredCountryList = countryList;
    searchController = TextEditingController();
  }

  void filterList(String query) {
    setState(() {
      filteredCountryList = countryList
          .where(
              (country) => country.name.toString().contains(query.toString()))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    dateController.dispose();
    filteredCountryList.clear();
    super.dispose();
  }

  int _selectedCardCount = 1;

  String selectedValue = 'Mr';
  var adult = ['Mr', 'Mrs', 'Ms'];
  CountryPicker.Country selectedCountry = CountryPicker.Country(
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
  @override
  Widget build(BuildContext context) {
    print('Visa Name: ${widget.visaData.visaName}');

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
        automaticallyImplyLeading: false,
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
        child: Container(
          margin: const EdgeInsets.only(right: 10, left: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(
                //   height: 30,
                // ),
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
                    Text("Visa Form",
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

                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Visa Details',
                      style: GoogleFonts.poppins(
                          color: Visa_Colours.strongRed,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 5,
                ),
                Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  elevation: 3,
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10,
                                        left: 10,
                                        top: 15,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            color: const Color(0xff35459c))),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 15, left: 15),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ContentCard(
                                              title: 'Description ',
                                              content: widget
                                                  .visaData.visaDescription
                                                  .toString()),
                                          ContentCard(
                                              title: 'Type Of Visa ',
                                              content: widget
                                                  .visaData.typeofVisa
                                                  .toString()),
                                          ContentCard(
                                              title: 'Entry ',
                                              content: widget.visaData.entry
                                                  .toString()),
                                          ContentCard(
                                              title: 'Country  ',
                                              content: widget.visaData.country
                                                  .toString()),
                                          ContentCard(
                                              title: 'Processing Time Up to ',
                                              content:
                                                  '${widget.visaData.processingTime.toString()} Days'),
                                          ContentCard(
                                              title: 'Stay Period ',
                                              content:
                                                  '${widget.visaData.stayperiod.toString()} Months'),
                                          ContentCard(
                                              title: 'Visa Valid Up To ',
                                              content:
                                                  '${widget.visaData.validity.toString()} Months'),
                                          ContentCard(
                                              title: 'Best Time To Visit',
                                              content: widget
                                                      .visaData
                                                      .embassyDetails
                                                      ?.bestTimeToVisit ??
                                                  ''),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 0,
                                      left: 20,
                                      child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Container(
                                            height: 25,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
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
                                              child: Text(
                                                  widget.visaData.visaName
                                                      .toString(),
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                            ),
                                          )))
                                ]),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ])),
                ),

                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text('Passenger Details',
                      style: GoogleFonts.poppins(
                          color: Visa_Colours.strongRed,
                          fontSize: 16,
                          fontWeight: FontWeight.w500)),
                ),
                const SizedBox(
                  height: 5,
                ),
                //   Card(
                // color: Colors.white,  shadowColor: Colors.blue.shade50,
                // elevation: 5,
                // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                // child:Column(
                //   children: [
                Card(
                  color: Colors.white,
                  shadowColor: Colors.blue.shade50,
                  elevation: 3,
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
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
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
                                Text("Applying Visa For (Pax)",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              margin: const EdgeInsets.only(right: 100),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<int>(
                                  value: _selectedCardCount,
                                  hint: const Text(
                                    'Select No.of Pax\'s',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ),
                                  iconSize: 30,
                                  items: List.generate(
                                      5,
                                      (index) => DropdownMenuItem<int>(
                                            value: index + 1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15),
                                              child: Text(
                                                (index + 1).toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          )),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCardCount = value!;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Stack(children: [
                            Container(
                                margin: const EdgeInsets.only(
                                    right: 10, left: 10, top: 20, bottom: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: const Color(0xff35459c))),
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
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  10),
                                            ],
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.fromLTRB(
                                                      12, 5, 5, 5),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Color(0xffC2C2C2))),
                                              enabledBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Color(0xffC2C2C2))),
                                              focusedBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Color(0xffC2C2C2))),
                                              errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: const BorderSide(
                                                      color:
                                                          Color(0xffC2C2C2))),
                                              hintText:
                                                  'Enter your mobile number',
                                              hintStyle: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                              prefixIcon: Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        12, 10, 10, 5),
                                                child: InkWell(
                                                  onTap: () {
                                                    CountryPicker
                                                        .showCountryPicker(
                                                            context: context,
                                                            countryListTheme:
                                                                const CountryPicker
                                                                    .CountryListThemeData(
                                                                    bottomSheetHeight:
                                                                        600),
                                                            onSelect: (value) {
                                                              setState(() {
                                                                selectedCountry =
                                                                    value;
                                                              });
                                                            });
                                                  },
                                                  child: Text(
                                                      "${selectedCountry.flagEmoji}+${selectedCountry.phoneCode}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
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
                                    SizedBox(
                                      height: 40,
                                      width: double.infinity,
                                      child: TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                        textInputAction: TextInputAction.next,
                                        decoration: InputDecoration(
                                          hintText: "Enter your email",
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400),
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  12, 5, 5, 15),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                          errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              borderSide: const BorderSide(
                                                  color: Colors.grey)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                                )),
                            Positioned(
                                top: 5,
                                left: 15,
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
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
                                            left: 10, top: 1),
                                        child: Text("Contact Details ",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    )))
                          ]),
                          Column(
                              children: List.generate(
                                  _selectedCardCount,
                                  (index) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Stack(children: [
                                              Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color: Colors.white),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10,
                                                                  left: 10,
                                                                  top: 13,
                                                                  bottom: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: const Color(
                                                                      0xff35459c))),
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 10,
                                                                    left: 10,
                                                                    top: 10),
                                                            child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "*",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Title",
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
                                                                    width: double
                                                                        .infinity,
                                                                    child: Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          border:
                                                                              Border.all(color: const Color(0xffC2C2C2)),
                                                                        ),
                                                                        child: DropdownButtonHideUnderline(
                                                                            child: DropdownButton<String>(
                                                                          icon:
                                                                              const Icon(
                                                                            Icons.keyboard_arrow_down,
                                                                            color:
                                                                                Colors.grey,
                                                                            size:
                                                                                35,
                                                                          ),
                                                                          value:
                                                                              selectedValue,
                                                                          onChanged:
                                                                              (newValue) {
                                                                            setState(() {
                                                                              selectedValue = newValue!;
                                                                            });
                                                                          },
                                                                          items:
                                                                              adult.map((String items) {
                                                                            return DropdownMenuItem<String>(
                                                                                value: items,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Text(
                                                                                    items,
                                                                                    style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
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
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "First Name",
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
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            "Enter your first name",
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .grey.shade700,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        contentPadding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            12,
                                                                            5,
                                                                            5,
                                                                            15),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "*",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Last Name",
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
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .emailAddress,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            "Enter your last name",
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .grey.shade700,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        contentPadding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            12,
                                                                            5,
                                                                            5,
                                                                            15),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "*",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "DOB",
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
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      readOnly:
                                                                          true,
                                                                      controller:
                                                                          dateController,
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            "Pick your date of birth",
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .grey.shade700,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        contentPadding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            12,
                                                                            8,
                                                                            10,
                                                                            15),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                      ),
                                                                      onTap:
                                                                          () async {
                                                                        var date = await showDatePicker(
                                                                            context:
                                                                                context,
                                                                            initialDate:
                                                                                DateTime.now(),
                                                                            firstDate: DateTime(1900),
                                                                            lastDate: DateTime(2100));
                                                                        if (date !=
                                                                            null) {
                                                                          setState(
                                                                              () {});
                                                                          dateController.text =
                                                                              DateFormat('MM/dd/yyyy').format(date);
                                                                        }
                                                                      },
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "*",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Passport Number",
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
                                                                    width: double
                                                                        .infinity,
                                                                    child:
                                                                        TextFormField(
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .text,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      textInputAction:
                                                                          TextInputAction
                                                                              .next,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            "Enter your Passport number",
                                                                        hintStyle: TextStyle(
                                                                            color: Colors
                                                                                .grey.shade700,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.w400),
                                                                        contentPadding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            12,
                                                                            5,
                                                                            5,
                                                                            15),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        enabledBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        focusedBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                        errorBorder: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                            borderSide: const BorderSide(color: Colors.grey)),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      const Text(
                                                                        "*",
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                                15,
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                          "Nationality",
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
                                                                    child:
                                                                        TextFormField(
                                                                      controller:
                                                                          searchController,
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                      keyboardType:
                                                                          TextInputType
                                                                              .text,
                                                                      textAlignVertical:
                                                                          TextAlignVertical
                                                                              .center,
                                                                      decoration:
                                                                          InputDecoration(
                                                                        hintText:
                                                                            "Search Country",
                                                                        contentPadding: const EdgeInsets
                                                                            .fromLTRB(
                                                                            12,
                                                                            5,
                                                                            5,
                                                                            15),
                                                                        border:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              const BorderSide(color: Color(0xffC2C2C2)),
                                                                        ),
                                                                        enabledBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              const BorderSide(color: Color(0xffC2C2C2)),
                                                                        ),
                                                                        focusedBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              const BorderSide(color: Color(0xffC2C2C2)),
                                                                        ),
                                                                        errorBorder:
                                                                            OutlineInputBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(5),
                                                                          borderSide:
                                                                              const BorderSide(color: Color(0xffC2C2C2)),
                                                                        ),
                                                                      ),
                                                                      onTap:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          isDropdownExpanded =
                                                                              true;
                                                                        });
                                                                      },
                                                                      onChanged:
                                                                          (value) {
                                                                        filterList(
                                                                            value);
                                                                      },
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: isDropdownExpanded &&
                                                                        filteredCountryList
                                                                            .isNotEmpty,
                                                                    child: Card(
                                                                      elevation:
                                                                          5,
                                                                      color: Colors
                                                                          .white,
                                                                      child:
                                                                          SizedBox(
                                                                        height:
                                                                            170,
                                                                        width: double
                                                                            .infinity,
                                                                        child: ListView
                                                                            .builder(
                                                                          itemCount:
                                                                              filteredCountryList.length,
                                                                          itemBuilder:
                                                                              (context, index) {
                                                                            return ListTile(
                                                                              title: Text(
                                                                                filteredCountryList[index].name,
                                                                                style: const TextStyle(fontSize: 16),
                                                                              ),
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  searchController.text = filteredCountryList[index].name;
                                                                                  filteredCountryList.clear();
                                                                                  isDropdownExpanded = false;
                                                                                });
                                                                              },
                                                                            );
                                                                          },
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Id Proof",
                                                                          style: GoogleFonts.poppins(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600)),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      CircleAvatar(
                                                                        radius:
                                                                            8,
                                                                        backgroundColor:
                                                                            Visa_Colours.strongRed,
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              "i",
                                                                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),

                                                                  Card(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    elevation:
                                                                        0.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0x40303135),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          180,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          if (mediaidProof !=
                                                                              null)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: flutter.Image.file(
                                                                                mediaidProof!,
                                                                                fit: BoxFit.cover,
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                              ),
                                                                            ),
                                                                          if (mediaidProof ==
                                                                              null)
                                                                            Center(
                                                                              child: IconButton(
                                                                                onPressed: () {
                                                                                  imagePickeridProof();
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.add,
                                                                                  size: 30,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (mediaidProof !=
                                                                              null)
                                                                            Positioned(
                                                                              top: 5,
                                                                              right: 5,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  deleteImageIdProof();
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  radius: 15,
                                                                                  backgroundColor: Colors.white,
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  //
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Passport",
                                                                          style: GoogleFonts.poppins(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600)),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      CircleAvatar(
                                                                        radius:
                                                                            8,
                                                                        backgroundColor:
                                                                            Visa_Colours.strongRed,
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              "i",
                                                                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),

                                                                  Card(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    elevation:
                                                                        0.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0x40303135),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          180,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          if (mediaPassport !=
                                                                              null)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: flutter.Image.file(
                                                                                mediaPassport!,
                                                                                fit: BoxFit.cover,
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                              ),
                                                                            ),
                                                                          if (mediaPassport ==
                                                                              null)
                                                                            Center(
                                                                              child: IconButton(
                                                                                onPressed: () {
                                                                                  imagePickerPassport();
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.add,
                                                                                  size: 30,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (mediaPassport !=
                                                                              null)
                                                                            Positioned(
                                                                              top: 5,
                                                                              right: 5,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  deleteImagePassport();
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  radius: 15,
                                                                                  backgroundColor: Colors.white,
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),

                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),

                                                                  Row(
                                                                    children: [
                                                                      Text(
                                                                          "Photo Copy",
                                                                          style: GoogleFonts.poppins(
                                                                              color: Colors.black,
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w600)),
                                                                      const SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      CircleAvatar(
                                                                        radius:
                                                                            8,
                                                                        backgroundColor:
                                                                            Visa_Colours.strongRed,
                                                                        child:
                                                                            Center(
                                                                          child: Text(
                                                                              "i",
                                                                              style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 5,
                                                                  ),

                                                                  Card(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade200,
                                                                    elevation:
                                                                        0.0,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      side:
                                                                          const BorderSide(
                                                                        color: Color(
                                                                            0x40303135),
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                    ),
                                                                    child:
                                                                        Container(
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          180,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .shade200,
                                                                        borderRadius:
                                                                            const BorderRadius.all(
                                                                          Radius.circular(
                                                                              10.0),
                                                                        ),
                                                                      ),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          if (mediaPhoto !=
                                                                              null)
                                                                            ClipRRect(
                                                                              borderRadius: BorderRadius.circular(10),
                                                                              child: flutter.Image.file(
                                                                                mediaPhoto!,
                                                                                fit: BoxFit.cover,
                                                                                width: double.infinity,
                                                                                height: double.infinity,
                                                                              ),
                                                                            ),
                                                                          if (mediaPhoto ==
                                                                              null)
                                                                            Center(
                                                                              child: IconButton(
                                                                                onPressed: () {
                                                                                  imagePickerphoto();
                                                                                },
                                                                                icon: const Icon(
                                                                                  Icons.add,
                                                                                  size: 30,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          if (mediaPhoto !=
                                                                              null)
                                                                            Positioned(
                                                                              top: 5,
                                                                              right: 5,
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  deleteImagePhoto();
                                                                                },
                                                                                child: const CircleAvatar(
                                                                                  radius: 15,
                                                                                  backgroundColor: Colors.white,
                                                                                  child: Icon(
                                                                                    Icons.delete,
                                                                                    color: Colors.black,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                ]),
                                                          )),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  )),
                                              Positioned(
                                                  top: 0,
                                                  left: 15,
                                                  child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                            BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            5),
                                                                gradient:
                                                                    const LinearGradient(
                                                                  colors: [
                                                                    Color(
                                                                        0xffbd0c21),
                                                                    Color(
                                                                        0xff35459c)
                                                                  ],
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                )),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  left: 10,
                                                                  top: 1),
                                                          child: Text(
                                                              "Passenger(${index + 1})  ",
                                                              style: GoogleFonts.poppins(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500)),
                                                        ),
                                                      )))
                                            ]),
                                            const SizedBox(
                                              height: 0,
                                            ),
                                          ]))),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Card(
                              color: Visa_Colours.dardModerateBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Visa_Colours.dardModerateBlue),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      right: 5, left: 5, top: 0, bottom: 0),
                                  child: Text(
                                    ' Note ',
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Text(
                              'Please Upload Original Scanned Color Copies of Each Document Mentioned Above.',
                              style: GoogleFonts.poppins(
                                color: Visa_Colours.strongRed,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                        ]),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),
                Card(
                    color: Colors.white,
                    shadowColor: Colors.blue.shade50,
                    elevation: 3,
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
                                height: 5,
                              ),
                              Stack(children: [
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 15, left: 15, top: 15, bottom: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: const Color(0xff35459c))),
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Base Fee",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Row(
                                              children: [
                                                Text(
                                                    "INR ${widget.visaData.fees}",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                const SizedBox(width: 3),
                                                Text("x",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                                const SizedBox(width: 3),
                                                Text("$_selectedCardCount",
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Grand Total :",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            Text(
                                                "INR ${widget.visaData.fees! * _selectedCardCount}",
                                                style: GoogleFonts.poppins(
                                                    color: Visa_Colours
                                                        .dardModerateBlue,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Text("Apply Promo",
                                            style: GoogleFonts.poppins(
                                                color: Visa_Colours.strongRed,
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
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Enter Your Promo code",
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade500,
                                                      fontSize: 15),
                                                  contentPadding:
                                                      const EdgeInsets.fromLTRB(
                                                          12, 5, 10, 0),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffC2C2C2))),
                                                  enabledBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffC2C2C2))),
                                                  focusedBorder: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      borderSide:
                                                          const BorderSide(
                                                              color: Color(
                                                                  0xffC2C2C2))),
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
                                                  backgroundColor:
                                                      Visa_Colours.strongRed,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))),
                                              child: Text("APPLY",
                                                  style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)))
                                        ]),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        DottedBorder(
                                            color: Colors.green,
                                            strokeWidth: 1.5,
                                            dashPattern: const [3, 3],
                                            child: const SizedBox(
                                                height: 30,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 3, top: 5),
                                                  child: Text(
                                                    "No Promo Code Available ",
                                                    style: TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.green),
                                                  ),
                                                ))),
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
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
                                            child: Text(" Fare Details ",
                                                style: GoogleFonts.poppins(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ),
                                        )))
                              ]),
                            ]))),

                Row(
                  children: [
                    Checkbox(
                      value: valuecheck,
                      side: BorderSide(color: Colors.grey.shade400, width: 1.5),
                      checkColor: Colors.white,
                      activeColor:
                          valuecheck ? Visa_Colours.strongRed : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3)),
                      onChanged: (value) {
                        setState(() {
                          valuecheck = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: RichText(
                          text: TextSpan(
                            text: 'I agree with ',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontFamily: 'poppins',
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                            children: [
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const TermsandConditions();
                                      },
                                    ));
                                  },
                                text: 'Terms & conditions ',
                                style: TextStyle(
                                  color: Visa_Colours.strongRed,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              const TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                              TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) {
                                        return const PrivacyPolicy();
                                      },
                                    ));
                                  },
                                text: 'Privacy Policy',
                                style: TextStyle(
                                  fontSize: 15,
                                  decoration: TextDecoration.none,
                                  color: Visa_Colours.strongRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                const SizedBox(
                  height: 15,
                ),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {},
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Visa_Colours.dardModerateBlue,
                            Colors.lightBlue
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Container(
                        constraints: const BoxConstraints(
                            maxWidth: double.infinity, minHeight: 50),
                        alignment: Alignment.center,
                        child: Text('Continue to Book',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void imagePickeridProof() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromCameraidProof();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.camera),
                        Text(
                          "Camera",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromGalleryidProof();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.photo),
                        Text(
                          "Gallery",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void imagePickerPassport() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromCameraPassport();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.camera),
                        Text(
                          "Camera",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromGalleryPassport();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.photo),
                        Text(
                          "Gallery",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void imagePickerphoto() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Container(
            height: 80,
            width: double.infinity,
            decoration: const BoxDecoration(),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromCameraPhoto();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.camera),
                        Text(
                          "Camera",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      pickImageFromGalleryPhoto();
                    },
                    child: Column(
                      children: [
                        const Icon(Icons.photo),
                        Text(
                          "Gallery",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteImageIdProof() {
    setState(() {
      mediaidProof = null;
    });
  }

  void deleteImagePassport() {
    setState(() {
      mediaPassport = null;
    });
  }

  void deleteImagePhoto() {
    setState(() {
      mediaPhoto = null;
    });
  }

  void pickImageFromGalleryidProof() async {
    final XFile? image =
        await pickeridProof.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      mediaidProof = File(image.path);
    });
  }

  void pickImageFromGalleryPassport() async {
    final XFile? image =
        await pickerPassport.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      mediaPassport = File(image.path);
    });
  }

  void pickImageFromGalleryPhoto() async {
    final XFile? image =
        await pickerPhoto.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() {
      mediaPhoto = File(image.path);
    });
  }

  void pickImageFromCameraidProof() async {
    final XFile? photo =
        await pickeridProof.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() {
      mediaidProof = File(photo.path);
    });
  }

  void pickImageFromCameraPassport() async {
    final XFile? photo =
        await pickerPassport.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() {
      mediaPassport = File(photo.path);
    });
  }

  void pickImageFromCameraPhoto() async {
    final XFile? photo =
        await pickerPhoto.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() {
      mediaPhoto = File(photo.path);
    });
  }
}

class ContentCard extends StatelessWidget {
  final String title;
  final String content;

  const ContentCard({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            color: Visa_Colours.strongRed,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          content,
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          // maxLines: 10,
          // overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(
          height: 5,
        )
      ],
    );
  }
}

// GestureDetector(
//   onTap: () {
//     setState(() {
//       isDropdownExpanded = !isDropdownExpanded;
//     });
//   },
//   child: Container(
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(5),
//       border: Border.all(color: Colors.grey),
//     ),
//     height: 40,
//     width: double.infinity,
//     child: Container(
//       margin: EdgeInsets.only(left: 5,right: 5),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [

//           Text(
//             selectedGender ?? 'Select your gender',
//             style: TextStyle(
//               color: selectedGender == null ? Colors.grey.shade600 : Colors.black,
//               fontSize: 16,
//               fontWeight: FontWeight.w400,
//             ),
//           ),
//           const Icon(Icons.arrow_drop_down_rounded,color: Colors.black,size: 40,)
//         ],
//       ),
//     ),
//   ),
// ),
// const SizedBox(height: 10,),
// if (isDropdownExpanded)
//   Card(
//     margin: EdgeInsets.symmetric(vertical: 4),
//     child: Column(
//       children: genders.map((String value) {
//         return GestureDetector(
//           onTap: () {
//             setState(() {
//               selectedGender = value;
//               isDropdownExpanded = false;
//             });
//           },
//           child: ListTile(
//             title: Text(value),
//           ),
//         );
//       }).toList(),
//     ),
//   ),
