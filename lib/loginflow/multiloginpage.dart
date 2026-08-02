import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/core/module_registry.dart';
import 'package:outc/core/theme/design_tokens.dart';
import 'package:outc/loginflow/agentloginpage.dart';
import 'package:outc/loginflow/userloginpage.dart';

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
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, AppColors.border],
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
                        color: AppColors.primary),
                  ),
                Center(
                  child: Column(
                    children: [
                      SvgPicture.asset('images/OutcLogoNew.svg', width: 130),
                      const SizedBox(height: 8),
                      Text(
                        "Book flights, hotels, buses & more",
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: AppShadows.elevated,
                    ),
                    child: showToggle
                        ? DefaultTabController(
                            length: 2,
                            initialIndex: widget.startOnAgent ? 1 : 0,
                            child: Column(
                              children: [
                                Container(
                                  height: 44,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: SegmentedTabControl(
                                    barDecoration: BoxDecoration(
                                      color: AppColors.subtleBackground,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    indicatorDecoration: BoxDecoration(
                                      color: AppColors.primary,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    tabTextColor: AppColors.textSecondary,
                                    selectedTabTextColor: Colors.white,
                                    textStyle: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    indicatorPadding: const EdgeInsets.all(3),
                                    tabs: const [
                                      SegmentTab(
                                        color: AppColors.primary,
                                        label: 'Personal Account',
                                      ),
                                      SegmentTab(
                                        color: AppColors.primary,
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
