import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/partnerSidemenu/models/password_update_model.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({super.key});

  @override
  _BankDetailsPage createState() => _BankDetailsPage();
}

class _BankDetailsPage extends State<BankDetailsPage> {
  bool isApiCallProcess = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProgressBar(
      inAsyncCall: isApiCallProcess,
      opacity: 0.3,
      child: uiSetup(context),
    );
  }

  Widget uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawer: const SideMenu(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "AnjMal",
          style: TextStyle(
            fontSize: 22.0,
            fontFamily: 'poppins',
            color: Colours.strongRed,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.grey,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Avatar(
            backgroundColor: Colours.strongRed,
            placeholderColors: [Colours.strongRed],
            useCache: true,

            onTap: () {
              scaffoldKey.currentState!.openDrawer();
            },
            name: SharedPrefServices.getfirstname()!.toUpperCase(),
            textStyle: const TextStyle(
              fontSize: 15.0,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            // Fallback if no image source is available
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              color: Colours.strongRed,
              icon: Icon(
                Icons.wallet,
                size: 28,
                color: Colours.strongRed,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                          height: 74,
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
                                  // fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "INR ${SharedPrefServices.getwalletblc()}",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colours.strongRed,
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
            color: Colours.strongRed,
            icon: const ImageIcon(
              AssetImage(
                "images/notifybell.png",
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          getheadercontainer(),
          const SizedBox(
            height: 15.0,
          ),
          Container(
            margin: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Colours.strongRed,
                ),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade100),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BANK NAME ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colours.veryDarkGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "HDFC",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colours.strongRed,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ACCOUNT NUMBER ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colours.veryDarkGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "098765343425",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colours.strongRed,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "BRANCH NAME ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colours.veryDarkGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "KUKATPALLY",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colours.strongRed,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "IFSC CODE ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colours.veryDarkGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "KUK3637",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colours.strongRed,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                      left: 5, right: 5, bottom: 5, top: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COMMENTS ",
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colours.veryDarkGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                "TESTING....",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colours.strongRed,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )

          // Center(
          //     child: Column(children: <Widget>[
          //   Container(
          //     margin: const EdgeInsets.all(20),
          //     child: Flexible(
          //       child: SingleChildScrollView(
          //         scrollDirection: Axis.horizontal,
          //         child: Table(
          //           defaultColumnWidth: FixedColumnWidth(120.0),
          //           border: TableBorder.all(
          //               color: Colors.black,
          //               style: BorderStyle.solid,
          //               width: 2),
          //           children: const [
          //             TableRow(children: [
          //               Column(children: [
          //                 Text('Website', style: TextStyle(fontSize: 20.0))
          //               ]),
          //               Column(children: [
          //                 Text('Website', style: TextStyle(fontSize: 20.0))
          //               ]),
          //               Column(children: [
          //                 Text('Website', style: TextStyle(fontSize: 20.0))
          //               ]),
          //               Column(children: [
          //                 Text('Website', style: TextStyle(fontSize: 20.0))
          //               ]),
          //               Column(children: [
          //                 Text('Tutorial', style: TextStyle(fontSize: 20.0))
          //               ]),
          //               Column(children: [
          //                 Text('Review', style: TextStyle(fontSize: 20.0))
          //               ]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('MySQL')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('ReactJS')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('ReactJS')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('ReactJS')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //             TableRow(children: [
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('ReactJS')]),
          //               Column(children: [Text('5*')]),
          //               Column(children: [Text('Javatpoint')]),
          //               Column(children: [Text('Flutter')]),
          //               Column(children: [Text('5*')]),
          //             ]),
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ]))
        ],
      ),
    );
  }

  getheadercontainer() {
    return Container(
      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Color(0xff393939),
                size: 20,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: Dashboard(),
                ),
              );
            },
          ),
          const Text(
            "Bank Details (STATIC DATA)",
            style: TextStyle(
              fontFamily: 'poppins',
              fontSize: 16.0,
              color: Colors.black,
            ),
          ),
          const Icon(
            Icons.abc,
            color: Colors.transparent,
          )
        ],
      ),
    );
  }
}
