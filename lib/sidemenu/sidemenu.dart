import 'dart:io';
import 'package:avatars/avatars.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:outc/loginflow/multiloginpage.dart';
import 'package:outc/partnerSidemenu/bank_details_page.dart';
import 'package:outc/partnerSidemenu/change_pasword_page.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/carfilterpage.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/depositfilterpage.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/flightfliterpage.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/hotelfilterpage.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/statementsfilterpage.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/visafilterpage.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isApiCallProcess = false;
  bool camgalaccess = false;
  late File imageFile;
  List<File> imgstoupload = [];
  bool isdialogboxselected = false;

  List Currency = [
    {"code": "INR", "currency": "1.00"},
    {"code": "USD", "currency": "0.01"},
    {"code": "EUR", "currency": "0.01"},
    {"code": "GBP", "currency": "0.01"},
    {"code": "AED", "currency": "0.05"},
    {"code": "ANG", "currency": "0.02"},
    {"code": "ARS", "currency": "1.09"},
    {"code": "AUD", "currency": "0.02"},
    {"code": "BDT", "currency": "1.14"},
    {"code": "BGN", "currency": "0.02"},
    {"code": "BHD", "currency": "0.01"},
    {"code": "BND", "currency": "0.02"},
    {"code": "BOB", "currency": "0.09"},
    {"code": "BRL", "currency": "0.07"},
    {"code": "BWP", "currency": "0.15"},
    {"code": "CAD", "currency": "0.02"},
    {"code": "CHF", "currency": "0.01"},
    {"code": "CLP", "currency": "10.46"},
    {"code": "CNY", "currency": "0.09"},
    {"code": "COP", "currency": "49.13"},
    {"code": "CRC", "currency": "8.09"},
    {"code": "CZK", "currency": "0.30"},
    {"code": "DKK", "currency": "0.09"},
    {"code": "DOP", "currency": "0.79"},
    {"code": "DZD", "currency": "1.74"},
    {"code": "EGP", "currency": "0.21"},
    {"code": "ZAR", "currency": "0.21"},
    {"code": "NPR", "currency": "1.60"},
    {"code": "NZD", "currency": "0.02"},
    {"code": "MXN", "currency": "0.27"},
    {"code": "THB", "currency": "0.41"},
    {"code": "SGD", "currency": "0.02"},
    {"code": "MYR", "currency": "0.06"},
    {"code": "SAR", "currency": "0.05"},
    {"code": "UAH", "currency": "0.38"},
    {"code": "RUB", "currency": "1.18"},
  ];
  int index = 0;

  @override
  void initState() {
    super.initState();

    setState(() {
      isApiCallProcess = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
                height: 180,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colours.strongRed,
                    Colours.dardModerateBlue,
                  ],
                )),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10.0,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 55,
                                  width: 55,
                                  child: Avatar(
                                    backgroundColor: Colours.strongRed,
                                    placeholderColors: [Colours.strongRed],
                                    useCache: true,

                                    onTap: () {},
                                    name: SharedPrefServices.getfirstname()!
                                        .toUpperCase(),
                                    textStyle: const TextStyle(
                                      fontSize: 15.0,
                                      fontFamily: 'poppins',
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                    // Fallback if no image source is available
                                  ),
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${SharedPrefServices.getfirstname()} ${SharedPrefServices.getlastname()}",
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontFamily: 'poppins',
                                        )),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Text(
                                        SharedPrefServices.getemail()
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontFamily: 'poppins',
                                        )),
                                    Text(
                                        SharedPrefServices.getroleType()
                                            .toString(),
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            SharedPrefServices.getroleType.toString() == "user"
                ? userOptions()
                : SharedPrefServices.getroleType().toString() == "agent"
                    ? agentOptions()
                    : userOptions()
          ],
        ),
      ),
    );
  }

  userOptions() {
    return Container(
      color: const Color(0xffF7F7F7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("BOOK VISA SLOT",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("TERMS AND CONDITIONS",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("HELP AND FAQS",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("PRIVACY",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              displayBottomSheet(context);
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      const ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      // ignore: prefer_interpolation_to_compose_strings
                      Row(
                        children: [
                          const Text("CURRENCY   ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xff626365),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'poppins',
                              )),
                          Text(SharedPrefServices.getcurrencycode().toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colours.strongRed,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'poppins',
                              )),
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Changepasswordprofile(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("CHANGE PASSWORD",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Do you really want to logout",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Anj',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontFamily: 'poppins',
                                    color: Color(0xffbd0c21),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Mal",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontFamily: 'poppins',
                                        color: Color(0xff35459c),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colours.strongRed),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colours.strongRed,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    SharedPrefServices
                                        .clearUserFromSharedPrefs();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MultiLoginScreen(),
                                      ),
                                      (route) => false,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Logged out successfully')));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colours.strongRed,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("LOGOUT",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  agentOptions() {
    return Container(
      color: const Color(0xffF7F7F7),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const BankDetailsPage(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("BANK DETAILS",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const DepositFilterPage(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("DEPOSITS",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(
          //   height: 5.0,
          // ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       PageTransition(
          //         type: PageTransitionType.rightToLeft,
          //         child: const ReportsPage(),
          //       ),
          //     );
          //   },
          //   child: Container(
          //     height: 52.0,
          //     color: Colors.white,
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //       children: [
          //         Row(
          //           children: [
          //             SizedBox(
          //               width: 10.0,
          //             ),
          //             ImageIcon(
          //               AssetImage("images/account.png"),
          //               size: 20,
          //               color: Color(0xff626365),
          //             ),
          //             SizedBox(
          //               width: 10.0,
          //             ),
          //             Text("REPORTS",
          //                 style: TextStyle(
          //                   fontSize: 14.0,
          //                   color: Color(0xff626365),
          //                   fontWeight: FontWeight.w700,
          //                   fontFamily: 'poppins',
          //                 )),
          //           ],
          //         ),
          //         Row(
          //           children: [
          //             ImageIcon(
          //               AssetImage("images/rightarrow.png"),
          //               size: 20,
          //               color: Color(0xff626365),
          //             ),
          //             SizedBox(
          //               width: 10,
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          const SizedBox(
            height: 5.0,
          ),
          ExpandableNotifier(
              child: Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                ScrollOnExpand(
                  scrollOnExpand: true,
                  scrollOnCollapse: false,
                  child: ExpandablePanel(
                    theme: const ExpandableThemeData(
                      headerAlignment: ExpandablePanelHeaderAlignment.center,
                      tapBodyToCollapse: true,
                      iconColor: Color(0xff626365),
                    ),
                    header: Container(
                      height: 52.0,
                      color: Colors.white,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10.0,
                              ),
                              ImageIcon(
                                AssetImage("images/account.png"),
                                size: 20,
                                color: Color(0xff626365),
                              ),
                              SizedBox(
                                width: 10.0,
                              ),
                              Text("REPORTS",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff626365),
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'poppins',
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    collapsed: Text(
                      "More details",
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colours.strongRed,
                        fontFamily: 'poppins',
                      ),
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    expanded: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const FlightFilterPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52.0,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text("FLIGHTS REPORTS",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff626365),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ImageIcon(
                                      AssetImage("images/rightarrow.png"),
                                      size: 20,
                                      color: Color(0xff626365),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const HotelFilterPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52.0,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text("HOTEL REPORTS",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff626365),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ImageIcon(
                                      AssetImage("images/rightarrow.png"),
                                      size: 20,
                                      color: Color(0xff626365),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const CarFilterPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52.0,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text("CAR REPORTS",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff626365),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ImageIcon(
                                      AssetImage("images/rightarrow.png"),
                                      size: 20,
                                      color: Color(0xff626365),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: const VisaFilterPage(),
                              ),
                            );
                          },
                          child: Container(
                            height: 52.0,
                            color: Colors.white,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text("VISA REPORTS",
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff626365),
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'poppins',
                                        )),
                                  ],
                                ),
                                Row(
                                  children: [
                                    ImageIcon(
                                      AssetImage("images/rightarrow.png"),
                                      size: 20,
                                      color: Color(0xff626365),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    ),
                    builder: (_, collapsed, expanded) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 10),
                        child: Expandable(
                          collapsed: collapsed,
                          expanded: expanded,
                          theme: const ExpandableThemeData(crossFadePoint: 0),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(
            height: 5.0,
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const StatementFilterPage(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("STATEMENTS",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              displayBottomSheet(context);
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 10.0,
                      ),
                      const ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      // ignore: prefer_interpolation_to_compose_strings
                      Row(
                        children: [
                          const Text("CURRENCY   ",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Color(0xff626365),
                                fontWeight: FontWeight.w700,
                                fontFamily: 'poppins',
                              )),
                          Text(SharedPrefServices.getcurrencycode().toString(),
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colours.strongRed,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'poppins',
                              )),
                        ],
                      ),
                    ],
                  ),
                  const Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const Changepasswordprofile(),
                ),
              );
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("CHANGE PASSWORD",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      content: SizedBox(
                        height: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Do you really want to logout",
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black,
                                fontFamily: 'Poppins',
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: const TextSpan(
                                  text: 'Anj',
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    fontFamily: 'poppins',
                                    color: Color(0xffbd0c21),
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: "Mal",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        fontFamily: 'poppins',
                                        color: Color(0xff35459c),
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
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side:
                                          BorderSide(color: Colours.strongRed),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "NO",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colours.strongRed,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    SharedPrefServices
                                        .clearUserFromSharedPrefs();

                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MultiLoginScreen(),
                                      ),
                                      (route) => false,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Logged out successfully')));
                                  },
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colours.strongRed,
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(10.0),
                                        ),
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: Center(
                                          child: Text(
                                            "YES",
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: Container(
              height: 52.0,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.0,
                      ),
                      ImageIcon(
                        AssetImage("images/account.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text("LOGOUT",
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff626365),
                            fontWeight: FontWeight.w700,
                            fontFamily: 'poppins',
                          )),
                    ],
                  ),
                  Row(
                    children: [
                      ImageIcon(
                        AssetImage("images/rightarrow.png"),
                        size: 20,
                        color: Color(0xff626365),
                      ),
                      SizedBox(
                        width: 10,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isDismissible: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
        builder: (context) => Container(
              color: const Color(0xffFFF7F7),
              height: 250.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CupertinoPicker(
                  itemExtent: 50,
                  children: Currency.map((item) => Center(
                        child: Text(
                          item['code'],
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Color(0xff303135),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      )).toList(),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      this.index = index;
                      final item = Currency[index]["code"];
                      SharedPrefServices.setcurrencycode(
                          Currency[index]["code"]);
                      SharedPrefServices.setcurrencyAmount(
                          Currency[index]["currency"]);
                      print('Selected item: $item');
                    });
                  },
                ),
              ),
            ));
  }
}
