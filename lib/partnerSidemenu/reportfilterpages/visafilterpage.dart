import 'package:avatars/avatars.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/dashboard.dart';
import 'package:outc/partnerSidemenu/providers/visareportprovider.dart';
import 'package:outc/partnerSidemenu/reportlistpages/visareports.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class VisaFilterPage extends StatefulWidget {
  const VisaFilterPage({super.key});

  @override
  State<VisaFilterPage> createState() => _VisaFilterPageState();
}

class _VisaFilterPageState extends State<VisaFilterPage> {
  String selectedOptions = 'Last One Hour';
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var optionTypes = ['Last One Hour', 'Yesterday', 'Last Week', 'Custom Dates'];
  String selectedStatus = 'Blocked';
  var statusTypes = ['Blocked', 'Confirmed', 'Cancelled'];
  String status = "2";
  String selectedbookingType = 'All';
  var bookingtypes = ['All', 'Online', 'Offline'];
  String bookingtypesstatus = "Undefined";

  String toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  DateTime fromDateraw = DateTime.now();
  bool viewdates = false;
  @override
  Widget build(BuildContext context) {
    var visareportsProvider = context.watch<VisaReportsProvider>();

    return Scaffold(
      key: scaffoldKey,
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
          Container(
            margin: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    "Time and Date",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colours.veryDarkGrey,
                      fontFamily: 'Poppins',
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colours.strongRed, width: 1.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colours.strongRed,
                            size: 30,
                          ),
                          value: selectedOptions,
                          onChanged: (newvalue) {
                            setState(() {
                              selectedOptions = newvalue!;
                              print(selectedOptions);
                              if (selectedOptions == "Last One Hour") {
                                setState(() {
                                  viewdates = false;
                                  toDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                                  fromDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                                  SharedPrefServices.setfromdate(fromDate);
                                  SharedPrefServices.settodate(toDate);
                                });
                              } else if (selectedOptions == "Yesterday") {
                                setState(() {
                                  viewdates = false;
                                  toDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                                  fromDate = DateFormat('yyyy-MM-dd').format(
                                      DateTime.now()
                                          .subtract(const Duration(days: 1)));
                                  SharedPrefServices.setfromdate(fromDate);
                                  SharedPrefServices.settodate(toDate);
                                });
                              } else if (selectedOptions == "Last Week") {
                                setState(() {
                                  viewdates = false;
                                  toDate = DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now());
                                  fromDate = DateFormat('yyyy-MM-dd').format(
                                      DateTime.now()
                                          .subtract(const Duration(days: 7)));
                                  SharedPrefServices.setfromdate(fromDate);
                                  SharedPrefServices.settodate(toDate);
                                });
                              } else if (selectedOptions == "Custom Dates") {
                                setState(() {
                                  viewdates = true;
                                });
                              }
                            });
                          },
                          items: optionTypes.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Colours.strongRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    "Booking Status",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colours.veryDarkGrey,
                      fontFamily: 'Poppins',
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colours.strongRed, width: 1.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colours.strongRed,
                            size: 30,
                          ),
                          value: selectedStatus,
                          onChanged: (newvalue) {
                            setState(() {
                              selectedStatus = newvalue!;
                              print(selectedStatus);

                              if (selectedStatus == "Blocked") {
                                setState(() {
                                  status = "2";
                                  SharedPrefServices.sethotelstatus(status);
                                });
                              } else if (selectedStatus == "Confirmed") {
                                setState(() {
                                  status = "3";
                                  SharedPrefServices.sethotelstatus(status);
                                });
                              } else if (selectedStatus == "Cancelled") {
                                setState(() {
                                  status = "4";
                                  SharedPrefServices.sethotelstatus(status);
                                });
                              }
                            });
                          },
                          items: statusTypes.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Colours.strongRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                viewdates == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  width: 145,
                                  child: const Text(
                                    "From Date *",
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xff303135),
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Card(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                      color: Color(0x40303135),
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    width: 135,
                                    decoration: const BoxDecoration(
                                      color: Color(0xffFFF7F7),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            fromDate,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xff303135),
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            buildDatePickerfromdate();
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.calendar_today_outlined,
                                              color: Colours.strongRed,
                                              size: 20,
                                              // color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 145,
                                child: Text(
                                  "To Date *",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Color(0xff303135),
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Card(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                    color: Color(0x40303135),
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Container(
                                  width: 145,
                                  decoration: const BoxDecoration(
                                    color: Color(0xffFFF7F7),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          toDate,
                                          style: const TextStyle(
                                            fontSize: 14.0,
                                            color: Color(0xff303135),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          buildDatePickertodate();
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colours.strongRed,
                                            size: 20,
                                            // color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 10,
                                child: Text(
                                  "*",
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.transparent,
                                    fontFamily: 'poppins',
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                            ],
                          ),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 8),
                  child: Text(
                    "Booking Type",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colours.veryDarkGrey,
                      fontFamily: 'Poppins',
                      // fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colours.strongRed, width: 1.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colours.strongRed,
                            size: 30,
                          ),
                          value: selectedbookingType,
                          onChanged: (newvalue) {
                            setState(() {
                              selectedbookingType = newvalue!;
                              print(selectedStatus);
                              if (selectedbookingType == "All") {
                                setState(() {
                                  bookingtypesstatus = "undefined";
                                  SharedPrefServices.sethotelbookingtype(
                                      bookingtypesstatus);
                                });
                              } else if (selectedStatus == "Online") {
                                setState(() {
                                  bookingtypesstatus = "3";
                                  SharedPrefServices.sethotelbookingtype(
                                      bookingtypesstatus);
                                });
                              } else if (selectedStatus == "Offline") {
                                setState(() {
                                  bookingtypesstatus = "2";
                                  SharedPrefServices.sethotelbookingtype(
                                      bookingtypesstatus);
                                });
                              }
                            });
                          },
                          items: bookingtypes.map((String item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  item,
                                  style: TextStyle(
                                    color: Colours.strongRed,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    SharedPrefServices.setfromdate(fromDate);
                    SharedPrefServices.settodate(toDate);
                    SharedPrefServices.sethotelbookingtype(bookingtypesstatus);
                    SharedPrefServices.sethotelstatus(status);

                    visareportsProvider.clearReportsDetails();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const VisaReportsPage();
                        },
                      ),
                    );

                    print("search triggered");
                  },
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: Colours.strongRed,
                      ),
                      borderRadius: BorderRadius.circular(10),
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
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.search,
                                color: Colours.strongRed,
                                size: 20,
                              ),
                            ),
                            Text(
                              "Search Visa Reports",
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colours.strongRed,
                                fontFamily: 'Poppins',
                                // fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
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
        ],
      ),
    );
  }

  buildDatePickerfromdate() async {
    print("calander triggered");
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(), //get today's date
        firstDate: DateTime(2020),
        lastDate: DateTime(2101));
    if (pickedDate != null) {
      // String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        fromDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        fromDateraw = pickedDate;
        SharedPrefServices.setfromdate(fromDate);
      });
    } else {
      print(fromDate);
    }
  }

  buildDatePickertodate() async {
    print("calander triggered");
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: fromDateraw, //get today's date
        firstDate: fromDateraw,
        lastDate: DateTime.now());
    if (pickedDate != null) {
      // String formattedDate = DateFormat.yMMMEd().format(pickedDate);

      setState(() {
        toDate = DateFormat('yyyy-MM-dd').format(pickedDate);
        SharedPrefServices.settodate(toDate);
      });
    } else {
      print(fromDate);
    }
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
            "Visa Reports",
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
