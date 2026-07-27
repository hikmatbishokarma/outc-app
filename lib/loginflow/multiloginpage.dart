import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/core/module_registry.dart';
import 'package:outc/loginflow/agentloginpage.dart';
import 'package:outc/loginflow/userloginpage.dart';
import 'package:outc/widgets/colors/colors.dart';

class MultiLoginScreen extends StatefulWidget {
  final bool isGateMode;
  final bool startOnAgent;
  const MultiLoginScreen({
    super.key,
    this.isGateMode = false,
    this.startOnAgent = false,
  });
  @override
  State<MultiLoginScreen> createState() => _MultiLoginScreenState();
}

class _MultiLoginScreenState extends State<MultiLoginScreen> {
  @override
  Widget build(BuildContext context) {
    final showToggle = !widget.isGateMode && ModuleRegistry.agentEnabled;

    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colours.dardModerateBlue, Colours.skyBlue],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Navigator.canPop(context))
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    icon: const Icon(Icons.arrow_back_ios_new_outlined,
                        color: Colors.white),
                  ),
                Center(
                  child: Container(
                    height: 150.0,
                    alignment: Alignment.topCenter,
                    child: Center(child: Image.asset('images/outc.png')),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: showToggle
                      ? DefaultTabController(
                          length: 2,
                          initialIndex: widget.startOnAgent ? 1 : 0,
                          child: Column(
                            children: [
                              Container(
                                height: 45,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: SegmentedTabControl(
                                  tabTextColor: Colors.black,
                                  selectedTabTextColor: Colors.white,
                                  textStyle: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'poppins',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  indicatorPadding: const EdgeInsets.all(3),
                                  tabs: [
                                    SegmentTab(
                                      color: Colours.orangeOutC,
                                      label: 'Personal Account',
                                    ),
                                    SegmentTab(
                                      color: Colours.orangeOutC,
                                      label: 'Partner/Agent Account',
                                    ),
                                  ],
                                ),
                              ),
                              const Expanded(
                                child: TabBarView(
                                  children: [
                                    UserLogin(isGateMode: false),
                                    AgentLogin(isGateMode: false),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : UserLogin(isGateMode: widget.isGateMode),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
