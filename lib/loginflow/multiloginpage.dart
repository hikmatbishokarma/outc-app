import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/loginflow/agentloginpage.dart';
import 'package:outc/loginflow/userloginpage.dart';
import 'package:outc/widgets/colors/colors.dart';

class MultiLoginScreen extends StatefulWidget {
  const MultiLoginScreen({super.key});
  @override
  State<MultiLoginScreen> createState() => _MultiLoginScreenState();
}

class _MultiLoginScreenState extends State<MultiLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.lightBlue, Colours.grey],
        ),
      ),
      child: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Container(
                margin: const EdgeInsets.only(right: 10, left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Container(
                        height: 150.0,
                        alignment: Alignment.topCenter,
                        child: Center(child: Image.asset('images/outc.png')),
                      ),
                    ),
                    // Center(
                    //   child: RichText(
                    //     text: const TextSpan(
                    //       text: 'Anj',
                    //       style: TextStyle(
                    //         fontSize: 25.0,
                    //         fontFamily: 'poppins',
                    //         fontWeight: FontWeight.w800,
                    //         color: Color(0xffbd0c21),
                    //       ),
                    //       children: <TextSpan>[
                    //         TextSpan(
                    //           text: "Mal",
                    //           style: TextStyle(
                    //             fontSize: 25.0,
                    //             fontFamily: 'poppins',
                    //             fontWeight: FontWeight.w800,
                    //             color: Color(0xff35459c),
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 20),
                    Container(
                      height: 45,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: SegmentedTabControl(
                        // backgroundColor: Colors.grey.shade100,
                        tabTextColor: Colors.black,
                        selectedTabTextColor: Colors.white,
                        textStyle: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'poppins',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        indicatorPadding: const EdgeInsets.all(3),
                        tabs: [
                          SegmentTab(
                            color: Colours.orangeOutC,
                            label: 'User Login',
                          ),
                          SegmentTab(
                            color: Colours.orangeOutC,
                            label: 'Agent Login',
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [UserLogin(), AgentLogin()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
