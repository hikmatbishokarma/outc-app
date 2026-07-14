import 'package:avatars/avatars.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/dashboard/flights/models/flights_list_model.dart';
import 'package:outc/dashboard/flights/providers/oneway_provider.dart';
import 'package:outc/dashboard/flights/widgets/colors.dart';
import 'package:outc/dashboard/flights/widgets/progress_bar.dart';
import 'package:outc/dashboard/flights/widgets/progressbar.dart';
import 'package:outc/load_data/api_response.dart';

import 'package:outc/sidemenu/sidemenu.dart';

import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class OneWayFlightDetailspage extends StatefulWidget {
  var data;

  OneWayFlightDetailspage({super.key, required this.data});

  @override
  State<OneWayFlightDetailspage> createState() =>
      _OneWayFlightDetailspageState();
}

class _OneWayFlightDetailspageState extends State<OneWayFlightDetailspage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var oneWaylistdata = context.watch<OnewayProvider>();
    oneWaylistdata.postData(widget.data);
    return SizedBox(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const SideMenu(),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "AnjMal",
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'poppins',
              color: Flights_Colours.strongRed,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(
            color: Colors.grey,
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: Avatar(
              backgroundColor: Flights_Colours.strongRed,
              placeholderColors: [Flights_Colours.strongRed],
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
                color: Flights_Colours.strongRed,
                icon: Icon(
                  Icons.wallet,
                  size: 28,
                  color: Flights_Colours.strongRed,
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
                                    color: Flights_Colours.strongRed,
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
              color: Flights_Colours.strongRed,
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
            Selector<OnewayProvider, ApiResponse<FlightsList>?>(
              selector: (_, apiResponse) => apiResponse.getFlightsList,
              builder: (_, instance, __) {
                if (instance?.status == Status.error) {
                  return FittedBox(
                      child: Text(instance?.errorMessage ?? "error"));
                } else if (instance?.status == Status.loading) {
                  return const Expanded(child: Flights_ProgressBarHUD());
                } else if (instance?.status == Status.completed) {
                  List oneWaydata = instance?.data?.data?.flightDetails ?? [];
                  return oneWaydata.isEmpty
                      ? Column(
                          children: [
                            const SizedBox(
                              height: 50,
                            ),
                            Image.asset(
                              'images/nodatafound.png',
                              height: 250,
                              width: 250,
                            ),
                          ],
                        )
                      : Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: oneWaydata.length,
                              itemBuilder: (context, index) {
                                return ExpandableNotifier(
                                    child: const Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: Text("asdsd")),
                                ));
                              }),
                        );
                } else {
                  return const Expanded(
                    child: Flights_ProgressBarHUD(),
                  );
                }
              },
            ),
          ],
        ),
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
              //   Navigator.push(
              //     context,
              //     PageTransition(
              //       type: PageTransitionType.rightToLeft,
              //       child: const VisaFilterPage(),
              //     ),
              //   );
            },
          ),
          const Text(
            "One Way Flight List",
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
