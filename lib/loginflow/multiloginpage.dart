import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/loginflow/agentloginpage.dart';
import 'package:outc/loginflow/userloginpage.dart';
import 'package:outc/widgets/colors/colors.dart';

class MultiLoginScreen extends StatefulWidget {
  final bool isGateMode;
  const MultiLoginScreen({super.key, this.isGateMode = false});
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
                const SizedBox(height: 20),
                Expanded(
                  child: UserLogin(isGateMode: widget.isGateMode),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              _AgentLoginScreen(isGateMode: widget.isGateMode),
                        ),
                      );
                    },
                    child: Text(
                      'Partner / Agent Login',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
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

class _AgentLoginScreen extends StatelessWidget {
  final bool isGateMode;
  const _AgentLoginScreen({required this.isGateMode});

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
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black87),
          title: Text(
            'Partner / Agent Login',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            child: AgentLogin(isGateMode: isGateMode),
          ),
        ),
      ),
    );
  }
}
