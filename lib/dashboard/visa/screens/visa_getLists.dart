import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as flutter;

import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/visa/models/get_visas_model.dart';
import 'package:outc/dashboard/visa/screens/visa_fulldetails.dart';
import 'package:outc/dashboard/visa/screens/visa_guidelinespage.dart';

import 'package:http/http.dart' as http;
import 'package:outc/dashboard/visa/widgets/colors.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class VisaLists extends StatefulWidget {
  final List<Datum> visaData;

  const VisaLists({super.key, required this.visaData});

  @override
  State<VisaLists> createState() => _VisaListsState();
}

class _VisaListsState extends State<VisaLists> {
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
        child: Column(
          children: [
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
                Text("Visa List",
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
            Expanded(
              child: ListView.builder(
                itemCount: widget.visaData.length,
                itemBuilder: (context, index) {
                  final visa = widget.visaData[index];
                  print(visa.embassyDetails?.bestTimeToVisit ?? 'HI');
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Visa_Colours.strongRed,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey.shade100),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin:
                              const EdgeInsets.only(left: 8, top: 10, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              widget.visaData[index].images!.isEmpty
                                  ? SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: flutter.Image.network(
                                          visa.images.toString()))
                                  : SizedBox(
                                      height: 120,
                                      width: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: flutter.Image.network(
                                          "https://www.mypunepulse.com/wp-content/uploads/2023/10/WhatsApp-Image-2023-10-16-at-4.42.41-PM.jpeg",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        child: Text(
                                          '${visa.visaName}, ${visa.country}',
                                          style: GoogleFonts.poppins(
                                            color: Visa_Colours.strongRed,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        '${visa.continent}, ${visa.typeofVisa}',
                                        style: GoogleFonts.poppins(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Colors.black,
                                            size: 7,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '${visa.processingTime} Days Processing Time',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Colors.black,
                                            size: 7,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '${visa.stayperiod} Months Stay Period',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 3,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            color: Colors.black,
                                            size: 7,
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '${visa.validity} Months Validity',
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 15, right: 10, bottom: 5, top: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'INR ${visa.fees}',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const VisaGuidelinesPage()));
                                    },
                                    child: Text(
                                      'Visa Guidelines',
                                      style: GoogleFonts.poppins(
                                        color: Visa_Colours.strongRed,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    try {
                                      final visaData =
                                          await fetchDataFromBackend(
                                              visa.visaCode!);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => VisaFullDetails(
                                              visaData: visaData),
                                        ),
                                      );
                                    } catch (e) {
                                      print("Error fetching data: $e");
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Visa_Colours.strongRed,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      )),
                                  child: Text("View Details",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      )))
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Datum> fetchDataFromBackend(int visaCode) async {
    var url = Uri.parse(
        'http://anjmal.i2space.in/api/v1/visa/getVisaMasterByVisaCode/$visaCode');

    final response = await http.get(url);
    print(url);
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final Map<String, dynamic> data = jsonData['data'];
      return Datum.fromJson(data);
    } else {
      throw Exception('Failed to load data from the backend');
    }
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
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(left: 5),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              color: Visa_Colours.strongRed,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Card(
          elevation: 0.0,
          margin: const EdgeInsets.only(),
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              color: Color(0x40303135),
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xffFFF7F7),
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                content,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

               
                            

 // ExpandableNotifier(
                //           child: Padding(
                //         padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10), 
                //         child: Card(
                //           clipBehavior: Clip.antiAlias,
                //           child: Container(
                //             color: Color(0xffFFF7F7),
                //             child: Column(
                //               children: <Widget>[
                //                 ScrollOnExpand(
                //                   scrollOnExpand: true,
                //                   scrollOnCollapse: false,
                //                   child: ExpandablePanel(
                //                     theme:  ExpandableThemeData(
                //                       headerAlignment:
                //                           ExpandablePanelHeaderAlignment.center,
                //                       tapBodyToCollapse: true,
                //                       iconColor: Visa_Colours.strongRed,
                //                     ),
                //                     header: Container(
                //                       margin: const EdgeInsets.all(10),
                //                       child:  Column(
                //                         mainAxisAlignment: MainAxisAlignment.start,
                //                         crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: [
                                          
                //                           Text(
                //                           '${visa.visaName}, ${visa.country}',
                //                             style: GoogleFonts.poppins(
                //                        color: Visa_Colours.strongRed,
                //                      fontSize: 14,
                //                      fontWeight: FontWeight.w500,
                //                           ),
                //                           ),
                //                          const SizedBox(height: 3,),
                //                          Text(
                //                           '${visa.typeofVisa} Type',
                //                             style: GoogleFonts.poppins(
                //                        color: Visa_Colours.dardModerateBlue,
                //                      fontSize: 13,
                //                      fontWeight: FontWeight.w500,
                //                           ),
                //                           ),
                                            
                //                         ],
                //                       ),
                //                     ),
                //                     collapsed:  Text(
                //                       "Expand for more details",
                //                       style: GoogleFonts.poppins(
                //                        color: Colors.black,
                //                      fontSize: 10,
                //                      fontWeight: FontWeight.w500,
                //                           ),
                //                       softWrap: true,
                //                       maxLines: 2,
                //                       overflow: TextOverflow.ellipsis,
                //                     ),
                //                     expanded: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: <Widget>[
                                        
                //                         ContentCard(
                //                             title: 'Country',
                //                             content:  visa.country.toString()),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Continent',
                //                             content:  visa.continent.toString()),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Visa Type',
                //                             content: visa.typeofVisa.toString()),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Description',
                //                             content: visa.visaDescription.toString()),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Processing Time', content:  '${visa.processingTime} Days',),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Stay Period', content:  '${visa.stayperiod} Months'),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Validity',
                //                             content: '${visa.validity} Months'),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Entry', content: '${visa.entry} Available'),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                         ContentCard(
                //                             title: 'Fare',
                //                             content: 'INR ${visa.fees}'),
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
            
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                                         
                //                           ClipRRect(
                //           borderRadius: BorderRadius.circular(10),
                //           child: flutter.Image.network('https://www.mypunepulse.com/wp-content/uploads/2023/10/WhatsApp-Image-2023-10-16-at-4.42.41-PM.jpeg', fit: BoxFit.cover, height: 180,   width: double.infinity,)),
                                       
                //                           const SizedBox(
                //                           height: 15,
                //                         ),

                //                         SizedBox( height: 45, width: double.infinity,
                //                           child: ElevatedButton(
                //                         style: ElevatedButton.styleFrom(backgroundColor: Visa_Colours.strongRed,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                //                             onPressed: () async {
                                              
                //                       try {
                //             final visaData = await fetchDataFromBackend(visa.visaCode!);
                //          Navigator.push(  context,MaterialPageRoute(builder: (context) => VisaFullDetails(visaData: visaData), ),
                //          );} catch (e) {
                //               print("Error fetching data: $e");
                //             }
                //            }, child: Text('View Details',style: GoogleFonts.poppins(
                //                             color: Colors.white,
                //                             fontSize: 14,
                //                            fontWeight: FontWeight.w600,
                //                           ),)),
                //                         ),
                                         
                                     
                                  
                //                         const SizedBox(
                //                           height: 10,
                //                         ),
                //                       ],
                //                     ),
                //                     builder: (_, collapsed, expanded) {
                //                       return Padding(
                //                         padding: const EdgeInsets.only(
                //                             left: 10, right: 10, bottom: 10),
                //                         child: Expandable(
                //                           collapsed: collapsed,
                //                           expanded: expanded,
                //                           theme: const ExpandableThemeData(
                //                               crossFadePoint: 0),
                //                         ),
                //                       );
                //                     },
                //                   ),
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),
                //       ));



 // Future<List<Datum>> fetchDataFromBackend(int? visaCode) async {
  //   var url = Uri.parse('http://anjmal.i2space.in/api/v1/visa/getVisaMasterByVisaCode/$visaCode');

  //   final response = await http.get(url);
  //  print('Fetching data from URL: $url');
  //   if (response.statusCode == 200) {
  //     final List<dynamic> jsonData = json.decode(response.body)['data'];
  //     return jsonData.map((item) => Datum.fromJson(item)).toList();
  //   } else {
  //     throw Exception('Failed to load data from the backend');
  //   }
  // }
    // Card(
          //   child: ListTile(
          //     title: Text(visa.visaName.toString()),
          //     subtitle: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
                
          //       // Image.network(visa.images.isNotEmpty ? visa.images[0].image : '',),
          //         Text('Country: ${visa.country}'),
          //         Text('Continent: ${visa.continent}'),
          //         Text('Type of Visa: ${visa.typeofVisa}'),
          //         Text('Processing Time: ${visa.processingTime} days'),
          //         Text('Stay Period: ${visa.stayperiod} days'),
          //         Text('Validity: ${visa.validity} days'),
          //         Text('Entry: ${visa.entry}'),
          //         Text('Fees: ${visa.fees} ${visa.currency}'),
                 
          //       ],
          //     ),
          //   ),
          // );
                          //  RichText(
                          // text: TextSpan(
                        
                          // style: const TextStyle(
                          //     color: Colors.black, fontSize: 32),
                          // children: [
                          //  TextSpan(
                          //     text: visa.continent,
                          //     style: GoogleFonts.poppins(
                          //        color: Visa_Colours.strongRed,
                          //      fontSize: 14,
                          //      fontWeight: FontWeight.w500,
                          //           ),
                          //   ), const WidgetSpan( child: SizedBox(width: 3)),
                          //   TextSpan(
                          //     text: '|',
                          //     style: GoogleFonts.poppins(
                          //        color: Colors.black,
                          //      fontSize: 14,
                          //      fontWeight: FontWeight.w400,
                          //           ),
                          //   ),const WidgetSpan( child: SizedBox(width: 3)),
                          //   TextSpan(
                          //     text: visa.country,
                          //     style: GoogleFonts.poppins(
                          //        color: Colors.black,
                          //      fontSize: 14,
                          //      fontWeight: FontWeight.w500,
                          //           ),
                          //   ), const WidgetSpan( child: SizedBox(width: 3)),
                          //   TextSpan(
                          //     text: '|',
                          //     style: GoogleFonts.poppins(
                          //        color: Colors.black,
                          //      fontSize: 14,
                          //      fontWeight: FontWeight.w400,
                          //           ),
                          //   ),const WidgetSpan( child: SizedBox(width: 3)),
                          //   TextSpan(
                          //     text: visa.typeofVisa,
                          //     style: GoogleFonts.poppins(
                          //        color: Visa_Colours.strongRed,
                          //      fontSize: 14,
                          //      fontWeight: FontWeight.w500,
                          //           ),
                          //   ),
                          // ]),)
                
                    //         