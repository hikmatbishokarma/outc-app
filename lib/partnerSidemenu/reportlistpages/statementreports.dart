import 'package:avatars/avatars.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:outc/load_data/api_response.dart';
import 'package:outc/partnerSidemenu/models/getstatementsresponse.dart';
import 'package:outc/partnerSidemenu/providers/statementsprovider.dart';
import 'package:outc/partnerSidemenu/reportfilterpages/statementsfilterpage.dart';
import 'package:outc/sidemenu/sidemenu.dart';
import 'package:outc/widgets/colors/colors.dart';
import 'package:outc/widgets/progress_bar.dart';
import 'package:outc/widgets/sharedprefservices.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class StatementReportsPage extends StatefulWidget {
  const StatementReportsPage({super.key});

  @override
  State<StatementReportsPage> createState() => _StatementReportsPageState();
}

class _StatementReportsPageState extends State<StatementReportsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var reportsProvider = context.watch<StatementReportsProvider>();

    reportsProvider.loadStatementReportsList();

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
            Selector<StatementReportsProvider,
                ApiResponse<GetStatementsResponse>?>(
              selector: (_, apiResponse) => apiResponse.getStatementsResponse,
              builder: (_, instance, __) {
                if (instance?.status == Status.error) {
                  return FittedBox(
                      child: Text(instance?.errorMessage ?? "error"));
                } else if (instance?.status == Status.loading) {
                  return const Expanded(child: ProgressBarHUD());
                } else if (instance?.status == Status.completed) {
                  List<Datum?> statementReportsListData =
                      instance?.data?.data ?? [];
                  return statementReportsListData.isEmpty
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
                              itemCount: statementReportsListData.length,
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
                                                    Text(
                                                      statementReportsListData[
                                                                  index]
                                                              ?.name
                                                              .toString() ??
                                                          "",
                                                      style: TextStyle(
                                                        fontSize: 14.0,
                                                        color:
                                                            Colours.strongRed,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: 'poppins',
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 6.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        const Text(
                                                          "Net Balance      : ",
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
                                                          statementReportsListData[
                                                                      index]
                                                                  ?.netBalance
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
                                                          "Date                   : ",
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
                                                          DateFormat(
                                                                  'dd-MM-yyyy')
                                                              .format(DateTime.parse(
                                                                  statementReportsListData[
                                                                              index]
                                                                          ?.createdOn
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
                                                        "Amount           : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        statementReportsListData[
                                                                    index]
                                                                ?.amount
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
                                                        "Credit              : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        statementReportsListData[
                                                                    index]
                                                                ?.credit
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
                                                        "Debit                : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                      Text(
                                                        statementReportsListData[
                                                                    index]
                                                                ?.debit
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
                                                    height: 4.0,
                                                  ),
                                                  const Divider(
                                                    height: 2.0,
                                                  ),
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  const Row(
                                                    children: [
                                                      Text(
                                                        " Remarks         : ",
                                                        style: TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontFamily: 'poppins',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 4.0,
                                                  ),
                                                  Text(
                                                    statementReportsListData[
                                                                index]
                                                            ?.remarks
                                                            .toString() ??
                                                        "",
                                                    style: const TextStyle(
                                                      fontSize: 14.0,
                                                      color: Colors.black,
                                                      fontFamily: 'poppins',
                                                    ),
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
                  child: const StatementFilterPage(),
                ),
              );
            },
          ),
          const Text(
            "Statement Reports",
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
