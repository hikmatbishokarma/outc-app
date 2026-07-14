import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/dashboard/hotels/models/selected_hotel_payload.dart';

import 'package:outc/dashboard/hotels/widgets/colors.dart';
import 'package:outc/services/api_services_list.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  SelectedHotelmodel payloadData = SelectedHotelmodel(
      traceId: "",
      hotelCode: "",
      supplier: "",
      userId: 1,
      roleType: 4,
      membership: 1);
  List<String> imageUrls = [
    "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1c/d0/50/73/pool-and-jacuzzi.jpg?w=700&h=-1&s=1",
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ2Q8RRNiF6fStwN2TnYFZACjjBhnaXgS_1Uin9ee7ONw&s',
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTPg5ycoysSCCa5hk50JJhQ07x18fv-k-hXjxb3aXKWJg&s',
    'https://www.tajhotels.com/content/dam/luxury/hotels/Taj_Krishna_Hyderabad/images/gallery/Deluxe%20Suite%20Bed%20Room%201(A).jpg',
    'https://cf.bstatic.com/xdata/images/hotel/max1024x768/57479183.jpg?k=c4376e1ef939d4e94ca00aafd0d2f8358b65e3d6425857da991535e0c32572d0&o=&hp=1',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: imageUrls.length,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      imageUrls[index],
                      fit: BoxFit.cover,
                      height: 50,
                      width: 50,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.0)),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            'Star Rating',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 18,
                                  )
                                ]),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Address :',
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.red),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          SizedBox(
                            width: 180,
                            child: Text(
                              ' Road No.1 Banjara Hills Telangana Hyderabad,',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade400, width: 1.0),
                    color: Colors.lightBlue.shade100),
                child: Container(
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Image.asset(
                              'images/noimage.png',
                              height: 100,
                              width: 100,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Text(
                              'Get the best rates from all regions',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          )
                        ],
                      ),
                      Text(
                        'Save More',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      SizedBox(
                        width: 180,
                        child: Text(
                          'Search Book, Hotels & Apartments , across global region',
                          style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Searched Criteria',
                style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    'Check In :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '29 Nov,2023',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Check Out :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '30 Nov,2023',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  Text(
                    'Guest(s) :',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '1',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1.0,
                color: Colors.grey.shade300,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VIEW ROOMS',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  // SizedBox(
                  //   width: 180,
                  //   child: ElevatedButton(
                  //     onPressed: () {},
                  //     style: ElevatedButton.styleFrom(
                  //         backgroundColor: Colors.blue),
                  //     child: Text(
                  //       'BOOK THIS NOW',
                  //       style: GoogleFonts.poppins(
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.w500,
                  //           color: Colors.white),
                  //     ),
                  //   ),
                  // ),
                  ElevatedButton(
                      onPressed: () {
                        payloadData.hotelCode = "1132405";
                        payloadData.supplier = "TBO";
                        payloadData.traceId =
                            "f97641cd-4533-4c54-9610-9abf970d5d2d";

                        setState(() {
                          // isApiCallProcess = true;
                        });
                        APIService apiService = APIService();
                        // selectedHotel(payloadData);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Hotels_Colours.strongRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                      child: Text("Choose",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 14,
                          )))
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: Colors.grey.shade400, width: 1.0)),
                child: Container(
                  margin: const EdgeInsets.only(right: 5, left: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Why Book with us ?',
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Best Rates Gauranteed',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Get best rates from all regions ',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        'No booking fees . ',
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
