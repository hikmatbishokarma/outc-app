import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class visaCard extends StatelessWidget {
  final String imageUrl;
  final String visaName;
  final String country;
  final String continent;
  final String typeofVisa;
  final String processingTime;
  final String stayperiod;
  final String validity;
  final String entry;
  final String fees;
  final VoidCallback onTap;
  final String buttonText;
  const visaCard({
    super.key,
    required this.imageUrl,
    required this.visaName,
    required this.country,
    required this.continent,
    required this.typeofVisa,
    required this.processingTime,
    required this.stayperiod,
    required this.validity,
    required this.entry,
    required this.fees,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: double.infinity,
        margin: const EdgeInsets.only(right: 5, left: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 160,
                  width: 130,
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      child: Image.asset(
                        imageUrl,
                        fit: BoxFit.cover,
                      )),
                ),
                const SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          visaName,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          country,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              height: 1.2),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          continent,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Valid till : $typeofVisa',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        GestureDetector(
                          onTap: onTap,
                          child: Chip(
                            side: BorderSide.none,
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            padding: const EdgeInsets.all(0),
                            backgroundColor: Colors.orange,
                            shadowColor: Colors.black,
                            label: Text(
                              buttonText,
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
