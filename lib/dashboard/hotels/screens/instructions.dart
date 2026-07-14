import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Instructions extends StatefulWidget {
  const Instructions({super.key});

  @override
  State<Instructions> createState() => _InstructionsState();
}

class _InstructionsState extends State<Instructions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(right: 10, left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Text(
              'Instructions',
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 250,
                    child: Text(
                      'Extra-person  charges may apply and vary depending on property.',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 250,
                    child: Text(
                      'Government-issued photo identification and a credit card , debit card ,or cash deposit may be requreid at check-in for incidental charges.',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check,
                  color: Colors.blue,
                  size: 30,
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                    width: 250,
                    child: Text(
                      'Government-issued photo identification and a credit card , debit card ,or cash deposit may be requreid at check-in for incidental charges.',
                      style: GoogleFonts.poppins(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
