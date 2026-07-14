import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// This code is copied from https://m2.material.io/design/typography/the-type-system.html#type-scale
//I use poppins Text Theme from Google Fonts
//Poppins
final appTextTheme = TextTheme(
  displayLarge: GoogleFonts.poppins(
    fontSize: 112,
    fontWeight: FontWeight.w300,
    letterSpacing: -1.5,
  ),
  displayMedium: GoogleFonts.poppins(
    fontSize: 70,
    fontWeight: FontWeight.w300,
    letterSpacing: -0.5,
  ),
  displaySmall: GoogleFonts.poppins(
    fontSize: 56,
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  headlineSmall: GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: GoogleFonts.poppins(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  ),
  titleMedium: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
  ),
  titleSmall: GoogleFonts.poppins(
      fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.1),
  bodyLarge: GoogleFonts.poppins(
    fontSize: 19,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  ),
  bodyMedium: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  ),
  labelLarge: GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.25,
  ),
  bodySmall: GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  ),
  labelSmall: GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.5,
  ),
);
