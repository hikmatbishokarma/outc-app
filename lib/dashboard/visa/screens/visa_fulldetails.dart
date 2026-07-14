import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;

import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/visa/models/get_visas_model.dart';
import 'package:outc/dashboard/visa/screens/visa_formpage.dart';
import 'package:outc/dashboard/visa/widgets/colors.dart';

import 'package:outc/widgets/sharedprefservices.dart';

class VisaFullDetails extends StatefulWidget {
  final Datum visaData;

  const VisaFullDetails({super.key, required this.visaData});

  @override
  State<VisaFullDetails> createState() => _VisaFullDetailsState();
}

class _VisaFullDetailsState extends State<VisaFullDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const SizedBox(height: 30,),
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
                    Text("Visa Details",
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

                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: flutter.Image.network(
                      'https://www.mypunepulse.com/wp-content/uploads/2023/10/WhatsApp-Image-2023-10-16-at-4.42.41-PM.jpeg',
                      fit: BoxFit.cover,
                      height: 180,
                      width: double.infinity,
                    )),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'Visa Info',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                Container(
                  margin: const EdgeInsets.only(left: 5, right: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentCard(
                          title: 'Visa Name ',
                          content: widget.visaData.visaName.toString()),
                      ContentCard(
                          title: 'Description ',
                          content: widget.visaData.visaDescription.toString()),
                      ContentCard(
                          title: 'Type Of Visa ',
                          content: widget.visaData.typeofVisa.toString()),
                      ContentCard(
                          title: 'Entry ',
                          content: widget.visaData.entry.toString()),
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
                          title: 'Country ',
                          content: widget.visaData.country.toString()),
                      ContentCard(
                          title: 'Fare ',
                          content: 'INR ${widget.visaData.fees.toString()}'),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'OverView',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 0),
                  child: Text(
                    widget.visaData.overView
                        .toString()
                        .replaceAll(RegExp(r'<[/]*[a-zA-Z]+>'), ''),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'Why Choose Us ?',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 0),
                  child: Text(
                    widget.visaData.whychooseUs
                        .toString()
                        .replaceAll(RegExp(r'<[/]*[a-zA-Z]+>'), ''),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'How We can Help ?',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 5, right: 0),
                  child: Text(
                    widget.visaData.howWeCanHelp
                        .toString()
                        .replaceAll(RegExp(r'<[/]*[a-zA-Z]+>'), ''),
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'Documents Requried For Visa',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 5, right: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.visaData.docsReqForVisa!.map((doc) {
                      print('Essential Document: ${doc.essentialsDocs}');
                      print('Other Document: ${doc.otherDocs}');

                      String essentialDocsString = (doc.essentialsDocs ?? '')
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .replaceAll('"', '');
                      List<String> essentialDocsList =
                          essentialDocsString.split(',');

                      String otherDocsString = (doc.otherDocs ?? '')
                          .replaceAll(RegExp(r'<[/]*[a-zA-Z]+>'), '');
                      List<String> otherDocsList = otherDocsString.split('\n');

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Essential Documents',
                            style: GoogleFonts.poppins(
                              color: Visa_Colours.strongRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...essentialDocsList.map((item) => Text(
                                item.trim(),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(height: 5),
                          Text(
                            'Other Documents',
                            style: GoogleFonts.poppins(
                              color: Visa_Colours.strongRed,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ...otherDocsList.map((item) => Text(
                                item.trim(),
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'Embassy Details',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                Container(
                  margin: const EdgeInsets.only(right: 0, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentCard(
                          title: 'Country ',
                          content: widget.visaData.country.toString()),
                      ContentCard(
                          title: 'Major City',
                          content:
                              widget.visaData.embassyDetails?.majorCity ?? ''),
                      ContentCard(
                          title: 'International Airports',
                          content: widget.visaData.embassyDetails
                                  ?.internationalAirport ??
                              ''),
                      ContentCard(
                          title: 'Main Airline',
                          content:
                              widget.visaData.embassyDetails?.mainAirline ??
                                  ''),
                      ContentCard(
                          title: 'Prefered Language',
                          content:
                              widget.visaData.embassyDetails?.language ?? ''),
                      ContentCard(
                          title: 'Best Time To Visit',
                          content:
                              widget.visaData.embassyDetails?.bestTimeToVisit ??
                                  ''),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Embassy Address 1',
                    style: GoogleFonts.poppins(
                        color: Visa_Colours.dardModerateBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentCard(
                          title: 'Address ',
                          content:
                              widget.visaData.embassyDetails?.embassyAddress ??
                                  ''),
                      ContentCard(
                          title: 'Contact',
                          content:
                              widget.visaData.embassyDetails?.embassyContact ??
                                  ''),
                      ContentCard(
                          title: 'Email',
                          content:
                              widget.visaData.embassyDetails?.embassyEmail ??
                                  ''),
                      ContentCard(
                          title: 'Website Url',
                          content:
                              widget.visaData.embassyDetails?.embassyUrl ?? ''),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Embassy Address 2',
                    style: GoogleFonts.poppins(
                        color: Visa_Colours.dardModerateBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentCard(
                          title: 'Address ',
                          content:
                              widget.visaData.embassyDetails?.embassyAddress2 ??
                                  ''),
                      ContentCard(
                          title: 'Contact',
                          content:
                              widget.visaData.embassyDetails?.embassyContact2 ??
                                  ''),
                      ContentCard(
                          title: 'Email',
                          content:
                              widget.visaData.embassyDetails?.embassyEmail2 ??
                                  ''),
                      ContentCard(
                          title: 'Website Url',
                          content:
                              widget.visaData.embassyDetails?.embassyUrl ?? ''),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    'Embassy Address 3',
                    style: GoogleFonts.poppins(
                        color: Visa_Colours.dardModerateBlue,
                        fontWeight: FontWeight.w600,
                        fontSize: 15),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  margin: const EdgeInsets.only(right: 0, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentCard(
                          title: 'Address ',
                          content:
                              widget.visaData.embassyDetails?.embassyAddress3 ??
                                  ''),
                      ContentCard(
                          title: 'Contact',
                          content:
                              widget.visaData.embassyDetails?.embassyContact3 ??
                                  ''),
                      ContentCard(
                          title: 'Email',
                          content:
                              widget.visaData.embassyDetails?.embassyEmail3 ??
                                  ''),
                      ContentCard(
                          title: 'Website Url',
                          content:
                              widget.visaData.embassyDetails?.embassyUrl ?? ''),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                Card(
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
                          right: 10, left: 10, top: 2, bottom: 2),
                      child: Text(
                        'Visa FAQ\'s Found',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.visaData.visaFaq!.isNotEmpty
                        ? widget.visaData.visaFaq.toString()
                        : 'No FAQ\'s Found',
                    style: GoogleFonts.poppins(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(
                  height: 15,
                ),

                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  VisaFormPage(visaData: widget.visaData)));
                    },
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
                        child: Text('Book Now',
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
