import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:outc/widgets/colors/colors.dart';

Widget buildNote(String? title, String? value) {
  return (value?.isEmpty ?? true)
      ? const SizedBox()
      : Card(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colours.borderGrey,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                  top: 10.0, right: 8.0, bottom: 5.0, left: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colours.orangeOutC,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      SizedBox(
                        height: 24,
                        width: 24,
                        child: Image.asset(
                          'images/rightarrow.png',
                          color: Colours.veryDarkGrey,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    value ?? "",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colours.veryDarkGrey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
}
