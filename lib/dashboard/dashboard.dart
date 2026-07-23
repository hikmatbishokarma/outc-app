import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/core/module_registry.dart';
import 'package:outc/dashboard/account.dart';
import 'package:outc/dashboard/flights/widgets/customText.dart';
import 'package:outc/dashboard/homepage.dart';
import 'package:outc/dashboard/hotels/screens/book_hotel_form_page.dart';
import 'package:outc/dashboard/my_bookings.dart';
import 'package:outc/loginflow/multiloginpage.dart';
import 'package:outc/partnerSidemenu/reportlistpages/hotelreports.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/progressbar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool camgalaccess = false;

  bool isApiCallProcess = false;
  int selectIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  List children = const [HomePage(), MybookingListPage(), MyAccount()];

  Color mainColor = const Color(0xFFFF6700);

  @override
  void initState() {
    super.initState();
    getCurrentDate();
  }

  String finalDate = '';

  getCurrentDate() {
    var date = DateTime.now().toString();
    DateTime defdateTime = DateTime.now();

    var dateParse = DateTime.parse(date);
    DateFormat('MM-dd-yyyy').format(defdateTime);

    var formattedDate = DateFormat('MM-dd-yyyy').format(dateParse);

    // var formattedtime = DateFormat.Hm().format(defdateTime);

    setState(() {
      finalDate = formattedDate.toString();
    });
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
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return WillPopScope(
      child: Scaffold(
        extendBody: true,
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: false,
          title: Image.asset(
            "images/outc.png",
            height: 40,
            width: 40,
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colours.borderGrey,
          ),
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colours.borderGrey,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          actions: <Widget>[
            if (ModuleRegistry.agentEnabled &&
                SharedPrefServices.getroleType().toString() != "agent")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const MultiLoginScreen(startOnAgent: true),
                      ),
                    );
                  },
                  child: Text(
                    'Partner Login',
                    style: TextStyle(
                      color: Colours.orangeOutC,
                      fontFamily: 'poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            if (SharedPrefServices.getroleType().toString() == "agent")
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: IconButton(
                  color: Colours.orangeOutC,
                  icon: FaIcon(FontAwesomeIcons.wallet),
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
                                  CustomText(
                                    text: "My Wallet Balance",
                                    textcolor: Colours.textBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 10),
                                  CustomText(
                                    text:
                                        "INR ${SharedPrefServices.getwalletblc()}",
                                    textcolor: Colours.orangeOutC,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
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
              color: Colours.orangeOutC,
              icon: FaIcon(FontAwesomeIcons.bell),
              // const ImageIcon(
              //   AssetImage(
              //     "images/notifybell.png",
              //   ),
              // ),
              onPressed: () {},
            ),
          ],
        ),
        drawer: const SideMenu(),
        body: children[selectIndex],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: selectIndex,
          selectedItemColor: Colours.orangeOutC,
          unselectedItemColor: Colors.grey.shade400,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.list),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.bookBookmark),
              // Icon(
              //   Icons.bookmark_outline,
              // ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.user),
              // Icon(
              //   Icons.person,
              // ),
              label: 'Account',
            ),
          ],
        ),
      ),
      onWillPop: () => showExitPopup(context),
    );
  }

  // List<PersistentBottomNavBarItem> _navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       contentPadding: 0,
  //       icon: const Padding(
  //         padding: EdgeInsets.all(0.0),
  //         child: ImageIcon(
  //           AssetImage("images/account.png"),
  //         ),
  //       ),
  //       title: ("Home"),
  //       activeColorPrimary: Colours.strongRed,
  //       inactiveColorPrimary: CupertinoColors.systemGrey,
  //       textStyle: const TextStyle(fontSize: 12, fontFamily: "poppins"),
  //     ),
  //     PersistentBottomNavBarItem(
  //       contentPadding: 0,
  //       icon: const ImageIcon(
  //         AssetImage("images/account.png"),
  //       ),
  //       title: ("Bookings"),
  //       activeColorPrimary: Colours.strongRed,
  //       inactiveColorPrimary: CupertinoColors.systemGrey,
  //       textStyle: const TextStyle(fontSize: 12, fontFamily: "poppins"),
  //     ),
  //     PersistentBottomNavBarItem(
  //       contentPadding: 0,
  //       icon: const ImageIcon(
  //         AssetImage("images/account.png"),
  //       ),
  //       title: ("Account"),
  //       activeColorPrimary: Colours.strongRed,
  //       inactiveColorPrimary: CupertinoColors.systemGrey,
  //       textStyle: const TextStyle(fontSize: 12, fontFamily: "poppins"),
  //     ),
  //   ];
  // }

  Future<bool> showExitPopup(context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SizedBox(
              height: 165,
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
                    child: Image.asset(
                      'images/outc.png',
                      height: 40,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (kDebugMode) {
                            print('no selected');
                          }
                          Navigator.of(context).pop();
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Color(0xFFFF6700)),
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
                                  "Cancel",
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
                          if (kDebugMode) {
                            print('yes selected');
                          }
                          exit(0);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.transparent),
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
                                  "Exit",
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
  }
}
