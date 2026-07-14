import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/components/components.dart';
import 'package:outc/widgets/sharedprefservices.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // getheadercontainer(),
              const SizedBox(
                height: 15.0,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SharedPrefServices.getprofileimage().toString().isEmpty
                        ? SizedBox(
                            width: 100.0,
                            height: 100.0,
                            child: Avatar(
                              backgroundColor: Colours.strongRed,
                              placeholderColors: [Colours.strongRed],
                              useCache: true,

                              onTap: () {},
                              name: SharedPrefServices.getfirstname()!
                                  .toUpperCase(),
                              textStyle: const TextStyle(
                                fontSize: 25.0,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              // Fallback if no image source is available
                            ),
                          )
                        : GestureDetector(
                            onTap: () {},
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                SharedPrefServices.getprofileimage().toString(),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),

              // Card(
              //   elevation: 8,
              //   shape: RoundedRectangleBorder(
              //     side: BorderSide(
              //       color: Color(0xffEAEAEA),
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   margin: EdgeInsets.only(left: 35.0, right: 35.0),
              //   child: Column(
              //     children: [
              //       Container(
              //         decoration: BoxDecoration(
              //           color: Color(0xffFAFAFA),
              //           borderRadius: BorderRadius.all(
              //             Radius.circular(10.0),
              //           ),
              //         ),
              //         height: 83.0,
              //         width: double.infinity,
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             GestureDetector(
              //               child: Container(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Image.asset(
              //                       'images/scanqrcode.png',
              //                       height: 24,
              //                       width: 24,
              //                       color: Color(0xff565656),
              //                     ),
              //                     SizedBox(
              //                       height: 8,
              //                     ),
              //                     Text(
              //                       "Scan QR Code",
              //                       style: TextStyle(
              //                         fontSize: 14.0,
              //                         fontWeight: FontWeight.bold,
              //                         color: Color(0xff565656),
              //                         fontFamily: 'poppins',
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               onTap: () {
              //                 Navigator.push(context,
              //                     MaterialPageRoute(builder: (_) {
              //                   return QRViewExample();
              //                 }));
              //               },
              //             ),

              //             Container(
              //               height: 50.0,
              //               width: 1.0,
              //               color: Color(0xffEAEAEA),
              //             ),
              //             GestureDetector(
              //               child: Container(
              //                 child: Column(
              //                   mainAxisAlignment: MainAxisAlignment.center,
              //                   children: [
              //                     Image.asset(
              //                       'images/myqrcode.png',
              //                       height: 24,
              //                       width: 24,
              //                       color: Color(0xff565656),
              //                     ),
              //                     SizedBox(
              //                       height: 8,
              //                     ),
              //                     Text(
              //                       "My QR Code",
              //                       style: TextStyle(
              //                         fontSize: 14.0,
              //                         fontWeight: FontWeight.bold,
              //                         color: Color(0xff565656),
              //                         fontFamily: 'poppins',
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //               onTap: () {
              //                 Navigator.push(context,
              //                     MaterialPageRoute(builder: (_) {
              //                   return QrcodeProfilepage();
              //                 }));
              //               },
              //             ),
              //             // widget goes here
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),

              // ),

              //  const SizedBox(
              //     height: 15.0,
              //   ),
              Container(
                margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const TextHeader(
                      inputText: "FIRST NAME",
                    ),
                    TextContent(
                        inputText:
                            SharedPrefServices.getfirstname().toString()),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "LAST NAME",
                    ),
                    TextContent(
                        inputText: SharedPrefServices.getlastname().toString()),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "STREET ADDRESS",
                    ),
                    const TextContent(inputText: "TODO"),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "ZIP CODE",
                    ),
                    const TextContent(inputText: "TODO"),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "CITY",
                    ),
                    const TextContent(inputText: "TODO"),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "STATE",
                    ),
                    const TextContent(inputText: "TODO"),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "EMAIL",
                    ),
                    TextContent(
                        inputText: SharedPrefServices.getemail().toString()),
                    const DivWithPadding(),
                    const TextHeader(
                      inputText: "MOBILE NUMBER",
                    ),
                    TextContent(
                        inputText:
                            SharedPrefServices.getphonenumber().toString()),
                    const DivWithPadding(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     SizedBox(
                    //       height: 48,
                    //       child: ElevatedButton(
                    //         onPressed: () async {
                    //           // Navigator.of(context).push(
                    //           //   MaterialPageRoute(
                    //           //     builder: (BuildContext context) {
                    //           //       return Changepasswordprofile();
                    //           //     },
                    //           //   ),
                    //           // );
                    //         },
                    //         style: ElevatedButton.styleFrom(
                    //             shape: RoundedRectangleBorder(
                    //               borderRadius: BorderRadius.circular(10),
                    //             ),
                    //             backgroundColor: Colours.strongRed,
                    //             fixedSize: const Size(330, 48),
                    //             textStyle: const TextStyle(
                    //               fontSize: 14.0,
                    //               color: Colors.white,
                    //               fontFamily: 'Poppins-regular',
                    //               fontWeight: FontWeight.w700,
                    //             )),
                    //         child: const Text(
                    //           'CHANGE PASSWORD',
                    //           style: TextStyle(
                    //             fontSize: 14.0,
                    //             color: Colors.white,
                    //             fontFamily: 'Poppins',
                    //             fontWeight: FontWeight.w700,
                    //           ),
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
