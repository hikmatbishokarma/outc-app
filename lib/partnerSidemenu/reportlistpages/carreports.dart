import 'package:avatars/avatars.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/partnerSidemenu/models/carreportsmodel.dart';

import 'package:outc/partnerSidemenu/providers/carreportprovider.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/carfilterpage.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/progress_bar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CarReportsPage extends StatefulWidget {
  const CarReportsPage({super.key});

  @override
  State<CarReportsPage> createState() => _CarReportsPageState();
}

class _CarReportsPageState extends State<CarReportsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var reportsProvider = context.watch<CarReportsProvider>();

    reportsProvider.loadCarReportsList();

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
            Selector<CarReportsProvider, ApiResponse<GetCarReportsResponse>?>(
              selector: (_, apiResponse) => apiResponse.getCarReportsResponse,
              builder: (_, instance, __) {
                if (instance?.status == Status.error) {
                  return FittedBox(
                      child: Text(instance?.errorMessage ?? "error"));
                } else if (instance?.status == Status.loading) {
                  return const Expanded(child: ProgressBarHUD());
                } else if (instance?.status == Status.completed) {
                  List<Datum?> carReportsListData = instance?.data?.data ?? [];
                  return carReportsListData.isEmpty
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
                              itemCount: carReportsListData.length,
                              itemBuilder: (context, index) {
                                return ExpandableNotifier(
                                    child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      color: Colors.grey[100],
                                      child: Column(
                                        children: <Widget>[
                                          ScrollOnExpand(
                                            scrollOnExpand: true,
                                            scrollOnCollapse: false,
                                            child: ExpandablePanel(
                                              theme: ExpandableThemeData(
                                                headerAlignment:
                                                    ExpandablePanelHeaderAlignment
                                                        .center,
                                                tapBodyToCollapse: true,
                                                iconColor: Colours.strongRed,
                                              ),
                                              header: Container(
                                                margin:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 10, 0, 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          carReportsListData[
                                                                      index]
                                                                  ?.bookingRefNo
                                                                  .toString() ??
                                                              "",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colours
                                                                .strongRed,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                        // Text(
                                                        //   carReportsListData[
                                                        //               index]
                                                        //           ?.bookingStatus
                                                        //           .toString() ??
                                                        //       "",
                                                        //   style:
                                                        //       const TextStyle(
                                                        //     fontSize: 14.0,
                                                        //     color: Colors.black,
                                                        //     // snapshot
                                                        //     //             .data!
                                                        //     //             .data![index]
                                                        //     //             .requestStatus ==
                                                        //     //         1
                                                        //     //     ? Colours.veryDarkGrey
                                                        //     //     : snapshot
                                                        //     //                 .data!
                                                        //     //                 .data![index]
                                                        //     //                 .requestStatus ==
                                                        //     //             2
                                                        //     //         ? Colors.green
                                                        //     //         : snapshot
                                                        //     //                     .data!
                                                        //     //                     .data![
                                                        //     //                         index]
                                                        //     //                     .requestStatus ==
                                                        //     //                 3
                                                        //     //             ? Colours
                                                        //     //                 .strongRed
                                                        //     //             : Colors.black,
                                                        //     fontWeight:
                                                        //         FontWeight.bold,
                                                        //     fontFamily:
                                                        //         'poppins',
                                                        //   ),
                                                        // ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Source              : ",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                        Text(
                                                          carReportsListData[
                                                                      index]
                                                                  ?.source
                                                                  .toString() ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Destination       : ",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                        Text(
                                                          carReportsListData[
                                                                      index]
                                                                  ?.destination
                                                                  .toString() ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Journey Date     : ",
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
                                                        Text(
                                                          carReportsListData[
                                                                      index]!
                                                                  .journeyDate
                                                                  .toString()
                                                                  .isEmpty
                                                              ? ""
                                                              : DateFormat(
                                                                      'dd-MM-yyyy')
                                                                  .format(DateTime.parse(
                                                                      carReportsListData[index]
                                                                              ?.journeyDate
                                                                              .toString() ??
                                                                          "")),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                            fontFamily:
                                                                'poppins',
                                                          ),
                                                        ),
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
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  const Divider(
                                                    thickness: 1,
                                                    color: Color(0xffCCCCCC),
                                                  ),
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Guest Name        : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                    index]
                                                                ?.guestName
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Guest Email         : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                    index]
                                                                ?.emailId
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Phone Number     : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                    index]
                                                                ?.mobileNo
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Booking Date        : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                        index]
                                                                    ?.createdDate ==
                                                                ""
                                                            ? ""
                                                            : DateFormat(
                                                                    'dd-MM-yyyy')
                                                                .format(DateTime.parse(
                                                                    carReportsListData[index]
                                                                            ?.createdDate
                                                                            .toString() ??
                                                                        "")),
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Travel Type          : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                        index]
                                                                    ?.travelType ==
                                                                1
                                                            ? "Local"
                                                            : carReportsListData[
                                                                            index]
                                                                        ?.travelType ==
                                                                    2
                                                                ? "Out Station"
                                                                : "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Trip Type              : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                        index]
                                                                    ?.tripType ==
                                                                1
                                                            ? "Onw Way"
                                                            : carReportsListData[
                                                                            index]
                                                                        ?.tripType ==
                                                                    2
                                                                ? "Round Trip"
                                                                : carReportsListData[index]
                                                                            ?.tripType ==
                                                                        4
                                                                    ? "8 Hours"
                                                                    : carReportsListData[index]?.tripType ==
                                                                            5
                                                                        ? "12 Hours"
                                                                        : "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                  Row(
                                                    children: [
                                                      const Text(
                                                        "Vendor                 : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        carReportsListData[
                                                                    index]
                                                                ?.vendor
                                                                ?.companyName
                                                                .toString() ??
                                                            "",
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 6.0,
                                                  ),
                                                ],
                                              ),
                                              builder:
                                                  (_, collapsed, expanded) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          right: 10,
                                                          bottom: 10),
                                                  child: Expandable(
                                                    collapsed: collapsed,
                                                    expanded: expanded,
                                                    theme:
                                                        const ExpandableThemeData(
                                                            crossFadePoint: 0),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ));
                              }),
                        );
                } else {
                  return const Expanded(
                    child: ProgressBarHUD(),
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
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.rightToLeft,
                  child: const CarFilterPage(),
                ),
              );
            },
          ),
          const Text(
            "Car Reports",
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
